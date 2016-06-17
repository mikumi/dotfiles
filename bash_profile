# Colors
export CLICOLOR=1
# export LSCOLORS=GxFxCxDxBxegedabagaced

# Java
export JAVA_HOME=$(/usr/libexec/java_home)

# Android Dev
export ANDROID_HOME=~/Development/Libraries/Android/android-sdk-macosx
if [[ -z "$TMUX" ]]; then
    launchctl setenv ANDROID_HOME $ANDROID_HOME
    launchctl setenv ANDROID_NDK_HOME $ANDROID_NDK_HOME
fi
export ANDROID_NDK_HOME=~/Development/Libraries/Android/android-sdk-macosx/ndk-bundle
export PATH=$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH

# Invisibi Development
export PATH=~/Development/Libraries/depot_tools:$PATH

# EC2
source ~/.ec2cfg

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
eval "$(rbenv init -)"

# ruby
export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$GEM_HOME/ruby/2.0.0/bin:$PATH

