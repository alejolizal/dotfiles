# Skill: /security

Consulta patrones de seguridad para resolver vulnerabilidades Checkmarx/OWASP en Spring Boot.

## Invocación

- Comando: `/security [tema]`
- Triggers: "revisar seguridad", "checkmarx", "vulnerabilidad", "sanitizar"

## Temas disponibles

| Comando | Tema | CWE |
|---------|------|-----|
| `/security redirect` | Open Redirect | CWE-601 |
| `/security log` | Log Forging | CWE-117 |
| `/security hsts` | HSTS Missing | CWE-346 |
| `/security xss` | Cross-Site Scripting | CWE-79 |
| `/security sca` | Dependencias vulnerables | - |
| `/security sanitizers` | Sanitizadores reconocidos | - |

Si no se especifica tema, mostrar índice de patrones disponibles.

---

# Patrones de Seguridad para Spring Boot - Guía Checkmarx

## Índice

1. [Open Redirect (CWE-601)](#1-open-redirect-cwe-601)
2. [Log Forging (CWE-117)](#2-log-forging-cwe-117)
3. [HSTS Missing (CWE-346)](#3-hsts-missing-cwe-346)
4. [XSS (CWE-79)](#4-xss-cwe-79)
5. [Dependencias SCA](#5-dependencias-sca)
6. [Sanitizadores Reconocidos por Checkmarx](#6-sanitizadores-reconocidos-por-checkmarx)

---

## 1. Open Redirect (CWE-601)

### Problema
Checkmarx detecta que datos de entrada del usuario fluyen hacia `ResponseEntity` y lo interpreta como posible redirección.

### Falso Positivo Común
`ResponseEntity<?>` en `@RestController` retorna **JSON**, no redirecciones HTTP. Sin embargo, Checkmarx no siempre lo reconoce.

### Soluciones

#### Opción A: Tipos de respuesta explícitos (Recomendado)

```java
// ANTES (Checkmarx marca como vulnerable)
@GetMapping("/endpoint")
public ResponseEntity<?> metodo(@PathVariable String param) {
    return new ResponseEntity<>(data, HttpStatus.OK);
}

// DESPUÉS (tipo explícito)
@GetMapping("/endpoint")
public ResponseEntity<MiDTO> metodo(@PathVariable String param) {
    return ResponseEntity.ok()
        .contentType(MediaType.APPLICATION_JSON)
        .body(data);
}
```

#### Opción B: Wrapper ApiResponse genérico

```java
/**
 * Wrapper que previene Open Redirect al usar tipos explícitos.
 */
@Getter @Setter @Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiResponse<T> {
    private boolean success;
    private T data;
    private String message;
    private String errorCode;

    public static <T> ResponseEntity<ApiResponse<T>> ok(T data) {
        return ResponseEntity.ok()
            .contentType(MediaType.APPLICATION_JSON)
            .body(ApiResponse.<T>builder().success(true).data(data).build());
    }

    public static <T> ResponseEntity<ApiResponse<T>> error(String message, HttpStatus status) {
        return ResponseEntity.status(status)
            .contentType(MediaType.APPLICATION_JSON)
            .body(ApiResponse.<T>builder().success(false).message(message).build());
    }
}

// Uso en controller
return ApiResponse.ok(miData);
return ApiResponse.error("Error mensaje", HttpStatus.BAD_REQUEST);
```

#### Opción C: Sanitización con StringEscapeUtils

```java
// Agregar dependencia
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-text</artifactId>
    <version>1.12.0</version>
</dependency>

// Sanitizar inputs
import org.apache.commons.text.StringEscapeUtils;

public static String sanitizeInput(String input) {
    if (input == null) return null;
    return StringEscapeUtils.escapeHtml4(input.trim());
}
```

#### Opción D: Marcar como "Not Exploitable"

**Justificación para Checkmarx:**
```
El endpoint retorna ResponseEntity<DTO> que serializa a JSON (Content-Type: application/json).
No existe mecanismo de redirección HTTP en Spring @RestController sin uso explícito de
HttpServletResponse.sendRedirect() o RedirectView. CWE-601 no aplica a respuestas JSON.
```

---

## 2. Log Forging (CWE-117)

### Problema
Datos de entrada del usuario se escriben en logs sin sanitizar, permitiendo inyección de entradas falsas.

### Solución

```java
import org.apache.commons.text.StringEscapeUtils;

/**
 * Sanitiza string para logging.
 * Usa StringEscapeUtils.escapeHtml4 reconocido por Checkmarx.
 */
public static String sanitizeForLogging(String input) {
    if (input == null) return "null";
    String escaped = StringEscapeUtils.escapeHtml4(input);
    String sanitized = escaped.replaceAll("[\\r\\n\\t]", "").trim();
    return sanitized.length() > 200 ? sanitized.substring(0, 200) + "..." : sanitized;
}

// Uso
log.info("Usuario: {}", SecurityUtils.sanitizeForLogging(userId));
```

### Parámetros con @Pattern

Si el parámetro tiene `@Pattern` restrictivo, Checkmarx puede seguir marcándolo. Usar sanitización explícita:

```java
// Aunque dv tiene @Pattern("[0-9K]"), sanitizar para que Checkmarx lo reconozca
log.info("RUT: {}-{}", rut, SecurityUtils.sanitizeForLogging(dv));
```

---

## 3. HSTS Missing (CWE-346)

### Problema
Respuestas HTTP no incluyen header `Strict-Transport-Security`.

### Solución: SecurityHeaderFilter

```java
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class SecurityHeaderFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        if (response instanceof HttpServletResponse httpResponse) {
            // HSTS - solo HTTPS, 1 año, incluir subdominios
            httpResponse.setHeader("Strict-Transport-Security",
                "max-age=31536000; includeSubDomains");
            // Headers de seguridad adicionales
            httpResponse.setHeader("X-Content-Type-Options", "nosniff");
            httpResponse.setHeader("X-Frame-Options", "DENY");
            httpResponse.setHeader("X-XSS-Protection", "1; mode=block");
            httpResponse.setHeader("Content-Security-Policy",
                "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'");
            httpResponse.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
            httpResponse.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        }
        chain.doFilter(request, response);
    }
}
```

### Interceptors que escriben directamente a response

Si un interceptor escribe directamente a `HttpServletResponse`, los headers no se agregan. Solución: usar excepciones manejadas por `@ExceptionHandler`:

```java
// ANTES (HSTS no se aplica)
@Override
public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
    response.setStatus(429);
    response.getWriter().write("{\"error\":\"Rate limit\"}");
    return false;
}

// DESPUÉS (excepción manejada por GlobalExceptionHandler, HSTS se aplica)
@Override
public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
    throw new RateLimitExceededException(maxRequests);
}

// En GlobalExceptionHandler
@ExceptionHandler(RateLimitExceededException.class)
public ResponseEntity<Map<String, Object>> handleRateLimit(RateLimitExceededException ex) {
    return new ResponseEntity<>(errorMap, HttpStatus.TOO_MANY_REQUESTS);
}
```

---

## 4. XSS (CWE-79)

### Solución

```java
import org.apache.commons.text.StringEscapeUtils;

// Escapar salida HTML
String safe = StringEscapeUtils.escapeHtml4(userInput);

// Para JSON, Jackson escapa automáticamente, pero verificar configuración:
@Configuration
public class JacksonConfig {
    @Bean
    public Jackson2ObjectMapperBuilderCustomizer jsonCustomizer() {
        return builder -> builder
            .featuresToEnable(JsonGenerator.Feature.ESCAPE_NON_ASCII);
    }
}
```

---

## 5. Dependencias SCA

### Patrón para override de versiones vulnerables

```xml
<dependencyManagement>
    <dependencies>
        <!-- CVE-XXXX-XXXXX: Descripción breve -->
        <dependency>
            <groupId>grupo</groupId>
            <artifactId>artefacto</artifactId>
            <version>version-segura</version>
        </dependency>
    </dependencies>
</dependencyManagement>
```

### Ejemplos comunes

```xml
<!-- CVE-2025-48976: DoS en commons-fileupload < 1.6.0 -->
<dependency>
    <groupId>commons-fileupload</groupId>
    <artifactId>commons-fileupload</artifactId>
    <version>1.6.0</version>
</dependency>

<!-- CVE-2025-8916: BouncyCastle < 1.79 -->
<dependency>
    <groupId>org.bouncycastle</groupId>
    <artifactId>bcprov-jdk18on</artifactId>
    <version>1.79</version>
</dependency>

<!-- CVE-2026-1225: logback < 1.5.25 -->
<dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-core</artifactId>
    <version>1.5.25</version>
</dependency>

<!-- CVE-2025-48924: commons-lang3 < 3.18.0 -->
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
    <version>3.18.0</version>
</dependency>
```

---

## 6. Sanitizadores Reconocidos por Checkmarx

### Métodos que Checkmarx reconoce automáticamente

| Librería | Método | Uso |
|----------|--------|-----|
| Apache Commons Text | `StringEscapeUtils.escapeHtml4()` | XSS, Log Forging |
| Apache Commons Text | `StringEscapeUtils.escapeJava()` | Strings en código |
| OWASP Encoder | `Encode.forHtml()` | XSS |
| OWASP Encoder | `Encode.forJavaScript()` | XSS en JS |
| Spring | `HtmlUtils.htmlEscape()` | XSS |
| Spring | `UriComponentsBuilder` (algunos métodos) | Open Redirect |

### Métodos que Checkmarx NO reconoce automáticamente

| Método | Problema |
|--------|----------|
| `String.replaceAll()` | No reconocido como sanitizer |
| Métodos custom | Requieren configuración en Checkmarx |
| `new String(input)` | Copia defensiva no reconocida |

### Recomendación

Siempre usar `StringEscapeUtils.escapeHtml4()` como primer paso de sanitización:

```java
public static String sanitizeInput(String input) {
    if (input == null) return null;
    // StringEscapeUtils es reconocido por Checkmarx
    String escaped = StringEscapeUtils.escapeHtml4(input.trim());
    // Validaciones adicionales después del escape
    if (!escaped.matches("^[a-zA-Z0-9_-]+$")) {
        throw new IllegalArgumentException("Input inválido");
    }
    return escaped;
}
```

---

## Checklist de Seguridad para Nuevos Proyectos

- [ ] Agregar `commons-text` para sanitización
- [ ] Crear `SecurityUtils` con métodos de sanitización
- [ ] Crear `SecurityHeaderFilter` para HSTS
- [ ] Crear `ApiResponse` wrapper para respuestas tipadas
- [ ] Configurar `GlobalExceptionHandler` para manejar excepciones de seguridad
- [ ] Revisar `dependencyManagement` para CVEs conocidos
- [ ] Usar tipos específicos en `ResponseEntity<TipoEspecifico>` en lugar de `ResponseEntity<?>`

---

## Referencias

- [CWE-601: Open Redirect](https://cwe.mitre.org/data/definitions/601.html)
- [CWE-117: Log Forging](https://cwe.mitre.org/data/definitions/117.html)
- [CWE-346: HSTS Missing](https://cwe.mitre.org/data/definitions/346.html)
- [CWE-79: XSS](https://cwe.mitre.org/data/definitions/79.html)
- [OWASP Top 10](https://owasp.org/Top10/)
- [Apache Commons Text](https://commons.apache.org/proper/commons-text/)
