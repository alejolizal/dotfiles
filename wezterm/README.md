# Configuración de WezTerm

Terminal emulador GPU-acelerado que uso desde **Windows** para trabajar en **WSL/Linux**.

> **Nota:** Este archivo debe copiarse/linkearse en Windows (`%USERPROFILE%\.wezterm.lua`), no en Linux. WezTerm corre en Windows y se conecta a WSL.

## Archivos

```
wezterm/
├── .wezterm.lua    # Configuración principal
└── README.md
```

## Instalación (en Windows)

WezTerm busca la configuración en `%USERPROFILE%\.wezterm.lua` (ej: `C:\Users\aleja\.wezterm.lua`).

```powershell
# Opción 1: Symlink desde WSL (PowerShell como Admin)
New-Item -ItemType SymbolicLink -Path "$HOME\.wezterm.lua" -Target "\\wsl.localhost\Ubuntu\home\alejoliz\dev\dotfiles\wezterm\.wezterm.lua"

# Opción 2: Copiar manualmente
Copy-Item "\\wsl.localhost\Ubuntu\home\alejoliz\dev\dotfiles\wezterm\.wezterm.lua" "$HOME\.wezterm.lua"
```

El symlink es preferible porque los cambios en dotfiles se reflejan automáticamente.

## Configuración actual

### Font

- **Fuente:** IosevkaTerm NF (Nerd Font con iconos)
- **Tamaño:** 14.0

### Ventana

| Opción | Valor | Descripción |
|--------|-------|-------------|
| Transparencia | 95% | Fondo semi-transparente |
| Blur | Acrylic (Win) / 20 (macOS) | Efecto difuminado |
| Padding | 0 | Sin márgenes internos |
| Tab bar | Auto-hide | Se oculta con una sola tab |
| Scrollbar | Oculto | Más espacio para contenido |

### Tema: Gentleman

```
Background: #06080f (azul muy oscuro)
Foreground: #f3f6f9 (blanco suave)
Cursor:     #e0c15a (dorado)
Selection:  #263356
```

Paleta inspirada en temas oscuros japoneses con colores suaves.

### Optimizaciones para Neovim

| Opción | Valor | Propósito |
|--------|-------|-----------|
| `underline_thickness` | 2 | Undercurl más visible para diagnósticos LSP |
| `underline_position` | -2 | Posición debajo del texto |
| `scrollback_lines` | 10000 | Buffer de historial amplio |
| `max_fps` | 240 | Scroll y animaciones suaves |
| `enable_kitty_graphics` | true | Soporte de imágenes en terminal |
| `use_dead_keys` | false | Input más rápido |
| `alt_passthrough` | true | Alt funciona correctamente en Neovim |

## Atajos de teclado

### Splits

| Atajo | Acción |
|-------|--------|
| `Ctrl+Alt+U` | Split horizontal (abre WSL:Ubuntu) |
| `Ctrl+Alt+V` | Split vertical |
| `Ctrl+Shift+W` | Cerrar pane actual (con confirmación) |

### Navegación entre panes

| Atajo | Dirección |
|-------|-----------|
| `Ctrl+Shift+←` | Mover a pane izquierdo |
| `Ctrl+Shift+→` | Mover a pane derecho |
| `Ctrl+Shift+↑` | Mover a pane superior |
| `Ctrl+Shift+↓` | Mover a pane inferior |

## Notas

- **Flujo de trabajo:** WezTerm corre en Windows → abre shells en WSL:Ubuntu → ahí uso Neovim y otras herramientas
- **`config.term = "wezterm"`** está deshabilitado porque causa conflictos con zsh-autosuggestions
- El split horizontal (`Ctrl+Alt+U`) abre directamente WSL:Ubuntu (no PowerShell)
- Soporta OSC 52 para clipboard, permitiendo copy/paste entre Windows y Neovim en WSL
