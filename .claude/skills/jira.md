# Skill: /jira

Genera tickets JIRA con plantillas corporativas.

## Invocación

- Comando: `/jira [tipo]`
- Triggers: "crear jira", "generar jira", "ticket jira"

## Tipos disponibles

| Comando | Tipo | Prefijo título | Descripción |
|---------|------|----------------|-------------|
| `/jira req` | Requerimiento | `[REQ]` | Nuevas funcionalidades |
| `/jira ops` | Labor Operativa | `[OPS]` | Mantenimiento, configuraciones |
| `/jira bug` | Reporte de Error | `[BUG]` | Bugs y problemas |
| `/jira deploy` | Instalación | `[DEPLOY]` | Despliegues en ambientes |
| `/jira dseguro` | Seguridad | `[DSeguro]` | Visto bueno de seguridad |
| `/jira rds` | Revisión de Diseño | `[RDS]` | Revisión de Diseño de Software |
| `/jira sap` | Solicitud SAP | `[SAP]` | Solicitudes SAP |
| `/jira rec` | REC Tradicional | `[REC]` | Paso a producción estándar |
| `/jira rec-backend` | REC Backend | `[REC]` | REC para Batch, Nóminas, SQL, API, Servicios |
| `/jira rec-fasttrack` | REC Fast Track | `[REC]` | Paso urgente por incidencia o vulnerabilidad |
| `/jira trazabilidad` | Trazabilidad | `[Trazabilidad]` | No aplica trazabilidad |

Si no se especifica tipo, preguntar al usuario.

---

# Reglas para Generación de JIRAs Corporativos

## Sintaxis de Formateo JIRA

IMPORTANTE: Usar esta sintaxis al generar contenido para JIRA (no Markdown).

### Texto
```
*negrita*
_cursiva_
-tachado-
+subrayado+
{{monoespaciado}}
```

### Encabezados
```
h1. Título grande
h2. Subtítulo
h3. Más pequeño
```

### Listas
```
* item con bullet
** sub-item
# item numerado
## sub-item numerado
```

### Links
```
[texto del link|https://url.com]
[~usuario]  (mencionar usuario)
```

### Código
```
{code:java}
public void hola() {}
{code}

{noformat}
texto sin formato
{noformat}
```

### Citas y Paneles
```
{quote}
Texto citado
{quote}

{panel:title=Mi título}
Contenido del panel
{panel}
```

### Colores
```
{color:red}texto rojo{color}
{color:#00875A}texto verde custom{color}
```

### Tablas
```
||encabezado 1||encabezado 2||
|celda 1|celda 2|
|celda 3|celda 4|
```

### Imágenes adjuntas
```
!nombre-archivo.png!
```
NO usar `|thumbnail` ni doble `!¡`. Solo `!nombre.png!` — JIRA muestra la imagen adjunta automáticamente.

### Emojis
```
:)  :(  :P  (y)  (n)  (!)  (?)  (*)
```

### Línea divisoria
```
----
```

---

## Instrucciones para Claude

Cuando el usuario solicite crear un JIRA:
1. Identificar el tipo de ticket (Requerimiento, Labor Operativa, Bug, Deploy)
2. Usar la plantilla correspondiente de este documento
3. Si faltan datos esenciales, solicitar al usuario antes de generar
4. *Generar el JIRA usando sintaxis JIRA* (ver seccion anterior), NO Markdown
5. Aplicar labels, nomenclatura de branches y commits segun las reglas

*Nota:* Cuando el usuario pida "formato JIRA" o contenido para pegar en JIRA, usar la sintaxis de formateo JIRA (h1., *, ||tablas||, {code}, etc.) en lugar de Markdown.

## Reglas de Formato Aprendidas

1. *Títulos:* Formato obligatorio en dos partes:
   - Primero el tipo entre corchetes: `[OPS]`, `[REQ]`, `[BUG]`, `[DEPLOY]`, `[RDS]`, `[DSeguro]`, `[SAP]`, `[REC]`
   - Luego contexto entre corchetes: `[ambiente-aplicación-acción]`
   - Luego un título genérico y descriptivo (con tildes y gramática correcta)
   - Ejemplo: `[OPS] [CERX-eventos-ms-Limpieza Properties] Configuración properties`
   - Ejemplo: `[REQ] [DEVX-siimple-ms-Nuevo Endpoint] Consulta de alertas por período`
   - Ejemplo: `[BUG] [PROD-eventos-batch-Fix] Corrección carga masiva CSV`
