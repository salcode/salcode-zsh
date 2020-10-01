# Configuration for https://github.com/nvm-sh/nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# zplug was installed with 'brew install zplug', which puts it in this location
export ZPLUG_HOME=/usr/local/opt/zplug

# Load zplug
source $ZPLUG_HOME/init.zsh

# Git aliases
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gca="git commit --amend"
alias gcnv="git commit --no-verify"
alias gd="git diff"
alias gds="git diff --staged"
alias gdno="git diff --name-only"
# Use custom 'git lg' if it exists, otherwise use default git log.
# See https://salferrarello.com/improve-git-log/
alias gl="git lg || git log --oneline --graph"
alias go="git checkout"
alias gs="git status"
alias gsno="git show --name-only"
