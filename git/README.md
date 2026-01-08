# Configuración de Git

Configuraciones globales de Git.

## Archivos

```
git/
├── .gitconfig         # Configuración global
├── .gitignore_global  # Ignore global
└── README.md
```

## Respaldar configuración actual

```bash
cp ~/.gitconfig ~/dotfiles/git/
cp ~/.gitignore_global ~/dotfiles/git/
```

## Restaurar configuración

```bash
# Opción 1: Symlinks
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/git/.gitignore_global ~/.gitignore_global

# Opción 2: Include en .gitconfig existente
git config --global include.path ~/dotfiles/git/.gitconfig
```

## Configuraciones comunes

### Información de usuario

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"
```

### Aliases útiles

```bash
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```

### Herramientas

```bash
git config --global core.editor nvim
git config --global merge.tool vimdiff
git config --global diff.tool vimdiff
```