2. *Endpoints y código:* Usar `h4.` como subtítulo + `{noformat}` para bloques de endpoints, rutas o código. NO meter endpoints en tablas ni usar `{code}` dentro de `{panel}`.
3. *Notas destacadas:* Usar `{panel:title=Título|borderStyle=dashed|borderColor=#ccc|bgColor=#ffffce}` para notas importantes o advertencias.
4. *Tablas:* Solo para datos tabulares simples (campo-valor, severidad-cantidad). NO para listar endpoints o paths largos.

---

## Plantilla: Requerimiento

```
**Titulo:** [REQ] [Nombre aplicacion] - Descripcion breve

**Solicitante**
- Area: [nombre del area de negocio]
- Contacto: [nombre y email]
- Prioridad del Negocio: Alta/Media/Baja

**Descripcion del Requerimiento**
[Explicacion detallada de lo que se necesita]

**Justificacion de Negocio**
[Por que es necesario, que problema resuelve, que valor aporta]

**Alcance**
- Modulos/Funcionalidades afectadas:
- Aplicaciones involucradas:
- Integraciones requeridas:

**Criterios de Aceptacion**
- [ ] Dado [contexto] cuando [accion] entonces [resultado]
- [ ] Criterio 2
- [ ] Criterio 3

**Impacto en Ambientes**
- [ ] DEVX - Desarrollo
- [ ] CERX - Certificacion
- [ ] Produccion
- [ ] Legado (especificar):

**Consideraciones Tecnicas**
- Base de datos: Oracle/PostgreSQL
- Framework: Spring Boot [version]
- Frontend: Vue.js (si aplica)
- APIs/Servicios externos:

**Estimacion**
Story Points: [1,2,3,5,8,13]
Tiempo estimado: [horas/dias]

**Dependencias**
[Otros tickets, sistemas, equipos necesarios]

**Documentacion Requerida**
- [ ] Manual de usuario
- [ ] Documentacion tecnica
- [ ] Scripts de BD
- [ ] Actualizacion de APIs
```

---

## Plantilla: Labor Operativa

```
**Titulo:** [OPS] [Aplicacion/Sistema] - Descripcion de la labor

**Tipo de Labor**
- [ ] Mantenimiento preventivo
- [ ] Configuracion
- [ ] Actualizacion de dependencias
- [ ] Limpieza de datos
- [ ] Monitoreo/Analisis
- [ ] Otro: [especificar]

**Descripcion**
[Que se necesita hacer y por que]

**Ambiente(s) Afectado(s)**
- [ ] DEVX
- [ ] CERX
- [ ] Produccion
- [ ] Legado: [especificar]

**Pasos a Realizar**
1. [Paso 1]
2. [Paso 2]
3. [Paso 3]

**Impacto**
- Downtime requerido: Si/No [duracion estimada]
- Usuarios afectados: [cantidad/areas]
- Sistemas dependientes: [listar]

**Ventana de Ejecucion**
- Fecha propuesta: [DD/MM/YYYY]
- Horario: [HH:MM - HH:MM]
- Justificacion del horario: [fuera de horario laboral, etc.]

**Plan de Rollback**
[Como revertir en caso de problemas]

**Validacion Post-Ejecucion**
- [ ] Validacion 1
- [ ] Validacion 2
- [ ] Validacion 3

**Estimacion**
Tiempo: [horas]
```

---

## Plantilla: Reporte de Error

