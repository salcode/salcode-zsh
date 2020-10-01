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

# Add alias to source zsh configuration.
alias sourcez="source ~/.zshrc"

# Autoload zsh vcs_info function (-U autoload w/o substition, -z use zsh style)
autoload -Uz vcs_info
# Enable substitution in prompt.
setopt prompt_subst
# Run vcs_info just before a prompt is displayed (precmd).
add-zsh-hook precmd vcs_info
# Limit vcs_info to ONLY git (e.g. not svn)
zstyle ':vcs_info:*' enable git
# Set vcs_info Git formats: the default output format
# Set vcs_info Git actionformats: the output format used during an action (e.g
#     during a merge, rebase, etc.)
# Substitution values are avaiable on
# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Configuration-1
# %b The current branch name
# %a The current action (e.g. merge, rebase, etc.)
zstyle ':vcs_info:git:*' formats       '(%b)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a)'

# Set Prompt to
# - display final 2 trailing directory names
# - Use '~' instead of '/Users/myuser' when possible
# - The current Git branch name (and Git action if applicable)
# Followed by a trailing $
# e.g. ~/mydir$
# e.g. mydir/my-deeper/$
# e.g. my-deeper/the-deepest (feature/make-better-branch) $
# e.g. my-deeper/the-deepest (feature/make-better-branch|rebase) $
PROMPT='%2~ ${vcs_info_msg_0_}$ '
