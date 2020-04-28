# Colors
export CLICOLOR=1
# export LSCOLORS=GxFxCxDxBxegedabagaced

# Shared CMD History (only bash)
if [ "$SHELL" = "/bin/bash" ]; then
	export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
	export HISTSIZE=100000                   # big big history
	export HISTFILESIZE=100000               # big big history
	shopt -s histappend                      # append to history, don't overwrite it
	export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"  # Save+reload history after each command
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
