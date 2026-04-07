# sii-dev-base - Imagen Base de Desarrollo

Imagen Docker que replica el entorno de desarrollo del equipo SII.

## Contenido

| Componente | Version |
|-----------|---------|
| Ubuntu | 24.04 LTS |
| Java (default) | 17.0.17-tem |
| Java (JDTLS) | 21.0.9-tem |
| Java (batch) | 11.0.25-tem |
| Maven | 3.8.7 |
| Node.js | 25.1.0 |
| npm | 11.6.2 |
| Neovim | 0.11.5 |
| Claude Code | latest |
| ripgrep | 14.1.0 |
| fd | 9.0.0 |
| fzf | 0.44.1 |
| lazygit | 0.44.1 |
| lazydocker | 0.24.1 |
| jq | 1.7 |
| httpie | 3.2.2 |

## Construccion

```bash
./build.sh
```

Esto construye la imagen `sii-dev-base:latest`.

## Uso

Esta imagen no se usa directamente. Los proyectos extienden de ella:

```dockerfile
FROM sii-dev-base:latest
# Configuraciones específicas del proyecto
```

## Estructura

```
devcontainer-base/
├── Dockerfile          # Imagen con todas las herramientas
├── build.sh            # Script de construccion
├── nvim-config/        # Config de Neovim (LazyVim + plugins)
└── zsh-config/         # Config de Zsh (Oh My Zsh + P10k)
```

## Aliases disponibles

| Alias | Comando |
|-------|---------|
| `mvnc` | `mvn clean install -DskipTests` |
| `mvnr` | `mvn spring-boot:run` |
| `mvnt` | `mvn test` |
| `mvnv` | `mvn verify` |
| `vd` | `npm run dev` |
| `vt` | `npm run test` |
| `vtu` | `npx vitest` |
| `vtc` | `npx vitest --coverage` |
| `ve2e` | `npx playwright test` |
| `lg` | `lazygit` |
| `ld` | `lazydocker` |
| `vi/vim` | `nvim` |
| `gs` | `git status` |
| `gd` | `git diff` |
| `gl` | `git log --oneline -20` |

## Java con SDKMAN

Cambiar version de Java:

```bash
sdk use java 17.0.17-tem   # Default para proyectos modernos
sdk use java 11.0.25-tem   # Para procesos batch
sdk use java 21.0.9-tem    # Para JDTLS (automatico en Neovim)
```
