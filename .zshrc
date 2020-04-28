source /usr/local/share/antigen/antigen.zsh
antigen init ~/.antigenrc

# Colors
export CLICOLOR=1
# export LSCOLORS=GxFxCxDxBxegedabagaced

# AWS
export AWS_DEFAULT_PROFILE=personal

# Local bin
export PATH=$PATH:~/bin

# Aliases
[[ -f ~/.aliases ]] && source ~/.aliases

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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# If a new command line being added to the history list duplicates an older one,
# the older command is removed from the list (even if it is not the previous
# event).
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
setopt HIST_IGNORE_ALL_DUPS
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
setopt share_history


# Google Cloud SDK
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'

# Configure NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
#[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

source ~/.spaceship
