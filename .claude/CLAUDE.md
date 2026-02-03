# Configuracion Global de Claude Code

## Skills Disponibles

Los skills están ubicados en `~/.claude/skills/`. Invocar con `/nombre-skill` o usando triggers naturales.

| Comando | Descripción | Triggers |
|---------|-------------|----------|
| `/jira [tipo]` | Generar ticket JIRA | "crear jira", "generar jira" |
| `/teams [tipo]` | Generar mensaje Teams | "enviar teams", "mensaje teams" |
| `/outlook [tipo]` | Generar correo Outlook | "correo", "email", "outlook" |
| `/security [tema]` | Patrones seguridad Checkmarx | "checkmarx", "vulnerabilidad" |

### Tipos por skill:
- **jira**: `req`, `ops`, `bug`, `deploy`
- **teams**: `solicitud`, `info`, `bloqueo`, `seguimiento`, `deploy`, `consulta`
- **outlook**: `solicitud`, `info`, `urgente`, `seguimiento`, `revision`, `entrega`
- **security**: `redirect`, `log`, `hsts`, `xss`, `sca`, `sanitizers`

Cuando se invoque un skill, leer el archivo correspondiente en `~/.claude/skills/[nombre].md`

## Git Hooks Globales

Configuración centralizada de hooks en `~/.git-hooks/` usando `core.hooksPath`.

### Hooks Activos
- **pre-push**: Bloquea push directo a ramas protegidas (main, master, develop)

### Ubicación
- Directorio: `/home/administrador/.git-hooks/`
- Configuración: `git config --global core.hooksPath ~/.git-hooks`

### Comportamiento
- Push a `main`, `master` o `develop` es bloqueado en todos los repositorios
- Push a ramas feature funciona normalmente
- Para integrar a ramas protegidas: usar Merge Request (GitLab) o Pull Request (GitHub)

---

# Reglas de Desarrollo Spring Boot / Java

## Arquitectura por Capas

```
Controller Layer (@RestController)
    ↓ (uses DTOs)
Service Layer (@Service)
    ↓ (uses Entities)
Repository Layer (@Repository)
    ↓
Database
```

**Reglas:**
- Controllers NUNCA inyectan Repositories directamente (usar Services)
- Services manejan toda la lógica de negocio
- DTOs transfieren datos entre Controller y Service
- Entities solo representan tablas, sin lógica de negocio
- Validators manejan validación compleja por separado

## Patrones de Código

### Inyección de Dependencias
```java
@RequiredArgsConstructor
@Service
public class ExampleServiceImpl implements ExampleService {
    private final ExampleRepository repository;
    private final ExampleMapper mapper;
}
```

### Controller Pattern
```java
@RestController
@Slf4j
@RequiredArgsConstructor
@Validated
@Tag(name = "API Name", description = "Description")
public class ExampleController {
    private final ExampleService service;

    @Operation(summary = "Summary")
    @GetMapping("/path")
    public ResponseEntity<Object> method(@Valid @PathVariable String param) {
        try {
            Result result = service.businessMethod(param);
            return ResponseEntity.ok(result);
        } catch (IllegalArgumentException e) {
            log.warn("Validation failed: {}", e.getMessage());
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
```

### Validation Pattern
```java
@Component
@RequiredArgsConstructor
public class ExampleValidator {
    public void validateInput(String input) {
        if (input == null || input.trim().isEmpty()) {
            throw new IllegalArgumentException("Input cannot be null or empty");
        }
    }
}
```

### JPA Entity Pattern
```java
@Entity
@Getter @Setter @ToString @NoArgsConstructor
@Table(name = "TABLE_NAME")
public class ExampleEntity implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "COLUMN_ID")
    private Long id;

    @Column(name = "COLUMN_NAME")
    private String fieldName;
}
```

### Testing Pattern (JUnit 5 + Mockito)
```java
@ExtendWith(MockitoExtension.class)
class ExampleTest {
    @Mock
    private DependencyService dependencyService;

    @InjectMocks
    private ServiceUnderTest service;

    @Test
    void testMethod_Success() {
        // Given
        when(dependencyService.someMethod(any())).thenReturn(mockResponse);

        // When
        Result result = service.methodUnderTest();

        // Then
        assertNotNull(result);
        assertEquals(expected, result);
        verify(dependencyService).someMethod(any());
    }
}
```

## Cobertura de Tests

| Capa | Line Coverage | Branch Coverage |
|------|---------------|-----------------|
| Overall | 80% | 70% |
| Controllers | 75% | 65% |
| Services | 85% | 75% |
| Utilities | 90% | 80% |

## Logging Standards

Usar SLF4J con Lombok `@Slf4j`:
```java
// INFO: Operaciones de negocio
log.info("Processing request for: {}", sanitizedInput);

// WARN: Fallos de validación
log.warn("Invalid format: {}", sanitizedInput);

// ERROR: Excepciones
log.error("Database error", exception);
```

**NUNCA loguear datos sensibles sin sanitizar.**

## Convenciones de Nombres

| Tipo | Convención | Ejemplo |
|------|------------|---------|
| Clases | PascalCase | `UserController`, `EventService` |
| Métodos | camelCase | `getUserById`, `validateInput` |
| Constantes | UPPER_SNAKE_CASE | `MAX_LIMIT`, `DEFAULT_PAGE_SIZE` |
| Columnas DB | UPPER_SNAKE_CASE | `USER_ID`, `CREATED_AT` |

## Uso de Lombok

- `@RequiredArgsConstructor` para inyección por constructor
- `@Getter/@Setter` para entities y DTOs
- `@Slf4j` para logging
- `@NoArgsConstructor` para entities JPA
- `@Builder` para DTOs complejos

---

# Prácticas de Seguridad (Checkmarx/OWASP)

## Input Validation
- Usar validadores con whitelist
- Validar formatos con regex estrictos antes de procesar
- Crear anotaciones custom (`@ValidId`, `@ValidEmail`)

## SQL Injection Prevention
- Usar JPA con `@Param` para parametrización automática
- Para JSON en Oracle, usar `JSON_VALUE()` (nunca concatenar strings)
- Evitar queries dinámicas construidas con strings
- Queries nativas siempre con parámetros nombrados (`:param`)

## Log Injection Prevention
- Sanitizar input del usuario antes de loguear
- Eliminar caracteres de control (\r, \n, \t)
- Limitar longitud de strings logueados

```java
public static String sanitizeForLogging(String input) {
    if (input == null) return "null";
    return input.replaceAll("[\\r\\n\\t]", "_")
                .substring(0, Math.min(input.length(), 200));
}
```

## XSS Prevention
- Escapar caracteres HTML en respuestas
- Usar librerías como OWASP Encoder
- Configurar Jackson para escapar automáticamente

## File Upload Security
- Validar MIME type, tamaño y extensión
- Rechazar patrones de path traversal (`..`, `/`, `\`)
- Configurar límites máximos de tamaño

## Date Validation
- Validar fechas ISO 8601 con regex Y parsing real
- Formato esperado: `yyyy-MM-ddTHH:mm:ss`

---

# Comandos Maven Comunes

```bash
# Compilar
mvn clean compile

# Ejecutar aplicación
mvn spring-boot:run

# Ejecutar con profile
mvn spring-boot:run -Dspring-boot.run.profiles=dev

# Tests
mvn test

# Test específico
mvn test -Dtest=NombreTest

# Cobertura
mvn clean test jacoco:report

# Package sin tests
mvn clean package -DskipTests
```
