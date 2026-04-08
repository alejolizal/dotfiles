# zmodload zsh/zprof
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# --- PATH ---
typeset -U path
path=(
  $HOME/.local/bin
  /usr/local/go/bin
  $path
)

# Sin tema de OMZ - Oh My Posh se encarga del prompt
ZSH_THEME=""

plugins=(git 
	z 
	zsh-syntax-highlighting
        zsh-autosuggestions
          nvm)

ZSH_DISABLE_COMPFIX="true"
zstyle ':omz:plugins:nvm' lazy yes

source $ZSH/oh-my-zsh.sh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8a8fa3"

# Personal PATH prioritario
# export PATH=$HOME/.local/bin:/home/alejoliz/.opencode/bin:$PATH

# Oh My Posh - prompt
# eval "$(oh-my-posh init zsh --config ~/.mytheme.omp.json)"
# eval "$(oh-my-posh init zsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/clean-detailed.omp.json)"
eval "$(oh-my-posh init zsh --config ~/.mytheme.omp.yaml)"

# Editor
export EDITOR="nvim --wait"

#path de golang:wait
# export PATH=/usr/local/go/bin:$PATH

# Alias para nvim (snap)
alias nvim="/snap/bin/nvim"

# setopt complete_in_word
# autoload -Uz compinit && compinit

eval "$(zoxide init zsh)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


# export PATH="$HOME/.local/bin:$PATH"
# export LD_LIBRARY_PATH=/usr/lib/oracle/23/client64/lib:$LD_LIBRARY_PATH
# export TNS_ADMIN=~/oracle
# alias devx-db='sqlplus $(cat ~/.oracle/devx)'

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
# --- Config local (secretos, máquina-específico, no versionar) ---
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
# zprof
