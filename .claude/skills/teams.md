# Skill: /teams

Genera mensajes de Microsoft Teams estructurados y profesionales.

## Invocación

- Comando: `/teams [tipo]`
- Triggers: "enviar teams", "quiero enviar un teams", "mensaje teams"

## Tipos disponibles

| Comando | Tipo | Descripción |
|---------|------|-------------|
| `/teams solicitud` | Solicitud | Pedir algo a alguien |
| `/teams info` | Informativo | Comunicar algo sin acción requerida |
| `/teams bloqueo` | Bloqueo | Informar un problema que impide avanzar |
| `/teams seguimiento` | Seguimiento | Actualizar estado de algo en curso |
| `/teams deploy` | Deploy | Informar sobre despliegues |
| `/teams consulta` | Consulta | Hacer preguntas técnicas |

Si no se especifica tipo, preguntar al usuario.

---

# Reglas para Mensajes en Microsoft Teams

## Sintaxis de Formateo Teams (Markdown)

### Formato de Texto
```
**negrita** para énfasis
_cursiva_ para términos o aclaraciones
~~tachado~~ para correcciones
`código inline` para comandos o variables
```

### Encabezados
```
# Título principal
## Subtítulo
### Sección
```

### Listas
```
- Bullet point
- Otro punto

1. Numerado
2. Otro numerado
```

### Otros
```
> Cita o nota destacada
[texto del link](https://url.com)
```

---

## Estructura Base de Mensaje

```
# [EMOJI] [TEMA] - [Resumen en una línea]

**Contexto:**
[1-2 líneas explicando la situación]

**Detalle:**
- Punto 1
- Punto 2
- Punto 3

**Acción requerida:**
[Qué necesitas] + [Para cuándo]

**Links:**
[Si aplica]
```

---

## Plantilla: Solicitud

```
# [Solicitud] - [Qué necesitas]

**Necesito:** [X] para [motivo]
**Para cuándo:** [fecha]

**Detalle:**
- [Punto 1]
- [Punto 2]

**Links:**
[Si aplica]
```

---

## Plantilla: Informativo

```
# [Info] - [Tema]

**Contexto:**
[Qué pasó o cambió]

**Detalle:**
- [Punto 1]
- [Punto 2]

_No requiere acción._
```

---

## Plantilla: Bloqueo

```
# [Bloqueado] - [Tema]

**Problema:** [descripción del bloqueo]

**Impacto:** [qué se ve afectado]

**Necesito:** [qué necesitas para continuar]

**Urgencia:** [Alta/Media/Baja]
```

---

## Plantilla: Seguimiento

```
# [Seguimiento] - [Tema]

**Estado actual:** [en qué va]

**Pendiente:**
- [ ] [Tarea 1]
- [ ] [Tarea 2]

**Próximos pasos:** [qué sigue]
```

---

## Plantilla: Actualización de Deploy/Release

```
# [Deploy] - [Aplicación] en [Ambiente]

**Versión:** [x.y.z]
**Ambiente:** [DEVX/CERX/Producción]

**Cambios incluidos:**
- [Cambio 1]
- [Cambio 2]

**Estado:** Exitoso / Fallido / En progreso

**Links:**
- [JIRA](url)
- [Pipeline](url)
```

---

## Plantilla: Consulta Técnica

```
# [Consulta] - [Tema]

**Contexto:**
[Situación actual]

**Pregunta:**
[Tu consulta específica]

**Opciones consideradas:**
1. [Opción A]
2. [Opción B]

**Tu opinión sería de ayuda.**
```

---

## Emojis Útiles para Teams

| Emoji | Uso |
|-------|-----|
| :pushpin: | Tema general, solicitud |
| :rotating_light: | Bloqueo, urgente |
| :arrows_counterclockwise: | Seguimiento |
| :rocket: | Deploy, release |
| :white_check_mark: | Completado, éxito |
| :x: | Fallido, error |
| :hourglass_flowing_sand: | En progreso |
| :question: | Consulta |
| :warning: | Advertencia |
| :clipboard: | Lista, documentación |
| :link: | Links |
| :pray: | Agradecimiento, solicitud amable |

---

## Tips para Mensajes Efectivos

1. **Asunto claro**: El título debe resumir todo en una línea
2. **Contexto breve**: 1-2 líneas máximo
3. **Acción específica**: Qué necesitas y para cuándo
4. **Formateo visual**: Usar bullets, negritas y emojis con moderación
5. **Links al final**: Agrupar referencias al final del mensaje
6. **Menciones**: Usar @nombre solo si es necesario para la persona específica
