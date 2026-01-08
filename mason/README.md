# Mason - Gestor de LSP/DAP/Linters/Formatters

Mason es un gestor de paquetes para Neovim que facilita la instalación de:
- Language Servers (LSP)
- Debug Adapters (DAP)
- Linters
- Formatters

## Paquetes instalados

Documenta aquí los paquetes que tienes instalados con Mason.

### Language Servers (LSP)

- [ ] lua-language-server (Lua)
- [ ] pyright (Python)
- [ ] typescript-language-server (TypeScript/JavaScript)
- [ ] rust-analyzer (Rust)
- [ ] gopls (Go)
- [ ] clangd (C/C++)
- [ ] bashls (Bash)
- [ ] jsonls (JSON)
- [ ] yamlls (YAML)

### Formatters

- [ ] stylua (Lua)
- [ ] black (Python)
- [ ] prettier (JS/TS/JSON/YAML/etc)
- [ ] rustfmt (Rust)
- [ ] gofmt (Go)

### Linters

- [ ] eslint_d (JavaScript/TypeScript)
- [ ] pylint (Python)
- [ ] shellcheck (Bash)

### Debug Adapters (DAP)

- [ ] debugpy (Python)
- [ ] node-debug2-adapter (Node.js)
- [ ] codelldb (Rust/C/C++)

## Comandos útiles en Neovim

```vim
:Mason              " Abrir Mason UI
:MasonInstall <pkg> " Instalar paquete
:MasonUpdate        " Actualizar paquetes
:MasonLog           " Ver logs
```

## Respaldar lista de paquetes

Puedes listar los paquetes instalados desde Neovim:

```vim
:Mason
```

O desde la terminal:

```bash
ls ~/.local/share/nvim/mason/packages/
```

## Restaurar paquetes

Los paquetes se pueden reinstalar fácilmente desde Mason UI en Neovim.
Considera documentar los paquetes esenciales en este archivo.
