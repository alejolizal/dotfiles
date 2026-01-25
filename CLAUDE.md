# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Descripción

Repositorio de configuraciones personales (dotfiles) para desarrollo. Sistema: Ubuntu 24.04 en WSL2, terminal WezTerm desde Windows.

## Arquitectura

```
dotfiles/
├── nvim/           # Neovim con LazyVim (symlink a ~/.config/nvim)
├── wezterm/        # Terminal WezTerm (se copia a Windows, no a Linux)
├── git/            # Git config (se incluye via git config --global include.path)
├── mason/          # Mason LSP/DAP (placeholder)
├── terminal/       # Shell configs (placeholder)
├── scripts/        # Scripts útiles (placeholder)
└── tools/          # Otras herramientas (placeholder)
```

## Comandos de Instalación

```bash
# Neovim - crear symlink
ln -sf ~/dev/dotfiles/nvim ~/.config/nvim

# Git - incluir configuración
git config --global include.path ~/dev/dotfiles/git/.gitconfig

# WezTerm - en PowerShell como Admin (Windows)
New-Item -ItemType SymbolicLink -Path "$HOME\.wezterm.lua" -Target "\\wsl.localhost\Ubuntu\home\alejoliz\dev\dotfiles\wezterm\.wezterm.lua"
```

## Neovim

- Framework: LazyVim
- Versiones fijadas en `nvim/lazy-lock.json`
- Clipboard OSC 52 configurado en `nvim/lua/config/options.lua` (funciona sobre SSH)

### Plugins clave

| Plugin | Archivo | Propósito |
|--------|---------|-----------|
| nvim-jdtls | `lua/plugins/java.lua` | Java LSP + debugging con DAP |
| claudecode.nvim | `lua/plugins/claude.lua` | Integración Claude Code |
| nvim-dap | `lua/plugins/dap.lua` | Debug Adapter Protocol |

### Keymaps importantes

- `<leader>ac` - Toggle Claude Code
- `<leader>tm` - Test método Java actual
- `<leader>tc` - Test clase Java

## Git Aliases

| Alias | Descripción |
|-------|-------------|
| `git lg` | Log visual con gráfico |
| `git info <hash>` | Resumen de commit + archivos |
| `git detail <hash>` | Resumen + diff completo |

## Notas técnicas

- Java 21 vía SDKMAN: `~/.sdkman/candidates/java/21.0.9-tem`
- Mason usa `$MASON` (API 2.0+), no `get_install_dir()`
- WezTerm: `config.term = "wezterm"` deshabilitado por conflicto con zsh-autosuggestions
