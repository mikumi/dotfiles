# Java
if [[ `uname` == 'Darwin' ]] ; then
    # export JAVA_HOME=$(/usr/libexec/java_home)
fi

# Android Dev
if [[ `uname` == 'Darwin' ]] ; then
#    export ANDROID_HOME=~/Development/Libraries/Android/SDK
#    export ANDROID_NDK_HOME=~/Development/Libraries/Android/SDK/ndk-bundle
#    export PATH=$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH
#
#    if [[ -z "$TMUX" ]]; then
#        launchctl setenv ANDROID_HOME $ANDROID_HOME
#        launchctl setenv ANDROID_NDK_HOME $ANDROID_NDK_HOME
#    fi
#
fi

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
fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
if command -v pyenv &> /dev/null; then
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi
