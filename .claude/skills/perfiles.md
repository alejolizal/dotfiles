# Skill: /perfiles

Genera configuración de perfilamiento de rutas para el Gateway institucional SII (Spring Cloud Gateway) en formato JIRA.

## Invocación

- Comando: `/perfiles [tipo]`
- Triggers: "configurar perfiles", "perfilamiento gw", "rutas gateway"

## Tipos disponibles

| Comando | Descripción |
|---------|-------------|
| `/perfiles ruta` | Generar configuración de una ruta individual |
| `/perfiles proyecto` | Generar configuración completa de un proyecto (múltiples rutas) |
| `/perfiles matriz` | Generar matriz de perfilamiento (tabla resumen) |

Si no se especifica tipo, preguntar al usuario.

---

## Modelo de Perfilamiento Gateway SII

El Gateway institucional usa un filtro `Authorization` custom con los siguientes parámetros:

| Parámetro | Descripción |
|-----------|-------------|
| `userIdRegex` | Regex para extraer el ID del usuario desde la URL del request |
| `userIdRegexGroup` | Grupo de captura: `1` = app-name (sin RUT), `2` = RUT del usuario |
| `profiles` | Perfil(es) requeridos. Vacío = cualquier usuario autenticado |
| `externalAuthzUrl` | URL de servicio de autorización externa (opcional) |

### 5 Niveles de Acceso

||Nivel||Descripción||userIdRegexGroup||profiles||externalAuthzUrl||
|1. Público|Sin filtro Authorization. Cualquiera accede.|N/A|N/A|N/A|
|2. Sesión + RUT match|Usuario autenticado, se valida que el RUT de la URL coincida con el de la sesión.|2|(vacío)|N/A|
|3. Sesión + RUT + Perfil|Igual al nivel 2, pero además requiere perfil específico.|2|Código perfil (ej: 2101)|N/A|
|4. Solo perfil (sin RUT)|No valida RUT en URL. Solo requiere que el usuario tenga el perfil.|1|Código perfil (ej: 2101)|N/A|
|5. Autorización externa|Delega la decisión a un servicio externo via URL.|1 o 2|Opcional|URL del servicio|

---

## Datos a Solicitar

Antes de generar, solicitar al usuario:

### Para `/perfiles ruta`
1. **Nombre del microservicio** (context-path, ej: `mi-app-ms`)
2. **Puerto del backend** (ej: `6080`)
3. **Endpoint específico** (ej: `/api/v1/contribuyentes/{rut}/documentos`)
4. **Nivel de acceso** (1-5, ver tabla arriba)
5. **Perfil requerido** (si nivel 3, 4 o 5, ej: `2101`)
6. **URL de autorización externa** (solo si nivel 5)

### Para `/perfiles proyecto`
1. **Nombre del microservicio** (context-path)
2. **Puerto del backend**
3. **Lista de endpoints** con su nivel de acceso:
   - Endpoint → Nivel → Perfil (si aplica)
4. **Ambiente destino** (DEVX, CERX, Producción)

### Para `/perfiles matriz`
1. **Nombre del microservicio**
2. **Lista de endpoints con niveles ya definidos** (o generarla desde la config existente)

---

## Instrucciones para Claude

Cuando el usuario solicite configurar perfiles:

1. Identificar el tipo (`ruta`, `proyecto`, `matriz`)
2. Solicitar los datos necesarios según el tipo
3. Generar la salida en **sintaxis JIRA** (NO Markdown)
4. Adaptar el regex al context-path del microservicio
5. Numerar las rutas secuencialmente

### Construcción del Regex

El regex se construye según el context-path del microservicio:

- **Con RUT en URL** (group=2):
  ```
  /mi-app-ms/api/v1/contribuyentes/(\d{1,12})/.*
  ```
  Regex escapado para YAML:
  ```
  userIdRegex: "/mi-app-ms/api/v1/contribuyentes/(\\d{1,12})/.*"
  ```

