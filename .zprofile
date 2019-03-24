source /usr/local/share/antigen/antigen.zsh
antigen init ~/.antigenrc

# Load my custom bash stuff
source ~/.bash_profile

PROMPT="%{$fg[cyan]%}%c %{$fg_bold[blue]%} % %{$reset_color%}"
RPROMPT="[%{$fg[gray]%}%M %{$fg_bold[blue]%}$DOCKER_MACHINE_NAME %@]"
