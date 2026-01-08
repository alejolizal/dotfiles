# Otras Herramientas y Configuraciones

Configuraciones adicionales para herramientas de desarrollo.

## Herramientas comunes

### tmux
```
tools/tmux/
└── .tmux.conf
```

### Starship (prompt)
```
tools/starship/
└── starship.toml
```

### ripgrep
```
tools/ripgrep/
└── .ripgreprc
```

### bat (cat mejorado)
```
tools/bat/
└── config
```

### fd (find mejorado)
```
tools/fd/
└── ignore
```

### lazygit
```
tools/lazygit/
└── config.yml
```

## Respaldar configuraciones

```bash
# tmux
cp ~/.tmux.conf ~/dotfiles/tools/tmux/

# Starship
cp ~/.config/starship.toml ~/dotfiles/tools/starship/

# lazygit
cp ~/.config/lazygit/config.yml ~/dotfiles/tools/lazygit/
```
