source /usr/local/share/antigen/antigen.zsh
antigen init ~/.antigenrc

# Load my custom bash stuff
source ~/.bash_profile

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

PROMPT='%{$fg[cyan]%}%c %{$fg_bold[blue]%}% %{$fg_bold[blue]%}$(git_prompt_info) %{$reset_color%}'
RPROMPT='${DOCKER_MACHINE_NAME} [%{$fg[gray]%}%M %{$fg_bold[blue]%}%@]'
