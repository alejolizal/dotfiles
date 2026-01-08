# Configuraciones de Terminal/Shell

Esta carpeta contiene configuraciones para diferentes shells.

## Estructura

```
terminal/
├── fish/          # Fish shell
│   └── config.fish
├── zsh/           # Zsh shell
│   ├── .zshrc
│   ├── .zshenv
│   └── aliases.zsh
└── bash/          # Bash shell
    ├── .bashrc
    ├── .bash_profile
    └── .bash_aliases
```

## Fish Shell

```bash
# Respaldar
cp ~/.config/fish/config.fish ~/dotfiles/terminal/fish/

# Restaurar
ln -sf ~/dotfiles/terminal/fish/config.fish ~/.config/fish/config.fish
```

## Zsh

```bash
# Respaldar
cp ~/.zshrc ~/dotfiles/terminal/zsh/
cp ~/.zshenv ~/dotfiles/terminal/zsh/

# Restaurar
ln -sf ~/dotfiles/terminal/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/terminal/zsh/.zshenv ~/.zshenv
```

## Bash

```bash
# Respaldar
cp ~/.bashrc ~/dotfiles/terminal/bash/
cp ~/.bash_profile ~/dotfiles/terminal/bash/

# Restaurar
ln -sf ~/dotfiles/terminal/bash/.bashrc ~/.bashrc
ln -sf ~/dotfiles/terminal/bash/.bash_profile ~/.bash_profile
```

## Temas y plugins comunes

### Oh My Zsh
- Ubicación: `~/.oh-my-zsh`
- No se respalda todo, solo `.zshrc` con la configuración

### Starship (prompt moderno)
- Configuración: `~/.config/starship.toml`

### tmux
- Configuración: `~/.tmux.conf`
