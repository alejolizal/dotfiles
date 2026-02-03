# Skill: /outlook

Genera correos de Microsoft Outlook con formato profesional.

## Invocación

- Comando: `/outlook [tipo]`
- Triggers: "enviar por outlook", "correo outlook", "email"

## Tipos disponibles

| Comando | Tipo | Descripción |
|---------|------|-------------|
| `/outlook solicitud` | Solicitud | Requiere acción del destinatario |
| `/outlook info` | Informativo | Solo informativo |
| `/outlook urgente` | Urgente | Requiere atención inmediata |
| `/outlook seguimiento` | Seguimiento | Continuación de tema previo |
| `/outlook revision` | Revisión | Requiere revisión de documento/código |
| `/outlook entrega` | Entrega | Envío de entregable |

Si no se especifica tipo, preguntar al usuario.

---

# Formato de mensajes en Microsoft Outlook

Usa HTML/formato enriquecido para estructurar correos claros y profesionales.

## Formato de Texto
- **Negrita** (Ctrl+B) para énfasis
- *Cursiva* (Ctrl+I) para términos o aclaraciones
- Subrayado (Ctrl+U) para destacar
- Resaltado para información crítica

---

## Estructura de Correo

```
Asunto: [TIPO] - [Tema específico en una línea]
```

### Tipos de asunto:
- `[Solicitud]` - Requiere acción del destinatario
- `[Info]` - Solo informativo
- `[Urgente]` - Requiere atención inmediata
- `[Seguimiento]` - Continuación de tema previo
- `[Revisión]` - Requiere revisión de documento/código
- `[Entrega]` - Envío de entregable

---

## Plantilla: Solicitud

```
Asunto: [Solicitud] - [Qué necesitas]

Estimado/a [nombre],

Necesito [X] para [motivo breve].

Detalle:
- [Especificación 1]
- [Especificación 2]

¿Podrías ayudarme con esto para el [fecha]?

Quedo atento.
Saludos,
```

---

## Plantilla: Informativo

```
Asunto: [Info] - [Tema]

Estimado/a [nombre],

Te informo que [qué pasó o cambió].

Detalle:
- [Punto 1]
- [Punto 2]

Este correo es solo informativo, no requiere acción.

Saludos,
```

---

## Plantilla: Escalamiento/Bloqueo

```
Asunto: [Urgente] - Bloqueo en [Tema]

Estimado/a [nombre],

Estoy bloqueado con [X] debido a [motivo].

Impacto:
- [Qué se ve afectado]
- [Fecha comprometida si aplica]

Necesito:
- [Qué necesitas para continuar]

¿Podemos verlo hoy?

Saludos,
```

---

## Plantilla: Seguimiento

```
Asunto: [Seguimiento] - [Tema]

Estimado/a [nombre],

Retomo el tema de [X] que quedó pendiente el [fecha/reunión].

Estado actual:
- [Punto 1]
- [Punto 2]

¿Hay novedades al respecto?

Saludos,
```

---

## Plantilla: Envío de entregable

```
Asunto: [Entrega] - [Nombre del entregable]

Estimado/a [nombre],

Adjunto [descripción del entregable] según lo acordado.

Contenido:
- [Archivo 1] - [descripción breve]
- [Archivo 2] - [descripción breve]

Observaciones:
- [Nota importante si aplica]

Quedo atento a comentarios.
Saludos,
```

---

## Reglas

- Asunto descriptivo y específico, nunca vacío o genérico
- Primera línea del cuerpo = punto principal
- Usar bullets para listados, no párrafos largos
- CC solo a quien necesita estar informado
- Si hay adjuntos, describirlos brevemente
- Indicar claramente si requiere acción o es solo informativo
- Especificar fecha límite si aplica
- Un tema por correo, no mezclar asuntos
- Revisar destinatarios antes de enviar
- Evitar "Responder a todos" innecesario
