export PATH="/usr/local/bin:$PATH"

# History configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
export PATH="$PATH:$HOME/.local/share/coursier/bin"
export PATH="$PATH:/usr/local/go/bin"
export HOMEBREW_NO_INSTALL_CLEANUP=TRUE
export EDITOR="code --wait"

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

fpath=(/Users/franrubio/.docker/completions $fpath)
autoload -Uz compinit
compinit -u

################### ALIAS ############################

alias ls="ls --color=auto -F"
alias home="z ~/Documents/github/ && z"
alias assume="source /opt/homebrew/bin/assume"
alias gaa="git add -A"
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git add -A && git commit --amend --no-edit"
alias gco="git checkout"
alias gd="git diff"
alias gds="git diff --staged"
alias gs="git status -sb"
alias gf="git fetch --all -p"
alias gps="git push"
alias gpsf="git push --force"
alias gpsft="git push --force --tags"
alias gpl="git pull --rebase --autostash"
alias gsw="git switch"
alias ".."="z .."
alias "..."="z ../.."
alias ll="ls -l"
alias la="ls -la"
alias "~"="z ~"
alias "k"="kill -9"
alias "p"="ps aux | grep"
alias "c."="code ."
alias "o."="open ."
alias icat="kitten icat"
alias s="kitten ssh"
alias d="kitten diff"

################### SOURCE ###########################

source $HOME/.tenv.completion.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# fzf
_fzf_cache="$HOME/.cache/zsh/fzf.zsh"
if [[ ! -f "$_fzf_cache" || "$(command -v fzf)" -nt "$_fzf_cache" ]]; then
  fzf --zsh > "$_fzf_cache"
fi
source "$_fzf_cache"
unset _fzf_cache

################### EVAL #############################

# starship
_starship_cache="$HOME/.cache/zsh/starship.zsh"
if [[ ! -f "$_starship_cache" || "$(command -v starship)" -nt "$_starship_cache" ]]; then
  starship init zsh > "$_starship_cache"
fi
source "$_starship_cache"
unset _starship_cache

# zoxide
_zoxide_cache="$HOME/.cache/zsh/zoxide.zsh"
if [[ ! -f "$_zoxide_cache" || "$(command -v zoxide)" -nt "$_zoxide_cache" ]]; then
  zoxide init zsh > "$_zoxide_cache"
fi
source "$_zoxide_cache"
unset _zoxide_cache

export PATH="$HOME/.local/bin:$PATH"

# Added by Antigravity
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
alias python=python3.13
alias pip="python3.13 -m pip"

# Jira Task Manager alias
jira-ask() {
  opencode --log-level ERROR --agent jira-task-manager run "$@"
}
export PATH="$HOME/bin:$PATH"
export KUBECONFIG=~/.kube/config.k3s-homelab
alias k="kubectl"
export PATH="$HOME/bin:$PATH"

# Scaleway CLI autocomplete initialization.
eval "$(scw autocomplete script shell=zsh)"
