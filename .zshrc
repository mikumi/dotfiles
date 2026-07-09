typeset -U path PATH

if [[ -o interactive && -t 0 && -z "$CURSOR_AGENT" ]]; then
  ANTIGEN_PATH=$(if [ -f "$BREW_PREFIX/share/antigen/antigen.zsh" ]; then echo "$BREW_PREFIX/share/antigen/antigen.zsh"; else echo ~/antigen.zsh; fi)
  source "$ANTIGEN_PATH"
  antigen init ~/.antigenrc
fi

# Standard fzf completion loading
if [[ -o interactive && -t 0 ]]; then
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi


# Colors
export CLICOLOR=1

# Local bin
path=($path "$HOME/bin" "$HOME/bin/scripts")

# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# functions
[[ -f ~/.functions ]] && source ~/.functions


# Local profile
[[ -f ~/.localrc ]] && source ~/.localrc

# ZSH History
# If a new command line being added to the history list duplicates an older one,
# the older command is removed from the list (even if it is not the previous
# event).
export HISTSIZE=500000 # Maximum events in internal history
export SAVEHIST=$HISTSIZE # Maximum events in history file
export HISTFILE=~/.zsh_history # Location of history file
setopt HIST_IGNORE_ALL_DUPS   # Remove older duplicate entries
setopt extended_history       # Save timestamp and duration
setopt hist_expire_dups_first # Remove duplicates first when trimming
setopt hist_ignore_dups       # Don't save duplicate commands
setopt hist_ignore_space      # Don't save commands starting with space
setopt inc_append_history     # Save commands immediately
setopt share_history         # Share history between sessions

# Google Cloud SDK
if command -v gcloud &> /dev/null; then
  export CLOUDSDK_PYTHON=python3
  source "$BREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  source "$BREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
  export USE_GKE_GCLOUD_AUTH_PLUGIN=True
fi

# # Configure NVM / FNM
source ~/bin/scripts/lazynvm.sh
export NVM_DIR="$HOME/.nvm"
eval "$(fnm env --use-on-cd --shell zsh --log-level=error)"
mkdir -p /tmp/fnm-multishells
export FNM_MULTISHELLS_DIR="/tmp/fnm-multishells"

# Load various completions
if [[ -o interactive && -t 0 ]]; then
  if command -v kubectl &> /dev/null; then
    source <(kubectl completion zsh)
  fi
  if command -v doctl &> /dev/null; then
    source  <(doctl completion zsh)
  fi
fi

# FZF Fuzzy matching
export FZF_DEFAULT_OPTS='--height 80% --border'
# autoload -U compinit; compinit # is this needed?
if [[ -o interactive && -t 0 ]] && command -v fzf &> /dev/null; then
  source <(fzf --zsh)
fi

# Cargo / Rust
[[ -d "$HOME/.cargo/bin" ]] && path=("$HOME/.cargo/bin" $path)

# Aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# AWS CLI
export AWS_PAGER="" # This disables the output pager for aws cli, extremely annoying

# LM Studio CLI
export PATH="$PATH:/Users/michael/.cache/lm-studio/bin"

if [[ -o interactive && -t 0 && -z "$CURSOR_AGENT" ]]; then
  eval "$(starship init zsh)"
fi


[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)

# Fix alt arrow keys for word navigation
if [[ -o interactive && -t 0 ]]; then
  bindkey -e
  bindkey "^[[1;3D" backward-word
  bindkey "^[[1;3C" forward-word
  bindkey "^[b" backward-word
  bindkey "^[f" forward-word
fi

# Load secrets
source ~/.secrets.env
