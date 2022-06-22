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

eval "$(/opt/homebrew/bin/brew shellenv)"
export BREW_PREFIX=$(brew --prefix)

# Add /usr/local/sbin to path for those rare brews
export PATH="$BREW_PREFIX/sbin:$PATH"