```
**Titulo:** [BUG] [Aplicacion] - Descripcion breve del error

**Severidad**
- [ ] Critica - Sistema caido, bloqueante total
- [ ] Alta - Funcionalidad core no disponible
- [ ] Media - Funcionalidad secundaria afectada
- [ ] Baja - Error cosmetico o menor

**Ambiente Donde Ocurre**
- [ ] DEVX
- [ ] CERX
- [ ] Produccion
- [ ] Legado: [especificar]

**Descripcion del Error**
[Explicacion clara del problema encontrado]

**Pasos para Reproducir**
1. Paso 1
2. Paso 2
3. Paso 3

**Comportamiento Esperado**
[Que deberia suceder]

**Comportamiento Actual**
[Que esta sucediendo]

**Evidencia**
- Logs: [adjuntar o pegar stack trace]
- Screenshots: [si aplica]
- Hora de ocurrencia: [DD/MM/YYYY HH:MM]
- Usuario afectado: [ID o email]

**Informacion Tecnica**
- Aplicacion: [nombre y version]
- Modulo/Funcionalidad: [especifica]
- Base de datos: Oracle/PostgreSQL
- Version desplegada: [x.y.z]
- Branch: [feature/bugfix/main]

**Impacto al Negocio**
- Usuarios afectados: [cantidad/porcentaje]
- Areas impactadas: [listar]
- Procesos bloqueados: [listar]
- Perdida estimada: [si aplica]

**Analisis de Causa Raiz** (si se conoce)
[Que causo el error]

**Solucion Propuesta**
[Como se planea resolver]

**Workaround Temporal** (si existe)
[Alternativa mientras se corrige]

**Prioridad de Correccion**
- Hotfix inmediato
- Proximo release
- Backlog
```

---

## Plantilla: Instalacion en Ambientes

```
**Titulo:** [DEPLOY] Instalacion en [Ambiente] - [descripcion breve]

**Aplicaciones a Desplegar**

||Aplicacion||Commit Hash||Cambios Properties||
|[app-ms]|[abc1234]|Si / No|
|[app-ui]|[def5678]|N/A|

*Notas:*
- *Commit hash obligatorio para trazabilidad. Siempre preguntar al usuario (no asumir último commit).*
- *Aplicaciones UI (-ui) no llevan properties, marcar N/A.*
- *Si hay cambios de properties, detallar por aplicación en sección aparte.*

**Cambios de Properties** (si aplica)

*[nombre-aplicacion-ms]:*
{code}
# Propiedad agregada/modificada
propiedad.nueva=valor
propiedad.modificada=nuevo-valor
{code}

**Ambiente Destino:** [DEVX / CERX / Produccion / Legado: especificar]

**Tipo de Instalacion:** [Nueva instalacion / Actualizacion / Hotfix / Rollback]

**Componentes Incluidos**
- [ ] Backend (Spring Boot)
- [ ] Frontend (Vue.js)
- [ ] Scripts de BD
- [ ] Configuraciones
- [ ] Jobs Batch

**Pre-requisitos**
- Java version: [ej: 11, 17]
- Maven version: [ej: 3.8.x]
- Base de datos: Oracle [version] / PostgreSQL [version]
- Otros: [listar]

**Configuraciones Especificas del Ambiente**
- application.properties: [cambios requeridos]
- Variables de entorno: [listar]
- Conexiones BD: [detalles]
- Endpoints externos: [URLs]

**Scripts de Base de Datos**
- [ ] DDL (crear/modificar tablas)
- [ ] DML (insertar/actualizar datos)
- [ ] Rollback script disponible

Archivos:
- [script1.sql] - [descripcion]
- [script2.sql] - [descripcion]

**Proceso de Despliegue**
**Mediante:** BYD (Build Your Deploy) / Manual / Otro

**Pasos:**
1. [Paso 1]
2. [Paso 2]
3. [Paso 3]

**Configuracion BYD/Tanzu:**
- Namespace: [kubernetes namespace]
- Replicas: [cantidad]
- Resources: [CPU/Memory]
- Health checks: [endpoints]

**Validaciones Post-Despliegue**
- [ ] Aplicacion levanta correctamente
- [ ] Health check responde OK
- [ ] Endpoints REST funcionan
- [ ] Conectividad a BD OK
- [ ] Logs sin errores criticos
- [ ] Pruebas de humo pasadas

**Pruebas de Humo**
1. [Prueba 1: descripcion]
2. [Prueba 2: descripcion]
3. [Prueba 3: descripcion]

**Ventana de Despliegue**
- Fecha: [DD/MM/YYYY]
- Hora inicio: [HH:MM]
- Duracion estimada: [minutos/horas]
- Downtime esperado: Si/No [duracion]

**Plan de Rollback**
En caso de fallo:
1. [Paso rollback 1]
2. [Paso rollback 2]
3. [Paso rollback 3]

Version anterior: [x.y.z-anterior]
Backup BD: [ubicacion]

**Notificaciones**
- [ ] Notificar a usuarios antes del deploy
- [ ] Informar downtime (si aplica)
- [ ] Confirmar despliegue exitoso

Contactos a notificar:
- [Area/Persona 1]
- [Area/Persona 2]

**Checklist Seguridad**
- [ ] Scan Checkmarx pasado
- [ ] Vulnerabilidades resueltas
- [ ] Credenciales no hardcodeadas
- [ ] HTTPS configurado
- [ ] Logs no exponen informacion sensible

**Documentacion Adjunta**
- [ ] Release notes
- [ ] Guia de instalacion
- [ ] Cambios en APIs
- [ ] Actualizacion de manuales
```

