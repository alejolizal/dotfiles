# Configuración de Wezterm

Wezterm es un emulador de terminal GPU-acelerado y multiplataforma.

## Estructura esperada

```
wezterm/
├── wezterm.lua          # Archivo principal de configuración
├── colors/              # Esquemas de colores personalizados (opcional)
└── fonts/               # Configuración de fuentes (opcional)
```

## Respaldar configuración actual

```bash
cp -r ~/.config/wezterm/* ~/dotfiles/wezterm/
# O si está en la home:
cp ~/.wezterm.lua ~/dotfiles/wezterm/
```

## Restaurar configuración

```bash
# Opción 1: Symlink al directorio
ln -sf ~/dotfiles/wezterm ~/.config/wezterm

# Opción 2: Symlink al archivo (si usas solo wezterm.lua en home)
ln -sf ~/dotfiles/wezterm/wezterm.lua ~/.wezterm.lua
```

## Características configurables

- Temas y colores
- Fuentes y tamaño
- Atajos de teclado
- Tabs y splits
- Opacidad y efectos visuales
- Integración con multiplexers
