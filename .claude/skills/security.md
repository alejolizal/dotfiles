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
| `/security tampering` | Parameter Tampering | CWE-472 |
| `/security binding` | Unsafe Object Binding | CWE-915 |
| `/security zipslip` | Path Traversal / Zip Slip | CWE-22 |
| `/security leak` | Resource Leak | CWE-404 |
| `/security credentials` | Credenciales Hardcodeadas | CWE-798 |
| `/security sca` | Dependencias vulnerables | - |
| `/security sanitizers` | Sanitizadores reconocidos | - |

Si no se especifica tema, mostrar índice de patrones disponibles.

## Flujo de resolución con plantillas

Cuando el usuario pida resolver un hallazgo Checkmarx:

1. **Leer la plantilla de referencia** del hallazgo en `/home/dev/eventos/backend/eventos-ms/scripts/`:
   - `Open_redirect.md` — Open Redirect (CWE-601)
   - `Unsafe_Object_Binding.md` — Unsafe Object Binding (CWE-915)
   - `missing_hsts_headers.md` — HSTS Missing (CWE-346)
   - `reportes_Parameter_Tampering.md` — Parameter Tampering (CWE-472)
   - `reportes_XSS.md` — Stored XSS en AlertasController (CWE-79)
   - `reportes_XSS_2.md` — Stored XSS en DiagnosticoAlertasController (CWE-79)

2. **Identificar** el archivo y línea exacta del hallazgo desde la plantilla

3. **Aplicar el patrón de solución** de esta guía (secciones abajo)

4. **Verificar** que el sanitizer/fix sea reconocido por Checkmarx (ver sección 6)

5. **Si es falso positivo**, generar justificación para marcar como "Not Exploitable"

---

# Patrones de Seguridad para Spring Boot - Guía Checkmarx

## Índice

