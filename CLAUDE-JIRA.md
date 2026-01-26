# Reglas para Generacion de JIRAs Corporativos

Este archivo contiene las plantillas y reglas para que Claude genere JIRAs consistentes.

## Instrucciones para Claude

Cuando el usuario solicite crear un JIRA:
1. Identificar el tipo de ticket (Requerimiento, Labor Operativa, Bug, Deploy)
2. Usar la plantilla correspondiente de este documento
3. Si faltan datos esenciales, solicitar al usuario antes de generar
4. Generar el JIRA completo en formato markdown
5. Aplicar labels, nomenclatura de branches y commits segun las reglas

---

## Tipos de Tickets

### 1. Requerimiento
Nuevas funcionalidades o cambios solicitados por el negocio

### 2. Labor Operativa
Tareas operativas, mantenimiento, configuraciones

### 3. Reporte de Error
Bugs o problemas en funcionamiento de aplicaciones

### 4. Instalacion en Ambientes
Despliegues en DEVX, CERX y ambientes legados

---

## Plantilla: Requerimiento

```markdown
**Titulo:** [REQ] [Nombre aplicacion] - Descripcion breve del requerimiento

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

```markdown
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

```markdown
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

```markdown
**Titulo:** [DEPLOY] [Aplicacion] - Instalacion en [Ambiente]

**Aplicacion**
- Nombre: [nombre completo]
- Version: [x.y.z]
- Repositorio: [URL del repo Git]
- Branch/Tag: [nombre]

**Ambiente Destino**
- [ ] DEVX - Desarrollo
- [ ] CERX - Certificacion
- [ ] Produccion
- [ ] Legado: [especificar nombre del ambiente]

**Tipo de Instalacion**
- [ ] Nueva instalacion
- [ ] Actualizacion de version
- [ ] Hotfix
- [ ] Rollback

**Componentes a Desplegar**
- [ ] Backend (Spring Boot)
- [ ] Frontend (Vue.js)
- [ ] Scripts de BD
- [ ] Configuraciones
- [ ] Dependencias externas

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
