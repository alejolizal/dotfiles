# Configuración de Git

Configuraciones globales de Git.

## Archivos

```
git/
├── .gitconfig         # Configuración global
├── .gitignore_global  # Ignore global
└── README.md
```

## Activar configuración

```bash
# Opción 1: Include (recomendado - no sobrescribe tu .gitconfig)
git config --global include.path ~/dev/dotfiles/git/.gitconfig

# Opción 2: Symlink (reemplaza tu .gitconfig)
ln -sf ~/dev/dotfiles/git/.gitconfig ~/.gitconfig
```

## Aliases personalizados

| Alias | Uso | Descripción |
|-------|-----|-------------|
| `st` | `git st` | Status abreviado |
| `co` | `git co <branch>` | Checkout |
| `br` | `git br` | Listar branches |
| `ci` | `git ci -m "msg"` | Commit |
| `lg` | `git lg -20` | Log visual con gráfico, fecha y autor |
| `info` | `git info <hash>` | Resumen del commit + archivos modificados |
| `detail` | `git detail <hash>` | Resumen del commit + diff completo |
| `unstage` | `git unstage <file>` | Quitar archivo del staging |
| `last` | `git last` | Ver último commit |

## Ejemplos de uso

### `git lg` - Log visual

```bash
git lg -10
```

Salida:
```
* a1b2c3d 2025-01-20 Agregar validación de inputs [alejolizal]
* e4f5g6h 2025-01-19 Fix bug en login [alejolizal]
| * i7j8k9l 2025-01-18 Feature experimental [otro-dev]
|/
* m0n1o2p 2025-01-17 Initial commit [alejolizal]
```

### `git info` - Resumen de commit

```bash
git info HEAD
```

Salida:
```
Commit: a1b2c3d
Fecha: 2025-01-20
Autor: alejolizal <alejandroliz.liz@gmail.com>

Agregar validación de inputs

Se agregó validación para prevenir inyección SQL.

 src/validation.js | 25 +++++++++++++
 src/forms.js      |  8 ++--
 2 files changed, 30 insertions(+), 3 deletions(-)
```

### `git detail` - Commit con diff

```bash
git detail HEAD~1
```

Muestra lo mismo que `info` pero incluye el diff completo de los cambios.

## Verificar configuración

```bash
# Ver que se cargaron los aliases
git config --global --list | grep alias

# Probar
git lg -5
git info HEAD
```
