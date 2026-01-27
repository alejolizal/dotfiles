# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Descripción

Repositorio de configuraciones personales (dotfiles) para desarrollo. Sistema: Ubuntu 24.04 en WSL2, terminal WezTerm desde Windows.

## Arquitectura

Usa GNU Stow para gestionar symlinks. Cada carpeta es un "paquete" que replica su estructura en `~`.

```
dotfiles/
├── nvim/                      # -> ~/.config/nvim (via stow)
│   └── .config/nvim/
├── terminal/                  # -> ~/.zshrc, ~/.p10k.zsh (via stow)
├── wezterm/                   # -> ~/.wezterm.lua (via stow)
├── git/                       # -> ~/.gitconfig (via stow)
├── lazygit/                   # -> ~/.config/lazygit (via stow)
├── mason/                     # Mason LSP/DAP (placeholder)
├── scripts/                   # Scripts útiles (placeholder)
└── tools/                     # Otras herramientas (placeholder)
```

## Comandos de Instalación

```bash
# Requisito
sudo apt install stow

# Aplicar todos los paquetes (-t ~ especifica home como target)
cd ~/dev/dotfiles
stow -t ~ nvim terminal git wezterm lazygit

# Desinstalar
stow -t ~ -D nvim terminal git wezterm lazygit
```

### WezTerm en Windows (opcional)

```powershell
# PowerShell como Admin
New-Item -ItemType SymbolicLink -Path "$HOME\.wezterm.lua" -Target "\\wsl.localhost\Ubuntu\home\alejoliz\dev\dotfiles\wezterm\.wezterm.lua"
```

## Neovim

- Framework: LazyVim
- Versiones fijadas en `nvim/.config/nvim/lazy-lock.json`
- Clipboard OSC 52 configurado en `nvim/.config/nvim/lua/config/options.lua` (funciona sobre SSH)

### Plugins clave

| Plugin | Archivo | Propósito |
|--------|---------|-----------|
| nvim-jdtls | `nvim/.config/nvim/lua/plugins/java.lua` | Java LSP + debugging con DAP |
| claudecode.nvim | `nvim/.config/nvim/lua/plugins/claude.lua` | Integración Claude Code |
| nvim-dap | `nvim/.config/nvim/lua/plugins/dap.lua` | Debug Adapter Protocol |

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
