# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Sin tema de OMZ - Oh My Posh se encarga del prompt
ZSH_THEME=""

export CENTAURI_DB_URL="postgresql://centauri:6tT552j.d@hamal.sii.cl:5432/dbcentauri"

plugins=(git 
	z 
	docker-compose 
	zsh-syntax-highlighting
        zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8a8fa3"

# Personal PATH prioritario
export PATH=$HOME/.local/bin:/home/alejoliz/.opencode/bin:$PATH

# Oh My Posh - prompt
# eval "$(oh-my-posh init zsh --config ~/.mytheme.omp.json)"
# eval "$(oh-my-posh init zsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/clean-detailed.omp.json)"
eval "$(oh-my-posh init zsh --config ~/.mytheme.omp.yaml)"

# Editor
export EDITOR="nvim --wait"

#path de golang
export PATH=/usr/local/go/bin:$PATH

# Alias para nvim (snap)
alias nvim="/snap/bin/nvim"

setopt complete_in_word
autoload -Uz compinit && compinit

eval "$(zoxide init zsh)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
export PATH="$HOME/.local/bin:$PATH"
# export LD_LIBRARY_PATH=/usr/lib/oracle/23/client64/lib:$LD_LIBRARY_PATH
# export TNS_ADMIN=~/oracle
# alias devx-db='sqlplus $(cat ~/.oracle/devx)'

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
