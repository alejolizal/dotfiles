# Configuraciones de Terminal/Shell

Configuraciones de Zsh con Oh My Zsh y Powerlevel10k.

## Archivos

```
terminal/
├── .p10k.zsh      # Tema Powerlevel10k
└── README.md
```

## Powerlevel10k

Tema configurado con:
- **Estilo:** Lean (minimalista)
- **Iconos:** Nerd Font + Powerline
- **Prompt:** 2 líneas, transient prompt
- **Hora:** 24h
- **Frame:** Izquierdo, solid

### Restaurar

```bash
# Copiar configuración de p10k
cp ~/dev/dotfiles/terminal/.p10k.zsh ~/.p10k.zsh

# Asegurar que .zshrc lo carga (ya debería estar si usas p10k)
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
```

### Requisitos

1. **Oh My Zsh** instalado
2. **Powerlevel10k** instalado:
   ```bash
   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
   ```
3. **Nerd Font** instalada (ej: IosevkaTerm NF)
4. En `.zshrc`: `ZSH_THEME="powerlevel10k/powerlevel10k"`

### Reconfigurar

Si quieres modificar el tema:

```bash
p10k configure
```

## Zsh plugins recomendados

Agregar a `.zshrc` en la línea de plugins:

```bash
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
```

Instalar plugins:

```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```
