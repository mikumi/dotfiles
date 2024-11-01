local ANTIGEN_PATH=$(if [ -f "$BREW_PREFIX/share/antigen/antigen.zsh" ]; then echo "$BREW_PREFIX/share/antigen/antigen.zsh"; else echo ~/antigen.zsh; fi)
source "$ANTIGEN_PATH"
antigen init ~/.antigenrc

if [[ "$TERM_PROGRAM" != "vscode" ]]; then
  source ~/.powerlevel10k/powerlevel10k.zsh-theme
  # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
  # Initialization code that may require console input (password prompts, [y/n]
  # confirmations, etc.) must go above this block; everything else may go below.
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
fi

# Colors
export CLICOLOR=1

# Local bin
export PATH=$PATH:~/bin

# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# functions
[[ -f ~/.functions ]] && source ~/.functions

# Fastlane
if [[ `uname` == 'Darwin' ]] ; then
    export PATH="$HOME/.fastlane/bin:$PATH"
    source ~/.fastlane/completions/completion.sh
fi

# Local profile
[[ -f ~/.localrc ]] && source ~/.localrc

# ZSH History
# If a new command line being added to the history list duplicates an older one,
# the older command is removed from the list (even if it is not the previous
# event).
export HISTSIZE=500000
export SAVEHIST=$HISTSIZE
export HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
setopt share_history

# Google Cloud SDK
if command -v gcloud &> /dev/null; then
  export CLOUDSDK_PYTHON=python3
  source "$BREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  source "$BREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
  export USE_GKE_GCLOUD_AUTH_PLUGIN=True
fi

# Configure NVM
source ~/bin/lazynvm.sh

if [[ "$TERM_PROGRAM" != "vscode" ]]; then
  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

# Turn off home brew auto updates
export HOMEBREW_NO_AUTO_UPDATE=1

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

# Zoxide
eval "$(zoxide init zsh)"

## fzf-tab
fzf-cd-dir() {
   zi
}
zle -N fzf-cd-dir
bindkey '^e' fzf-cd-dir

zstyle ':fzf-tab:*' fzf-command
zstyle ':fzf-tab:*' popup-min-size 50 8
zstyle ':fzf-tab:*' fzf-min-height 8
zstyle ':fzf-tab:*' fzf-pad 4
# Aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# Github Copilot
eval "$(github-copilot-cli alias -- "$0")"

# AWS CLI
export AWS_PAGER="" # This disables the output pager for aws cli, extremely annoying

if [[ "$TERM_PROGRAM" = "vscode" ]]; then
  autoload -Uz vcs_info
  precmd() { vcs_info }

  zstyle ':vcs_info:git:*' formats '%b '

  setopt PROMPT_SUBST
  PROMPT='%F{green}%*%f %F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '
fi
