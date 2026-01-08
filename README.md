# Dotfiles

Respaldo organizado de configuraciones personales para desarrollo.

## Estructura

```
dotfiles/
├── nvim/              # Configuración de Neovim/LazyVim
│   ├── init.lua       # Archivo principal de configuración
│   ├── lua/           # Módulos Lua personalizados
│   └── lazy-lock.json # Lock file de LazyVim
├── wezterm/           # Configuración de Wezterm terminal
│   └── wezterm.lua    # Archivo de configuración principal
├── mason/             # Configuración de Mason (LSP/DAP/Linters/Formatters)
│   └── README.md      # Lista de paquetes instalados
├── terminal/          # Configuraciones de shell
│   ├── fish/          # Fish shell
│   ├── zsh/           # Zsh shell
│   └── bash/          # Bash shell
├── git/               # Configuraciones de Git
│   ├── .gitconfig     # Configuración global de Git
│   └── .gitignore_global
├── scripts/           # Scripts útiles
└── tools/             # Otras herramientas y configuraciones

```

## Instalación

### Neovim

```bash
# Crear symlink a la configuración de nvim
ln -sf ~/dotfiles/nvim ~/.config/nvim
```

### Wezterm

```bash
# Crear symlink a la configuración de Wezterm
ln -sf ~/dotfiles/wezterm ~/.config/wezterm
```

### Git

```bash
# Aplicar configuración de Git
git config --global include.path ~/dotfiles/git/.gitconfig
```

## Respaldo

Para respaldar tus configuraciones actuales:

```bash
# Neovim
cp -r ~/.config/nvim/* ~/dotfiles/nvim/

# Wezterm
cp -r ~/.config/wezterm/* ~/dotfiles/wezterm/

# Git
cp ~/.gitconfig ~/dotfiles/git/.gitconfig
```

## Notas

- Asegúrate de revisar los archivos antes de commitear para no incluir información sensible
- Los archivos de caché y datos temporales deben estar en .gitignore
