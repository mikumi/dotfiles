# Colors
export CLICOLOR=1
# export LSCOLORS=GxFxCxDxBxegedabagaced

# Java
if [[ `uname` == 'Darwin' ]] ; then
    export JAVA_HOME=$(/usr/libexec/java_home)
fi

# Android Dev
if [[ `uname` == 'Darwin' ]] ; then
    export ANDROID_HOME=~/Development/Libraries/Android/SDK
    export ANDROID_NDK_HOME=~/Development/Libraries/Android/SDK/ndk-bundle
    export PATH=$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH

    if [[ -z "$TMUX" ]]; then
        launchctl setenv ANDROID_HOME $ANDROID_HOME
        launchctl setenv ANDROID_NDK_HOME $ANDROID_NDK_HOME
    fi

fi

# AWS
export AWS_DEFAULT_PROFILE=personal

# Shared CMD History (only bash)
if [ "$SHELL" = "/bin/bash" ]; then
	export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
	export HISTSIZE=100000                   # big big history
	export HISTFILESIZE=100000               # big big history
	shopt -s histappend                      # append to history, don't overwrite it
	export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"  # Save+reload history after each command
fi

# Misc
export PATH=$PATH:~/bin

# Aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# ruby
if [[ `uname` == 'Darwin' ]] ; then
    export GEM_HOME=$HOME/.gem
    export PATH=$GEM_HOME/bin:$PATH
fi

# functions

[[ -f ~/.functions ]] && source ~/.functions

# Fastlane
if [[ `uname` == 'Darwin' ]] ; then
    export PATH="$HOME/.fastlane/bin:$PATH"
    source ~/.fastlane/completions/completion.sh
fi

