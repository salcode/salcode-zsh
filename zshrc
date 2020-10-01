# Configuration for https://github.com/nvm-sh/nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# zplug was installed with 'brew install zplug', which puts it in this location
export ZPLUG_HOME=/usr/local/opt/zplug

# Load zplug
source $ZPLUG_HOME/init.zsh
