# I've used this nice bashrc generator: http://bashrcgenerator.com/
# export PS1="\[\033[38;5;11m\]\u\[$(tput sgr0)\]@\h:\[$(tput sgr0)\]\[\033[38;5;6m\][\w]\[$(tput sgr0)\]:\n\\$ \[$(tput sgr0)\]"

# Then I decided I use this instead: https://www.howtogeek.com/307701/how-to-customize-and-colorize-your-bash-prompt/
GREEN='\[\033[1;32m\]'
WHITE='\[\033[00m\]'
YELLOW='\[\033[38;5;11m\]'
BLUE='\[\033[38;5;6m\]'
PS1='\t '${GREEN}'\u@\h '${YELLOW}'\w'${BLUE}'$(__git_ps1 " (%s)")\n'${WHITE}'\$ '

