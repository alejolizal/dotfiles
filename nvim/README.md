# Configuración de Neovim

Esta carpeta contiene la configuración completa de Neovim con LazyVim.

## Estructura esperada

```
nvim/
├── init.lua              # Punto de entrada principal
├── lazy-lock.json        # Lock file de plugins (LazyVim)
├── lua/
│   ├── config/           # Configuraciones generales
│   │   ├── autocmds.lua  # Auto-comandos
│   │   ├── keymaps.lua   # Atajos de teclado
│   │   ├── lazy.lua      # Configuración de lazy.nvim
│   │   └── options.lua   # Opciones de Neovim
│   └── plugins/          # Configuración de plugins
│       └── *.lua         # Archivos de configuración de plugins
└── stylua.toml           # Configuración de formateador Lua (opcional)
```

## Respaldar configuración actual

```bash
cp -r ~/.config/nvim/* ~/dotfiles/nvim/
```

## Restaurar configuración

```bash
# Respaldar configuración actual (si existe)
mv ~/.config/nvim ~/.config/nvim.backup

# Crear symlink
ln -sf ~/dotfiles/nvim ~/.config/nvim
```

## Plugins principales (LazyVim)

LazyVim es una distribución de Neovim que incluye:
- LSP configurado
- Treesitter
- Telescope
- Neo-tree
- Y muchos más plugins preconfigurados

## Mason

Los LSPs, DAPs, linters y formatters se instalan con Mason.
Ver la carpeta `mason/` para la lista de paquetes.
