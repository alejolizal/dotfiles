# Prompt para Claude CLI - Generación de DevContainer

Copia y pega esto en tu terminal con `claude`:

---

Necesito que me ayudes a crear un entorno de desarrollo contenerizado completo. Sigue estos pasos en orden:

## FASE 1: Escaneo de mi entorno actual

Antes de generar cualquier archivo, escanea mi máquina para entender qué tengo instalado. Ejecuta estos comandos y analiza los resultados:

### Sistema

- `cat /etc/os-release` → distro y versión
- `uname -a` → kernel
- `df -h` → espacio disponible

### Lenguajes y herramientas de build

- `java -version`
- `mvn -version`
- `node --version && npm --version`

### Shell y terminal

- `echo $SHELL`
- `cat ~/.zshrc` → config actual del shell
- `ls ~/.oh-my-zsh/custom/plugins/` → plugins de Oh My Zsh (si existe)
- `ls ~/.oh-my-zsh/custom/themes/` → temas (si existe)

### Neovim

- `nvim --version`
- `cat ~/.config/nvim/init.lua` o `ls ~/.config/nvim/` → estructura de config
- `cat ~/.config/nvim/lazy-lock.json` → plugins instalados con versiones exactas
- `ls ~/.config/nvim/lua/plugins/` → configs de plugins custom
- Lee todos los archivos de `~/.config/nvim/lua/plugins/` para entender mi config completa

### Herramientas CLI

Verifica cuáles de estas tengo instaladas y sus versiones:

- ripgrep (`rg --version`)
- fd (`fdfind --version` o `fd --version`)
- fzf (`fzf --version`)
- lazygit (`lazygit --version`)
- lazydocker (`lazydocker --version`)
- jq (`jq --version`)
- httpie (`http --version`)
- tree, curl, wget, git
- docker (`docker --version`)
- kubectl (`kubectl version --client`)
- helm (`helm version`)

### Claude Code

- `claude --version`

### Bases de datos

- la base de datos puede ser postgresql o oraclesql, pero en esta organizacion la base de datos se entrega lista, no va dentro del container, solo llegar y conectarse con los datos de application.properties.

### Puertos en uso

- `ss -tlnp` → puertos activos

### Proyectos

- Lista los directorios de mis proyectos en mi workspace
- Identifica qué stack usa cada uno (pom.xml → Java/Maven, package.json → Node, etc.)
- Nota las versiones de Java de cada proyecto (revisa pom.xml por java.version)
- EXCLUYE proyectos legados: cualquier proyecto que use JBoss, AngularJS, Struts, JSF, EJBs o Java EE antiguo. Solo considera proyectos modernos (Spring Boot + Vue.js). Si no estás seguro, pregúntame antes de incluirlo.

## FASE 2: Generar imagen base

Con la información del escaneo, genera un directorio `devcontainer-base/` con:

### Estructura

```
devcontainer-base/
├── Dockerfile                    ← Imagen base con TODO lo que encontraste
├── build.sh                      ← Script para construir: docker build -t sii-dev-base:latest .
├── nvim-config/                  ← Copia EXACTA de mi config de Neovim
│   └── lua/plugins/              ← Todos mis plugins
├── zsh-config/
│   └── .zshrc                    ← Mi .zshrc actual (adaptado al contenedor)
└── README.md                     ← Documentación
```

### Requisitos del Dockerfile base

- Debe replicar EXACTAMENTE las herramientas y versiones que encontraste
- Incluir: Neovim (última versión), Zsh + Oh My Zsh con mis plugins actuales
- Incluir: lazygit, lazydocker, ripgrep, fd, fzf, jq, httpie, tree
- Incluir: Claude Code CLI
- Incluir: pre-commit, commitlint
- Incluir: JDTLS (Java Language Server) con Lombok si uso Java
- Incluir: las dependencias de sistema para Playwright (para testing E2E)
- Usuario no-root (vscode)
- Shell por defecto: zsh
- Mis aliases y configuración de shell
- Variable EDITOR=nvim

### Aliases mínimos que deben estar

```
mvnc  → mvn clean install -DskipTests
mvnr  → mvn spring-boot:run
mvnt  → mvn test
mvnv  → mvn verify
vd    → npm run dev
vt    → npm run test
vtu   → npx vitest
vtc   → npx vitest --coverage
ve2e  → npx playwright test
lg    → lazygit
ld    → lazydocker
vi    → nvim
vim   → nvim
gs    → git status
gd    → git diff
gl    → git log --oneline -20
```

## FASE 3: Generar devcontainer por proyecto

Para CADA proyecto que encontraste en mi workspace, genera un `.devcontainer/` que extienda de la imagen base:

### Estructura por proyecto

```
mi-proyecto/
├── .devcontainer/
│   ├── Dockerfile              ← FROM sii-dev-base:latest + solo lo específico
│   ├── docker-compose.yml      ← Servicios (app + db si necesita)
│   ├── devcontainer.json       ← Config principal
│   ├── post-create.sh          ← Setup automático
│   ├── healthcheck.sh          ← Verificación del entorno
│   └── init-db/                ← Scripts SQL si usa BD
│       └── 01-init.sql
├── .pre-commit-config.yaml     ← Hooks de calidad
├── .commitlintrc.json          ← Conventional commits
├── .editorconfig               ← Formato consistente
├── .gitignore                  ← Actualizado para el stack del proyecto
├── CLAUDE.md                   ← Contexto para Claude Code (analiza el proyecto y genera uno útil)
├── Makefile                    ← Comandos unificados
└── dev.sh                      ← CLI helper (up, enter, nvim, claude, test, health, lazy, etc.)
```

### Requisitos del docker-compose por proyecto

- Volúmenes persistentes para: Maven cache, npm cache, nvim-data, zsh-history, claude-config, datos de BD
- Puertos forwardeados según el stack (8080 Spring Boot, 5173 Vite, 5432 PostgreSQL, etc.)
- Si el proyecto usa PostgreSQL → servicio `db` con PostgreSQL
- Si el proyecto usa Oracle → servicio Oracle (imagen gvenzl/oracle-xe) comentado como opción
- Network compartida entre servicios

### Requisitos del dev.sh

- Comandos: up, enter, nvim, claude, down, rebuild, logs, db, status, health, lazy, init
- Comandos de test: test, test-back, test-front, test-watch, test-e2e, test-coverage
- Debe usar zsh como shell al entrar
- Help con todos los comandos documentados

### Requisitos del CLAUDE.md por proyecto

- Analiza el código del proyecto y genera un CLAUDE.md específico
- Incluye: stack, estructura de directorios, convenciones, comandos útiles, notas importantes
- Esto es lo que Claude Code lee al iniciar, así que hazlo útil

## FASE 4: Verificación

Después de generar todo:

1. Construye la imagen base: `cd devcontainer-base && ./build.sh`
2. Para cada proyecto, verifica que el Dockerfile extiende bien de sii-dev-base:latest
3. Muestra un resumen de lo que generaste

## NOTAS IMPORTANTES

- NO asumas nada, basa todo en lo que encuentres instalado
- Si algo no está instalado pero debería (ej: lazydocker), agrégalo igual a la imagen base
- Las versiones deben ser EXACTAS a las que encontraste (no latest)
- La config de Neovim debe ser una COPIA de mi config actual, no una genérica
- Los puertos entre proyectos no deben chocar si los corro en paralelo
