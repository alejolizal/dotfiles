# zmodload zsh/zprof
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# --- PATH ---
typeset -U path
path=(
  $HOME/.local/bin
  $HOME/.deno/bin
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
export EDITOR="nvim"

#path de golang:wait
# export PATH=/usr/local/go/bin:$PATH

# Alias para nvim (snap)
alias nvim="/snap/bin/nvim"
# Aliases para herramientas modernas con nombres raros en Ubuntu
alias fd='fdfind'
alias bat='batcat'

# Buscar y abrir markdown del proyecto
fmd() {
  local file
  file=$(fd -e md | fzf --preview 'bat --color=always {}')
  [[ -n "$file" ]] && nvim "$file"
}

# Buscar y abrir cualquier archivo del proyecto
ffp() {
  local file
  file=$(fd --type f | fzf --preview 'bat --color=always {}')
  [[ -n "$file" ]] && nvim "$file"
}

# setopt complete_in_word
# autoload -Uz compinit && compinit

eval "$(zoxide init zsh)"



# export PATH="$HOME/.local/bin:$PATH"
# export LD_LIBRARY_PATH=/usr/lib/oracle/23/client64/lib:$LD_LIBRARY_PATH
# export TNS_ADMIN=~/oracle
# alias devx-db='sqlplus $(cat ~/.oracle/devx)'

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
# --- Config local (secretos, máquina-específico, no versionar) ---
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# uv y Python: trust store del sistema + ajustes para proxy Forcepoint del SII
# - UV_NATIVE_TLS / SSL_CERT_FILE: confiar en el CA institucional
# - OPENSSL_CONF: forzar grupos clásicos (sin ML-KEM PQC, que el proxy no procesa)
export UV_NATIVE_TLS=1
export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
export OPENSSL_CONF=$HOME/.config/openssl/classic.cnf

# kimi: restaura sitecustomize.py si un upgrade del venv lo borró
kimi() {
    local sc="$HOME/.local/share/uv/tools/kimi-cli/lib/python3.13/site-packages/sitecustomize.py"
    [[ -f "$sc" ]] || cp "$HOME/.config/kimi-fix/sitecustomize.py" "$sc"
    command kimi "$@"
}

# zprof
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

