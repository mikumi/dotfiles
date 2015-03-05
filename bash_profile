# Colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Java
export JAVA_HOME=$(/usr/libexec/java_home)

# Android Dev
export ANDROID_HOME=~/Development/Libraries/Android/android-sdk-macosx
launchctl setenv ANDROID_HOME $ANDROID_HOME
export ANDROID_NDK_HOME=~/Development/Libraries/Android/android-ndk
launchctl setenv ANDROID_NDK_HOME $ANDROID_NDK_HOME
export PATH=$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH

# Apportable
export PATH=$PATH:~/.apportable/SDK/bin

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

# Marmalade SDK addition: please do not edit these lines
export PATH=$PATH:"/Applications/Marmalade.app/Contents/s3e/bin"
export S3E_DIR=/Applications/Marmalade.app/Contents/s3e
# Marmalade SDK addition: end

# boot2docker
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=/Users/michaelkuck/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1

