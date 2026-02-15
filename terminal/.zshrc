# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

plugins=(git 
	docker-compose 
	zsh-syntax-highlighting
        zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# Optimizar compinit: solo reconstruir cache si tiene más de 24h
autoload -Uz compinit
if [ "$(find ~/.zcompdump -mtime +1 2>/dev/null)" ]; then
  compinit
else
  compinit -C
fi
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8a8fa3"

export EDITOR="nvim"

# Personal PATH
export PATH=$HOME/.local/bin:$HOME/.opencode/bin:$PATH
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

setopt complete_in_word

#esta es la instalacion de zoxide
eval "$(zoxide init zsh)"

#instalacion de oh my posh
eval "$(oh-my-posh init zsh --config ~/omp/myconfig.omp.json)"

# nvm (lazy loading para arranque rápido)
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}
node() { nvm; node "$@"; }
npm() { nvm; npm "$@"; }
npx() { nvm; npx "$@"; }

export PATH=$PATH:/usr/local/lib/go/bin

# SDKMAN (descomentar cuando se necesite)
#export SDKMAN_DIR="$HOME/.sdkman"
#[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
