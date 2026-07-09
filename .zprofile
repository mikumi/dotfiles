# ruby
if [[ `uname` == 'Darwin' ]] ; then
    export GEM_HOME=$HOME/.gem
    export PATH=$GEM_HOME/bin:$PATH
fi

# hombrew
# Intel based macs and Apple Silicon based macs have different homebrew paths
local HOMEBREW_PATH=$(if [ -f "/opt/homebrew/bin/brew" ]; then echo "/opt/homebrew/bin/brew"; else echo "/usr/local/bin/brew"; fi)
if command -v $HOMEBREW_PATH &> /dev/null; then
    eval "$($HOMEBREW_PATH shellenv)"
    export BREW_PREFIX=$(brew --prefix)
    # Add /usr/local/sbin to path for those rare brews
    export PATH="$BREW_PREFIX/sbin:$PATH"
    export HOMEBREW_NO_INSTALL_CLEANUP=1
    export HOMEBREW_NO_AUTO_UPDATE=1
fi

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

export EDITOR="cursor -w"

export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
