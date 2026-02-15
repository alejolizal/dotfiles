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
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# source /mnt/c/Users/aleja/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export EDITOR="cursor --wait"

# Personal PATH prioritario
export PATH=$HOME/.local/bin:/home/alejoliz/.opencode/bin:$PATH

# Alias para nvim (snap)
alias nvim="/snap/bin/nvim"
>>>>>>> refs/remotes/origin/main

# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

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