---

## Plantilla: REC Tradicional

```
**Titulo:** [REC] [Nombre Aplicacion] - Paso a produccion

h2. Antecedentes Obligatorios

||#||Requisito||Detalle||Estado||
|1|Nombre Iniciativa EA|[nombre de la iniciativa]|(/) Cumple / (x) Pendiente|
|2|Version o Hash de la App|{{[version o hash]}}|(/) Cumple / (x) Pendiente|
|3|Jira SAP|SDI-XXXXXX|(/) Cumple / (x) Pendiente|
|4|Jira Trazabilidad Legacy o Cloud|SDI-XXXXXX _(Certificada y Aprobada)_|(/) Cumple / (x) Pendiente|
|5|Jira de Instalacion en Certificacion|SDI-XXXXXX|(/) Cumple / (x) Pendiente|
|6|Plan de Pruebas Formato AAC|[adjunto o link]|(/) Cumple / (x) Pendiente|
|7|Evidencias de Certificacion|[adjunto o link]|(/) Cumple / (x) Pendiente|
|8|V°B° Usuario|Version: {{[version]}}|(/) Cumple / (x) Pendiente|
|9|JIRA de Comite Tecnico|SDI-XXXXXX|(/) Cumple / (x) Pendiente|
|10|V°B° Arquitectura RDS|SDI-XXXXXX - Version: {{[version]}}|(/) Cumple / (x) Pendiente|
|11|V°B° Jira DSEGURO|SDI-XXXXXX - Version: {{[version]}}|(/) Cumple / (x) Pendiente|
|12|V°B° Arquitectura de Datos MDS|SDI-XXXXXX - Version: {{[version]}}|(/) Cumple / (x) Pendiente|
```

---

## Plantilla: REC Backend (Batch, Nominas, SQL, API, Servicios)

```
**Titulo:** [REC] [Nombre Aplicacion] - Paso a produccion (Backend)

h2. Antecedentes Obligatorios

||#||Requisito||Detalle||Estado||
|1|Nombre Iniciativa EA|[nombre de la iniciativa]|(/) Cumple / (x) Pendiente|
|2|Version o Hash de la App|{{[version o hash]}}|(/) Cumple / (x) Pendiente|
|3|Jira SAP|SDI-XXXXXX|(/) Cumple / (x) Pendiente|
|4|Jira de Instalacion en Certificacion|SDI-XXXXXX|(/) Cumple / (x) Pendiente|
|5|Plan de Pruebas Formato AAC|[adjunto o link]|(/) Cumple / (x) Pendiente|
|6|Evidencias de Certificacion|[adjunto o link]|(/) Cumple / (x) Pendiente|
|7|V°B° Usuario|Version: {{[version]}}|(/) Cumple / (x) Pendiente|
|8|V°B° Arquitectura RDS|SDI-XXXXXX - Version: {{[version]}}|(/) Cumple / (x) Pendiente|
|9|V°B° Jira DSEGURO|SDI-XXXXXX - Version: {{[version]}}|(/) Cumple / (x) Pendiente|
```

