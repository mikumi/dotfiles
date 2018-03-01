source /usr/local/share/antigen/antigen.zsh
antigen init ~/.antigenrc

# Load my custom bash stuff
source ~/.bash_profile

PROMPT='%{$fg[gray]%}%M %{$fg_bold[blue]%}$DOCKER_MACHINE_NAME %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
