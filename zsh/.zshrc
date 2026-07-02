# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
  git
  docker
  docker-compose
  npm
  node
  python
  pip
  golang
  rust
  kubectl
  terraform
  aws
  vscode
  command-not-found
  sudo
  history
  colored-man-pages
  colorize
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# -------------------------
# User configuration
# -------------------------

export PATH="$HOME/.cargo/bin:$PATH"

push() {
  git add .
  git commit -m "${*:-chore:: wip}"
  git push
}

run() { { "$@"; } |& tee >(pbcopy); }

alias n="nr dev"

alias pbcopy='wl-copy'
alias pbpaste='wl-paste'

# -------------------------
# ZLE widgets / keybinds
# -------------------------

autoload -Uz edit-command-line zmv
zle -N edit-command-line
bindkey '^e' edit-command-line

# Keep your other keybinds
bindkey '^k' kill-line

# -------------------------
# Hooks
# -------------------------

# chpwd() {
# ls
# }


# precmd() {
#   echo "precmd"
# }

chpwd() {
  if [[ -f .nvmrc ]]; then
    nvm use
  fi
}



# -------------------------
# FIX: magic-space (must be last)
# -------------------------
# Define AFTER OMZ + autosuggestions load, so it doesn't wrap a missing widget.
# autoload -Uz magic-space
# zle -N magic-space
# bindkey ' ' magic-space


bindkey '^H' backward-kill-word
bindkey '^W' backward-kill-word
bindkey '^U' backward-kill-line
bindkey '^K' kill-line
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^L' clear-screen
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^N' down-line-or-history
bindkey '^P' up-line-or-history
bindkey '^K' kill-line

# npm-dev() {
#   LBUFFER+="nr dev"
# }
# zle -N npm-dev
# bindkey '^[d' npm-dev

npm-dev() {
  LBUFFER+="clear && nr dev"
  zle accept-line
}
zle -N npm-dev
# ESC d
bindkey '^[d' npm-dev
# ALT d (Meta-d)
bindkey '\ed' npm-dev


lazygit_widget() {
  lazygit
  zle reset-prompt
}

# register widget
zle -N lazygit_widget

# bind Alt+g
bindkey '^[g' lazygit_widget



export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias -s ts='$EDITOR'

alias -g NE='2>/dev/null'
alias -g N='&>/dev/null'

alias -g G='| grep'
alias -g H='| head'
alias -g T='| tail'
alias -g L='| less'
alias -g M='| more'
alias -g C='| cat'
alias -g S='| sort'
alias -g U='| uniq'
alias -g X='| xargs'
alias -g F='| find'
alias -g D='| diff'
alias -g M='| man'

# alias -g W='| wc'
# alias -g J='| jq'
# alias -g Y='| yq'
# alias -g Z='| zcat'
# alias -g ZZ='| zstdcat'
# alias -g ZZ='| zstdcat'

alias -g JQ='| jq'
alias -g C='| pbcopy'

bindkey -s '^Xgc' 'push ""\C-b' # C-m

autoload -Uz add-zsh-hook


autoload -Uz zmv
alias zcp='zmv -C'  # Copy with patterns
alias zln='zmv -L'  # Link with patterns


hash -d yt=~/projects/youtube
hash -d dot=~/.dotfiles
hash -d dl=~/Downloads

function clear-screen-and-scrollback() {
  echoti civis >"$TTY"
  printf '%b' '\e[H\e[2J\e[3J' >"$TTY"
  echoti cnorm >"$TTY"
  zle .reset-prompt
}
zle -N clear-screen-and-scrollback
bindkey '^Xl' clear-screen-and-scrollback

function copy-buffer-to-clipboard() {
  echo -n "$BUFFER" | pbcopy
  zle -M "Copied to clipboard"
}
zle -N copy-buffer-to-clipboard
bindkey '^Xc' copy-buffer-to-clipboard


# open current directory in vscode
bindkey -s '^[o' '\C-a\C-k cursor .\n'  # Alt-o: open current directory in vscodeexport PATH=$PATH:/home/nees/go/bin
export PATH=$PATH:$(go env GOPATH)/bin
export PATH="$HOME/.local/bin:$PATH"
eval "$(zoxide init zsh)"
alias cd="z"

. "$HOME/.local/share/../bin/env"
alias t='terraform'
alias t='terraform'
compdef _terraform t

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/nees/.lmstudio/bin"
# End of LM Studio CLI section