---

## Plantilla: REC Fast Track

```
**Titulo:** [REC] Fast Track - [Nombre Aplicacion] - [Incidencia Funcional / Vulnerabilidad]

{panel:title=Mecanismo Excepcional|borderStyle=dashed|borderColor=#ccc|bgColor=#ffffce}
El Jira REC Fast Track corresponde a un mecanismo excepcional destinado a atender situaciones urgentes en ambiente productivo, las cuales requieren una validacion acotada y acelerada, sin seguir el proceso completo de certificacion estandar.

*Condicion habilitante (obligatoria):* Debe existir previamente un Jira de Incidencia Productiva o un Jira de Incidencia de Vulnerabilidad, gestionado por las areas de Produccion y/o Seguridad.

*Alcance:* La solucion debe ser estrictamente acotada a la correccion de la incidencia reportada. No esta permitido incorporar nuevas mejoras, funcionalidades adicionales, refactorizaciones u otros cambios no relacionados con la incidencia.
{panel}

----

h2. Variante 1: Incidencia Funcional (Continuidad Operativa)

||#||Requisito||Detalle||Estado||
|1|Jira de Incidencia Funcional|SDI-XXXXXX _(generado por Produccion o Monitoreo)_|(/) Cumple / (x) Pendiente|
|2|Instalacion en Ambiente de Certificacion|SDI-XXXXXX _(en caso de no contar con CERX, puede usarse DEV excepcionalmente)_|(/) Cumple / (x) Pendiente|
|3|Evidencia de Certificacion|[adjunto o link] _(debe indicar explicitamente que el inconveniente fue resuelto, certificada por usuario de negocio)_|(/) Cumple / (x) Pendiente|
|4|V°B° Usuario de Negocio|Version: {{[version]}}|(/) Cumple / (x) Pendiente|
|5|V°B° Jira DSEGURO|SDI-XXXXXX - Version: {{[version]}}|(/) Cumple / (x) Pendiente|

----

h2. Variante 2: Vulnerabilidad

||#||Requisito||Detalle||Estado||
|1|Jira de Incidencia de Vulnerabilidad|SDI-XXXXXX _(generado por el area de Seguridad)_|(/) Cumple / (x) Pendiente|
|2|Instalacion en Ambiente de Certificacion|SDI-XXXXXX _(en caso de no contar con CERX, puede usarse DEV excepcionalmente)_|(/) Cumple / (x) Pendiente|
|3|Evidencia de Mitigacion de Vulnerabilidad|[adjunto o link] _(Ethical Hacking, AppScan, Checkmarx)_|(/) Cumple / (x) Pendiente|
|4|V°B° Jira DSEGURO|SDI-XXXXXX - Version: {{[version]}}|(/) Cumple / (x) Pendiente|
```

---

## Plantilla: Trazabilidad (No Aplica)

```
**Titulo:** [Trazabilidad] [Nombre Aplicacion] - No aplica trazabilidad

h2. Antecedentes
[Descripción de la aplicación y su rol]

h2. Justificación de No Aplicabilidad
* [Razón 1]
* [Razón 2]

{panel:title=Nota|borderStyle=dashed|borderColor=#ccc|bgColor=#ffffce}
[Justificación formal de por qué no aplica trazabilidad]
{panel}

h2. Arquitectura de Referencia
{noformat}
[Diagrama de flujo mostrando la posición del componente]
{noformat}

h2. Conclusión
(/) Se deja constancia de que [aplicación] no aplica para el requisito de trazabilidad.
```

---

## Labels Estandar

**Por tipo:**
- `requerimiento` - Nuevas funcionalidades
- `labor-operativa` - Tareas operativas
- `bug` - Reportes de error
- `deploy` - Instalaciones

**Por ambiente:**
- `devx` - Desarrollo
- `cerx` - Certificacion
- `produccion` - Produccion
- `legado` - Ambientes legacy

**Por tecnologia:**
- `spring-boot` - Backend Java
- `vue` - Frontend
- `oracle` - Base de datos Oracle
- `postgresql` - Base de datos PostgreSQL
- `byd` - Despliegue por BYD/Tanzu

