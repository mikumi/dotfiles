if [[ -n "$CURSOR_AGENT" ]]; then
  # Skip theme initialization for better compatibility
else
  local ANTIGEN_PATH=$(if [ -f "$BREW_PREFIX/share/antigen/antigen.zsh" ]; then echo "$BREW_PREFIX/share/antigen/antigen.zsh"; else echo ~/antigen.zsh; fi)
  source "$ANTIGEN_PATH"
  antigen init ~/.antigenrc
fi

# Standard fzf completion loading
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# Colors
export CLICOLOR=1

# Local bin
export PATH=$PATH:~/bin:~/bin/scripts

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
if command -v kubectl &> /dev/null; then
  source <(kubectl completion zsh)
fi
if command -v doctl &> /dev/null; then
  source  <(doctl completion zsh)
fi

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# FZF Fuzzy matching
export FZF_DEFAULT_OPTS='--height 80% --border'
# autoload -U compinit; compinit # is this needed?
source <(fzf --zsh)

# Cargo / Rust
export PATH="/Users/michael/.cargo/bin:$PATH"

# Aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# AWS CLI
export AWS_PAGER="" # This disables the output pager for aws cli, extremely annoying

# Deno
. "/Users/michael/.deno/env"

# LM Studio CLI
export PATH="$PATH:/Users/michael/.cache/lm-studio/bin"

if [[ -n "$CURSOR_AGENT" ]]; then
  # Skip theme initialization for better compatibility
else
  eval "$(starship init zsh)"
fi


export PATH="$HOME/.local/bin:$PATH"

# Fix alt arrow keys for word navigation
bindkey -e
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[b" backward-word
bindkey "^[f" forward-word

# bun completions
[ -s "/Users/michael/.bun/_bun" ] && source "/Users/michael/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Load secrets
source ~/.secrets.env