- **Sin RUT en URL** (group=1):
  ```
  /mi-app-ms/(.*)
  ```
  Regex escapado para YAML:
  ```
  userIdRegex: "/mi-app-ms/(.*)"
  ```

### Construcción de Predicates

```yaml
predicates:
  - Path=/mi-app-ms/api/v1/endpoint/**
```

Para múltiples paths en una misma ruta:
```yaml
predicates:
  - Path=/mi-app-ms/api/v1/path1/**,/mi-app-ms/api/v1/path2/**
```

### Construcción de URI

```yaml
uri: http://localhost:PUERTO
```

---

## Plantillas de Salida (Sintaxis JIRA)

### Plantilla: Ruta Individual (`/perfiles ruta`)

```
h2. Configuración de Ruta Gateway

h3. Microservicio: {{[nombre-ms]}}

{panel:title=Nivel de Acceso|borderStyle=dashed|borderColor=#ccc|bgColor=#ffffce}
*Nivel [N]:* [Descripción del nivel]
{panel}

h4. Configuración YAML

{code:yaml}
spring:
  cloud:
    gateway:
      routes:
        - id: [nombre-ms]-[descripcion-ruta]
          uri: http://localhost:[puerto]
          predicates:
            - Path=/[nombre-ms]/[path]/**
          filters:
            - name: Authorization
              args:
                userIdRegex: "/[nombre-ms]/[regex-pattern]"
                userIdRegexGroup: [1|2]
                profiles: [perfil o vacío]
{code}

h4. Detalle

||Parámetro||Valor||
|id|{{[nombre-ms]-[descripcion-ruta]}}|
|uri|{{http://localhost:[puerto]}}|
|Path predicate|{{/[nombre-ms]/[path]/**}}|
|userIdRegex|{{/[nombre-ms]/[regex]}}|
|userIdRegexGroup|[1 o 2]|
|profiles|[perfil o _(vacío - cualquier autenticado)_]|
```

### Plantilla: Proyecto Completo (`/perfiles proyecto`)

```
h1. [OPS] Configuración de Perfilamiento Gateway - [nombre-ms]

h2. Resumen

||Campo||Valor||
|Microservicio|{{[nombre-ms]}}|
|Puerto backend|{{[puerto]}}|
|Total de rutas|[N]|
|Ambiente destino|[ambiente]|

----

h2. Matriz de Perfilamiento

||#||Endpoint||Nivel||Perfil||Grupo Regex||
|1|{{/[nombre-ms]/path1/**}}|Nivel 2 - Sesión + RUT|_(vacío)_|2|
|2|{{/[nombre-ms]/path2/**}}|Nivel 3 - Sesión + RUT + Perfil|2101|2|
|3|{{/[nombre-ms]/path3/**}}|Nivel 1 - Público|N/A|N/A|

----

h2. Configuración Completa

{code:yaml}
spring:
  cloud:
    gateway:
      routes:
        # Ruta 1: [descripción]
        - id: [nombre-ms]-ruta-1
          uri: http://localhost:[puerto]
          predicates:
            - Path=/[nombre-ms]/[path1]/**
          filters:
            - name: Authorization
              args:
                userIdRegex: "/[nombre-ms]/[regex]"
                userIdRegexGroup: 2
                profiles:

        # Ruta 2: [descripción]
        - id: [nombre-ms]-ruta-2
          uri: http://localhost:[puerto]
          predicates:
            - Path=/[nombre-ms]/[path2]/**
          filters:
            - name: Authorization
              args:
                userIdRegex: "/[nombre-ms]/[regex]"
                userIdRegexGroup: 2
                profiles: 2101
{code}

----

h2. Notas

{panel:title=Importante|borderStyle=dashed|borderColor=#ccc|bgColor=#ffffce}
* Las rutas públicas (Nivel 1) no llevan filtro {{Authorization}}.
* El orden de las rutas importa: rutas más específicas deben ir primero.
* Los perfiles se validan contra el sistema de perfilamiento institucional.
{panel}
```