**Por severidad:**
- `critico` - Atencion inmediata
- `alto` - Alta prioridad
- `medio` - Prioridad media
- `bajo` - Puede esperar

**Otros:**
- `hotfix` - Correccion urgente
- `security` - Seguridad/Checkmarx
- `database-change` - Cambios en BD
- `config-change` - Cambios de configuracion

---

## Nomenclatura de Branches

```bash
# Requerimientos
feature/JIRA-123-nombre-requerimiento

# Bugs
bugfix/JIRA-456-descripcion-error

# Hotfixes
hotfix/JIRA-789-fix-critico

# Tareas operativas
task/JIRA-321-labor-operativa
```

---

## Formato de Commits

```bash
# Formato estandar
JIRA-123: Descripcion concisa del cambio

# Con detalles
JIRA-123: Implementa endpoint de consulta de transacciones

- Agrega controller REST /api/v1/transacciones
- Implementa service con logica de negocio
- Agrega validaciones de entrada
- Tests unitarios incluidos
```

---

## Story Points (Fibonacci)

- **1 punto**: < 4 horas - Cambio trivial
- **2 puntos**: 4-8 horas - Cambio simple
- **3 puntos**: 1 dia - Cambio moderado
- **5 puntos**: 2 dias - Cambio complejo
- **8 puntos**: 3-4 dias - Muy complejo
- **13 puntos**: > 5 dias - Requiere division en sub-tareas

---

## Reglas Especiales por Ambiente

### DEVX (Desarrollo)
- Despliegues frecuentes permitidos
- Testing activo
- Datos de prueba OK

### CERX (Certificacion)
- Requiere aprobacion previa
- Datos similares a produccion
- Validacion del negocio
- Gateway a produccion

### Produccion
- Ventana de despliegue estricta
- Aprobaciones multiples requeridas
- Plan de rollback obligatorio
- Notificacion a usuarios
- Monitoreo post-deploy

### Ambientes Legados
- Documentar peculiaridades
- Versiones antiguas de SW
- Restricciones especiales
- Contactar a equipos legacy

---

## Consideraciones de Seguridad

### Obligatorio antes de Deploy
- [ ] Scan Checkmarx ejecutado y aprobado
- [ ] Sin vulnerabilidades criticas
- [ ] Credenciales externalizadas
- [ ] Validacion de inputs implementada
- [ ] Logs sanitizados (sin info sensible)

### Para cambios en BD
- [ ] Scripts revisados por DBA
- [ ] Backup realizado
- [ ] Tested en ambiente lower
- [ ] Plan de rollback probado

---

## Definition of Done (DoD)

Todo ticket debe cumplir:
- [ ] Codigo desarrollado y commiteado
- [ ] Code review aprobado
- [ ] Tests unitarios > 80% cobertura
- [ ] Checkmarx sin issues criticos
- [ ] Documentacion actualizada
- [ ] Desplegado en DEVX y validado
- [ ] Aprobado en CERX (si aplica)
- [ ] Release notes actualizados

---

## Campos Obligatorios en Jira

**Todos los tickets:**
- Titulo descriptivo
- Descripcion completa
- Tipo de ticket
- Prioridad
- Labels apropiados

**Requerimientos:**
- Story points
- Criterios de aceptacion
- Area solicitante

**Bugs:**
- Severidad
- Ambiente
- Pasos para reproducir

**Deploys:**
- Ambiente destino
- Version
- Ventana de ejecucion
- Plan de rollback

---

## Tips para Generar JIRAs

1. **Titulos claros**: Incluye nombre de aplicacion y descripcion breve
2. **Contexto suficiente**: Asume que quien lo lea no conoce el historial
3. **Ambientes explicitos**: Siempre especifica que ambiente(s)
4. **Impacto al negocio**: Ayuda a priorizar correctamente
5. **Rollback plan**: Especialmente critico en CERX y produccion
6. **Notificaciones**: Lista quien debe ser informado
7. **Dependencias**: Marca otros tickets o sistemas relacionados