1. [Open Redirect (CWE-601)](#1-open-redirect-cwe-601)
2. [Log Forging (CWE-117)](#2-log-forging-cwe-117)
3. [HSTS Missing (CWE-346)](#3-hsts-missing-cwe-346)
4. [XSS (CWE-79)](#4-xss-cwe-79)
5. [Parameter Tampering (CWE-472)](#5-parameter-tampering-cwe-472)
6. [Unsafe Object Binding (CWE-915)](#6-unsafe-object-binding-cwe-915)
7. [Zip Slip / Path Traversal (CWE-22)](#7-zip-slip--path-traversal-cwe-22)
8. [Resource Leak (CWE-404)](#8-resource-leak-cwe-404)
9. [Credenciales Hardcodeadas (CWE-798)](#9-credenciales-hardcodeadas-cwe-798)
10. [Dependencias SCA](#10-dependencias-sca)
11. [Sanitizadores Reconocidos por Checkmarx](#11-sanitizadores-reconocidos-por-checkmarx)

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

## 5. Parameter Tampering (CWE-472)

### Problema
Checkmarx detecta que datos del usuario (`@RequestBody`) fluyen directamente a operaciones de base de datos (`repository.save()`) sin validación intermedia, permitiendo manipulación de parámetros.

### Soluciones

#### Opción A: Validación explícita con DTO + Validator (Recomendado)

```java
// DTO con restricciones
@Getter @Setter
public class EventoReq {
    @NotBlank @Size(max = 100)
    private String codigo;

    @NotBlank @Pattern(regexp = "^[A-Z_]+$")
    private String tipo;
}

// Validator dedicado
@Component
@RequiredArgsConstructor
public class EventoValidator {
    public void validate(EventoReq req) {
        if (req.getCodigo() == null || !req.getCodigo().matches("^[A-Z0-9_-]+$")) {
            throw new IllegalArgumentException("Código inválido");
        }
    }
}

// Controller con @Valid + validator
@PostMapping("/eventos")
public ResponseEntity<EventoResponse> crear(@Valid @RequestBody EventoReq req) {
    validator.validate(req);
    return ResponseEntity.ok(service.crear(req));
}
```

#### Opción B: Mapeo explícito DTO → Entity (rompe flujo tainted)

```java
// En el Service — NO pasar el DTO directo al repository
public EventoResponse crear(EventoReq req) {
    EventoEntity entity = new EventoEntity();
    entity.setCodigo(StringEscapeUtils.escapeHtml4(req.getCodigo()));
    entity.setTipo(req.getTipo());
    return mapper.toResponse(repository.save(entity));
}
```

### Justificación para falso positivo
```
El DTO usa @Valid con Bean Validation (JSR 380). Los campos tienen @NotBlank,
@Size y @Pattern que restringen los valores aceptados. Adicionalmente, un
Validator dedicado valida reglas de negocio antes de persistir. No existe
concatenación SQL directa — se usa JPA con parámetros tipados.
```

---

## 6. Unsafe Object Binding (CWE-915)

### Problema
Checkmarx detecta que un `@RequestBody` con un objeto complejo expone setters públicos que podrían ser manipulados por un atacante para modificar campos no intencionados.

### Soluciones

#### Opción A: DTOs separados para entrada (Recomendado)

```java
// DTO de entrada — SOLO los campos que el usuario puede enviar
@Getter @Setter
public class AplicacionCreateReq {
    @NotBlank
    private String nombre;
    @NotBlank
    private String version;
    // NO incluir id, fechaCreacion, estado, etc.
}

// En el Service — mapeo explícito
public AplicacionResponse crear(AplicacionCreateReq req) {
    AplicacionEntity entity = new AplicacionEntity();
    entity.setNombre(req.getNombre());
    entity.setVersion(req.getVersion());
    entity.setEstado("ACTIVO"); // valor controlado por el server
    return mapper.toResponse(repository.save(entity));
}
```

#### Opción B: @JsonIgnoreProperties en el DTO

```java
@Getter @Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class AplicacionReq {
    @NotBlank
    private String nombre;

    @JsonIgnore // No se puede setear desde el request
    private Long id;
}
```

### Justificación para falso positivo
```
El DTO de entrada (XxxReq) solo expone los campos permitidos para el usuario.
El mapeo a Entity se realiza de forma explícita en el Service, sin usar
BeanUtils.copyProperties() ni ModelMapper automático. Los campos sensibles
(id, fechas, estado) se controlan server-side.
```

---

## 7. Zip Slip / Path Traversal (CWE-22)

### Problema
Al descomprimir archivos ZIP, el nombre de la entrada se resuelve directamente contra el directorio destino sin validar que la ruta resultante permanezca dentro del directorio permitido. Un ZIP malicioso con entradas como `../../etc/cron.d/malicious` puede escribir archivos arbitrarios en el sistema.

### Solución

```java
// ANTES (vulnerable)
Path out = targetDir.resolve(entry.getName());

// DESPUÉS (seguro) — normalizar + validar
Path out = targetDir.resolve(entry.getName()).normalize();
if (!out.startsWith(targetDir)) {
    throw new SecurityException("Zip Slip detectado: " + entry.getName());
}
```

### Puntos clave
- Siempre usar `.normalize()` para resolver `..` en la ruta
- Validar con `.startsWith(targetDir)` que la ruta quede dentro del destino
- Lanzar `SecurityException` si se detecta traversal
- Aplica a `ZipInputStream`, `ZipFile`, `TarArchiveInputStream`, etc.

### Proyecto de referencia
- `centauri-batch`: `ZipLogExtractor.java`

---

## 8. Resource Leak (CWE-404)

### Problema
`Files.lines()` retorna un `Stream<String>` respaldado por un `BufferedReader` que debe cerrarse explícitamente. Si no se cierra, genera file handle leak que puede causar "Too many open files" al procesar muchos archivos.

### Solución

```java
// ANTES (vulnerable — stream nunca se cierra)
int totalLines = (int) Files.lines(logFile.toPath()).count();

// DESPUÉS (seguro — try-with-resources)
try (Stream<String> lines = Files.lines(logFile.toPath())) {
    int totalLines = (int) lines.count();
}
```

### Otros casos comunes

```java
// InputStream/OutputStream — siempre try-with-resources
try (InputStream is = new FileInputStream(file);
     BufferedReader reader = new BufferedReader(new InputStreamReader(is))) {
    // procesar
}

// Connection/Statement JDBC
try (Connection conn = dataSource.getConnection();
     PreparedStatement ps = conn.prepareStatement(sql)) {
    // ejecutar
}
```

### Puntos clave
- Todo recurso que implemente `AutoCloseable` debe ir en try-with-resources
- `Files.lines()`, `Files.list()`, `Files.walk()` retornan streams que DEBEN cerrarse
- `BufferedReader`, `InputStream`, `OutputStream`, `Connection`, `Statement`, `ResultSet`

### Proyecto de referencia
- `centauri-batch`: `LogItemReader.java`

---

## 9. Credenciales Hardcodeadas (CWE-798)

### Problema
Contraseñas, tokens o API keys escritos en texto plano en archivos de configuración (`application.properties`, `application.yml`) o código fuente. Cualquier persona con acceso al repositorio puede ver las credenciales.

### Solución

```properties
# ANTES (vulnerable)
spring.datasource.url=jdbc:postgresql://10.30.230.21:5432/dbcentauri
spring.datasource.username=centauri
spring.datasource.password=6tT552j.d

# DESPUÉS (seguro) — variables de entorno con defaults seguros
spring.datasource.url=${DB_URL:jdbc:postgresql://localhost:5432/dbcentauri}
spring.datasource.username=${DB_USERNAME:centauri}
spring.datasource.password=${DB_PASSWORD:}
```

### Puntos clave
- Usar `${ENV_VAR:default}` de Spring para externalizar credenciales
- El default de password debe ser vacío (`${DB_PASSWORD:}`) — nunca un password real
- El default de URL puede apuntar a localhost para desarrollo local
- En produccion, las variables se configuran en el entorno (K8s secrets, Docker env, etc.)
- Aplica a: passwords de BD, API keys, tokens JWT secret, claves de encriptacion

### Alternativas
- Spring Cloud Config Server
- HashiCorp Vault
- Kubernetes Secrets / ConfigMaps
- Jasypt para encriptar properties

### Proyecto de referencia
- `centauri-batch`: `application.properties`

---

## 10. Dependencias SCA (Software Composition Analysis)

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

### Ejemplos Spring Boot 3.x (eventos-ms)

```xml
<dependencyManagement>
    <dependencies>
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
    </dependencies>
</dependencyManagement>
```

### Ejemplos Spring Boot 2.7.x (centauri-batch)

**IMPORTANTE:** Si el proyecto usa BOM como `import` (no `<parent>`), los property
overrides **NO funcionan**. Hay que usar entradas explícitas en `<dependencyManagement>`
**ANTES** del BOM import. El orden importa: Maven usa la primera versión que encuentra.

Para proyectos con `<parent>` de Spring Boot se usan property overrides:

```xml
<properties>
    <!-- SCA Remediation -->
    <snakeyaml.version>1.33</snakeyaml.version>          <!-- CVE-2022-1471 (CRITICAL) + 6 más -->
    <logback.version>1.2.13</logback.version>             <!-- CVE-2023-6481/6378 (HIGH) + 4 más -->
    <xmlunit2.version>2.10.0</xmlunit2.version>           <!-- CVE-2024-31573 (CRITICAL, test) -->
    <assertj.version>3.24.2</assertj.version>             <!-- CVE-2026-24400 (HIGH, test) -->
    <json-path.version>2.9.0</json-path.version>          <!-- CVE-2023-51074 (MEDIUM, test) -->
    <spring-framework.version>5.3.37</spring-framework.version> <!-- CVE-2025-41249 + 10 más -->
</properties>
```

Y dependencias directas con version pin:

```xml
<!-- CVE-2024-1597: SQL Injection en PostgreSQL -->
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <version>42.3.10</version>
    <scope>runtime</scope>
</dependency>
<!-- CVE-2022-45868: Admin console exposure en H2 -->
<dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <version>2.2.224</version>
</dependency>
```

Para proyectos con BOM `import`, usar `<dependencyManagement>` explícito:

```xml
<dependencyManagement>
    <dependencies>
        <!-- Overrides ANTES del BOM -->
        <dependency>
            <groupId>org.yaml</groupId>
            <artifactId>snakeyaml</artifactId>
            <version>1.33</version>
        </dependency>
        <!-- Para Spring Framework, usar su propio BOM -->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-framework-bom</artifactId>
            <version>5.3.37</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
        <!-- Spring Boot BOM al final -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-dependencies</artifactId>
            <version>${spring.boot.version}</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

### Verificación post-remediación

```bash
# Ver versiones resueltas
mvn dependency:tree | grep -E "(snakeyaml|postgresql|logback|h2database|jackson)"

# Compilar y testear
mvn clean compile && mvn test

# Re-scan Checkmarx
./scripts/security/checkmarx-scan.sh
```

---

## 11. Sanitizadores Reconocidos por Checkmarx

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

### API REST (microservicios)
- [ ] Agregar `commons-text` para sanitización
- [ ] Crear `SecurityUtils` con métodos de sanitización
- [ ] Crear `SecurityHeaderFilter` para HSTS
- [ ] Crear `ApiResponse` wrapper para respuestas tipadas
- [ ] Configurar `GlobalExceptionHandler` para manejar excepciones de seguridad
- [ ] Revisar `dependencyManagement` para CVEs conocidos
- [ ] Usar tipos específicos en `ResponseEntity<TipoEspecifico>` en lugar de `ResponseEntity<?>`

### Batch / Procesos sin HTTP
- [ ] Crear `SecurityUtils` con `sanitizeForLogging()` (mismo patrón)
- [ ] Externalizar credenciales con `${ENV_VAR:default}`
- [ ] Proteger contra Zip Slip si procesa archivos comprimidos
- [ ] Usar try-with-resources para `Files.lines()`, streams, readers
- [ ] Revisar properties del BOM para override de versiones vulnerables

---

## Documentación de Remediación por Proyecto

Documentos de referencia con ejemplos reales de remediación aplicada:

| Proyecto | Tipo | Documento |
|----------|------|-----------|
| eventos-ms | SAST | `/home/dev/eventos/docs/backend/remediacion-seguridad-checkmarx.md` |
| eventos-ms | SCA | `/home/dev/eventos/backend/eventos-ms/scripts/security/reports/remediacion-scan-2026-02-16.md` |
| centauri-batch | SAST | `/home/dev/centauri/docs/batch/remediacion-seguridad-checkmarx.md` |
| centauri-batch | SCA | `/home/dev/centauri/backend/centauri-batch/scripts/security/reports/remediacion-scan-2026-02-26.md` |

### SecurityUtils por proyecto

| Proyecto | Ruta | Métodos |
|----------|------|---------|
| eventos-ms | `eventos-ms/src/.../util/SecurityUtils.java` | sanitizeForLogging, escapeHtml4, isValidRut, validateAndAdjustLimit |
| centauri-batch | `centauri-batch/src/.../util/SecurityUtils.java` | sanitizeForLogging, sanitizeMapForLogging, sanitizeString |

---

## Referencias

- [CWE-22: Path Traversal](https://cwe.mitre.org/data/definitions/22.html)
- [CWE-79: XSS](https://cwe.mitre.org/data/definitions/79.html)
- [CWE-117: Log Forging](https://cwe.mitre.org/data/definitions/117.html)
- [CWE-346: HSTS Missing](https://cwe.mitre.org/data/definitions/346.html)
- [CWE-404: Resource Leak](https://cwe.mitre.org/data/definitions/404.html)
- [CWE-472: Parameter Tampering](https://cwe.mitre.org/data/definitions/472.html)
- [CWE-601: Open Redirect](https://cwe.mitre.org/data/definitions/601.html)
- [CWE-798: Hardcoded Credentials](https://cwe.mitre.org/data/definitions/798.html)
- [CWE-915: Unsafe Object Binding](https://cwe.mitre.org/data/definitions/915.html)
- [OWASP Top 10](https://owasp.org/Top10/)
- [Apache Commons Text](https://commons.apache.org/proper/commons-text/)