### Plantilla: Matriz de Perfilamiento (`/perfiles matriz`)

```
h1. Matriz de Perfilamiento - [nombre-ms]

h2. Resumen de Accesos

||#||Ruta||Método(s)||Nivel de Acceso||Perfil Requerido||userIdRegexGroup||Descripción||
|1|{{/[ms]/api/v1/path1}}|GET|Nivel 1 - Público|N/A|N/A|[desc]|
|2|{{/[ms]/api/v1/contribuyentes/\{rut\}/path2}}|GET, POST|Nivel 2 - Sesión + RUT|_(vacío)_|2|[desc]|
|3|{{/[ms]/api/v1/contribuyentes/\{rut\}/path3}}|PUT, DELETE|Nivel 3 - Sesión + RUT + Perfil|2101|2|[desc]|
|4|{{/[ms]/api/v1/admin/path4}}|GET|Nivel 4 - Solo Perfil|2101|1|[desc]|

----

h2. Leyenda de Niveles

||Nivel||Descripción||Requiere Sesión||Valida RUT||Requiere Perfil||
|1|Público|No|No|No|
|2|Sesión + RUT match|Sí|Sí|No|
|3|Sesión + RUT + Perfil|Sí|Sí|Sí|
|4|Solo Perfil (sin RUT)|Sí|No|Sí|
|5|Autorización Externa|Sí|Configurable|Opcional|
```

---

## Reglas Especiales

1. **Rutas públicas (Nivel 1)**: NO incluir el filtro `Authorization` en absoluto. Solo `id`, `uri` y `predicates`.
2. **Profiles vacío (Nivel 2)**: Incluir el filtro `Authorization` pero con `profiles:` sin valor (cadena vacía).
3. **Orden de rutas**: Las rutas más específicas siempre van primero. Las genéricas (catch-all) al final.
4. **Naming de IDs**: Formato `[nombre-ms]-[descripcion-corta]`, todo en minúsculas con guiones. Ej: `eventos-ms-alertas-por-rut`.
5. **Regex con RUT**: Usar `(\\d{1,12})` para capturar RUTs (hasta 12 dígitos).
6. **Formato JIRA**: Toda la salida debe usar sintaxis JIRA (h1., ||tablas||, {code}, {panel}), NO Markdown.
7. **Agrupar rutas**: Si múltiples endpoints comparten el mismo nivel de acceso y regex, pueden agruparse en una sola ruta con múltiples paths en el predicate.

---

## Ejemplo Completo

Para un microservicio `eventos-ms` en puerto `6080` con 3 endpoints:

{code:yaml}
spring:
  cloud:
    gateway:
      routes:
        # Público: health check
        - id: eventos-ms-health
          uri: http://localhost:6080
          predicates:
            - Path=/eventos-ms/actuator/health

        # Sesión + RUT: consultar alertas propias
        - id: eventos-ms-alertas-por-rut
          uri: http://localhost:6080
          predicates:
            - Path=/eventos-ms/api/v1/contribuyentes/{rut}/alertas/**
          filters:
            - name: Authorization
              args:
                userIdRegex: "/eventos-ms/api/v1/contribuyentes/(\\d{1,12})/.*"
                userIdRegexGroup: 2
                profiles:

        # Sesión + RUT + Perfil: administrar alertas
        - id: eventos-ms-admin-alertas
          uri: http://localhost:6080
          predicates:
            - Path=/eventos-ms/api/v1/contribuyentes/{rut}/alertas/admin/**
          filters:
            - name: Authorization
              args:
                userIdRegex: "/eventos-ms/api/v1/contribuyentes/(\\d{1,12})/.*"
                userIdRegexGroup: 2
                profiles: 2101
{code}
