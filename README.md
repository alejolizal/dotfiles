# Dotfiles

Respaldo organizado de configuraciones personales para desarrollo.

**Versión actual:** `v1.0.0` - Primera versión funcional estable
**Fecha:** 2026-01-08

## 🎯 Características principales (v1.0.0)

✅ **Neovim/LazyVim** - Editor configurado y optimizado
✅ **Java LSP (jdtls)** - Desarrollo Java con debugging
✅ **Claude Code** - Integración AI en Neovim
✅ **Clipboard OSC 52** - Copy/paste sobre SSH sin X11
✅ **Versiones fijadas** - Reproducible con lazy-lock.json

## 📋 Requisitos

### Esenciales
- **Neovim** >= 0.10.0 (actual: 0.11.5)
- **Git** >= 2.40
- **Java 21** - Para desarrollo Java y jdtls
  - Se recomienda instalar con [SDKMAN](https://sdkman.io/)
  - ```bash
    # Instalar SDKMAN
    curl -s "https://get.sdkman.io" | bash

    # Instalar Java 21
    sdk install java 21.0.9-tem
    sdk default java 21.0.9-tem
    ```
- **Claude Code CLI** >= 2.1.0 (instalado en `~/.local/bin/claude`)

### Opcionales
- **xclip** - Para clipboard en X11 (ya incluido como fallback)
- Terminal con soporte OSC 52 (WezTerm, iTerm2, Windows Terminal, etc.)

## 🔌 Plugins principales y versiones

### Core
- **LazyVim** - Framework base
- **lazy.nvim** - Plugin manager
- **snacks.nvim** - Utilidades de Folke

### Java Development
- **nvim-jdtls** (`f73731b`) - Language Server Java
- **nvim-dap** - Debug Adapter Protocol
- **java-debug-adapter** - Debugging Java
- **java-test** - Ejecución de tests

### LSP & Tools
- **mason.nvim** (`44d1e90`) - Instalador de LSP/DAP/formatters
- **mason-lspconfig.nvim** (`e5f73a9`) - Integración Mason-LSP

### AI Integration
- **claudecode.nvim** (`93f8e48`) - Claude Code en Neovim
  - Comandos: `:ClaudeCode`, `:ClaudeCodeFocus`
  - Atajos: `<Space>ac`, `<Space>af`, `<Space>ab`, `<Space>aa`, `<Space>ad`

### Clipboard
- **OSC 52** (built-in) - Copy/paste sobre SSH

## 📂 Estructura

```
dotfiles/
├── nvim/              # Configuración de Neovim/LazyVim
│   ├── init.lua       # Archivo principal de configuración
│   ├── lazy-lock.json # Versiones fijadas de plugins
│   ├── lua/
│   │   ├── config/    # Configuraciones base
│   │   │   ├── options.lua    # Opciones de Neovim (clipboard OSC 52)
│   │   │   ├── keymaps.lua    # Atajos de teclado
│   │   │   ├── autocmds.lua   # Autocomandos
│   │   │   └── lazy.lua       # Configuración de lazy.nvim
│   │   └── plugins/   # Plugins personalizados
│   │       ├── java.lua       # Configuración jdtls + debugging
│   │       ├── claude.lua     # Configuración claudecode.nvim
│   │       ├── dap.lua        # Debug Adapter Protocol
│   │       └── example.lua    # Ejemplos de LazyVim
│   └── ftplugin/
│       └── java.lua   # Configuraciones específicas para Java
├── wezterm/           # Configuración de Wezterm terminal
├── mason/             # Configuración de Mason (LSP/DAP/Linters)
├── terminal/          # Configuraciones de shell (fish/zsh/bash)
├── git/               # Configuraciones de Git
├── scripts/           # Scripts útiles
└── tools/             # Otras herramientas

```

## 🚀 Instalación

### Clonar el repositorio

```bash
git clone https://github.com/alejolizal/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### Instalar Neovim

```bash
# Crear symlink a la configuración de nvim
ln -sf ~/dotfiles/nvim ~/.config/nvim

# Abrir Neovim (instalará plugins automáticamente)
nvim
```

Al abrir Neovim por primera vez, LazyVim instalará automáticamente todos los plugins según las versiones fijadas en `lazy-lock.json`.

### Configurar Java (opcional)

Si vas a desarrollar en Java:

```bash
# Instalar SDKMAN si no lo tienes
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Instalar Java 21
sdk install java 21.0.9-tem
sdk default java 21.0.9-tem

# Verificar instalación
java -version
```

### WezTerm (en Windows)

WezTerm es el terminal que uso desde Windows para conectar a WSL. La config debe copiarse en Windows:

```powershell
# PowerShell como Admin - crear symlink
New-Item -ItemType SymbolicLink -Path "$HOME\.wezterm.lua" -Target "\\wsl.localhost\Ubuntu\home\alejoliz\dev\dotfiles\wezterm\.wezterm.lua"
```

Ver `wezterm/README.md` para más detalles.

### Git (opcional)

```bash
# Aplicar configuración de Git
git config --global include.path ~/dotfiles/git/.gitconfig
```

## 🎮 Uso

### Atajos de teclado principales

#### Claude Code AI
- `<Space>ac` - Toggle Claude Code
- `<Space>af` - Focus en Claude
- `<Space>ab` - Agregar buffer actual a Claude
- `<Space>aa` - Aceptar diff de Claude
- `<Space>ad` - Rechazar diff de Claude

#### Java (en archivos .java)
- `<leader>tm` - Ejecutar test del método actual
- `<leader>tc` - Ejecutar tests de la clase

#### Clipboard
- `yy` - Copiar línea (va al clipboard del sistema)
- `p` - Pegar desde clipboard del sistema
- `"+y` - Copiar explícitamente al clipboard
- `"+p` - Pegar explícitamente del clipboard

## 🔄 Actualizar configuración

Para actualizar tu configuración local:

```bash
cd ~/dotfiles
git pull origin main
```

Para respaldar cambios nuevos:

```bash
cd ~/dotfiles
git add .
git commit -m "descripción de cambios"
git push
```

## 📝 Changelog

### v1.0.0 (2026-01-08) - Primera versión estable

**✨ Features:**
- Configuración completa de Neovim con LazyVim
- Integración de jdtls para desarrollo Java con debugging
- Plugin claudecode.nvim para usar Claude Code desde Neovim
- Clipboard OSC 52 para copy/paste sobre SSH
- Versiones de plugins fijadas con lazy-lock.json

**🔧 Fixes:**
- Actualizada API de Mason 2.0+ (usar $MASON en lugar de get_install_dir)
- Configurado terminal_cmd para claudecode.nvim
- Soporte para sesiones SSH sin X11

**📚 Commits:**
- 8 commits desde el inicio del proyecto
- Todos los cambios respaldados en GitHub

## 📌 Notas

- Asegúrate de revisar los archivos antes de commitear para no incluir información sensible
- Los archivos de caché y datos temporales están en `.gitignore`
- El `lazy-lock.json` garantiza que todos los plugins se instalen en las mismas versiones
- Compatible con sesiones SSH (no requiere X11 forwarding gracias a OSC 52)

## 🏷️ Versiones

Para ver todas las versiones disponibles:

```bash
git tag -l
```

Para cambiar a una versión específica:

```bash
git checkout v1.0.0
```

---

**Mantenido por:** @alejolizal
**Licencia:** Uso personal
