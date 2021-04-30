# Configuration for https://github.com/nvm-sh/nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# zplug was installed with 'brew install zplug', which puts it in this location
export ZPLUG_HOME=/usr/local/opt/zplug

# Load zplug
source $ZPLUG_HOME/init.zsh

# Parent directory aliases
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."
alias ..6="cd ../../../../../.."
alias ..-="cd ../;cd -"

# Git aliases
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gca="git commit --amend"
alias gcnv="git commit --no-verify"
alias gcanv="git commit --amend --no-verify"
alias gd="git diff"
alias gds="git diff --staged"
alias gdno="git diff --name-only"
# See https://salferrarello.com/improve-git-log/
alias gl="git lg"
alias go="git checkout"
alias gs="git status"
alias gsno="git show --name-only"

# Add alias to source zsh configuration.
alias sourcez="source ~/.zshrc"

alias pu="./vendor/bin/phpunit"

# Autoload zsh vcs_info function (-U autoload w/o substition, -z use zsh style)
autoload -Uz vcs_info
# Enable substitution in prompt.
setopt prompt_subst
# Run vcs_info just before a prompt is displayed (precmd).
add-zsh-hook precmd vcs_info
# Limit vcs_info to ONLY git (e.g. not svn)
zstyle ':vcs_info:*' enable git
# Enable checking for (un)staged changes, enabling use of %u and %c
zstyle ':vcs_info:*' check-for-changes true
# Set custom strings for an unstaged vcs repo changes (*) and staged changes (+)
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'

# Set vcs_info Git formats: the default output format
# Set vcs_info Git actionformats: the output format used during an action (e.g
#     during a merge, rebase, etc.)
# Substitution values are avaiable on
# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Configuration-1
# %b The current branch name
# %a The current action (e.g. merge, rebase, etc.)
# %u Display the unstagedstr string if there are unstaged changes
# %c Display the stagedstr string if there are staged changes
zstyle ':vcs_info:git:*' formats       '(%b%u%c)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'

# Set Prompt to
# - display final 2 trailing directory names
# - Use '~' instead of '/Users/myuser' when possible
# - The current Git branch name (and Git action if applicable)
# Followed by a trailing $
# e.g. ~/mydir$
# e.g. mydir/my-deeper/$
# e.g. my-deeper/the-deepest (feature/make-better-branch) $
# e.g. my-deeper/the-deepest (feature/make-better-branch *) $
# e.g. my-deeper/the-deepest (feature/make-better-branch +) $
# e.g. my-deeper/the-deepest (feature/make-better-branch|rebase) $
PROMPT='%F{69}%2~%f %F{1}${vcs_info_msg_0_}%f$ '

# Enable fzf **<tab> completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Customize fzf **<tab> completion for 'go' (git alias) to list branches.
_fzf_complete_go() {
	_fzf_complete --reverse --multi -- "$@" < <(
		git branch --format='%(refname:short)'
	)
}
# Customize fzf **<tab> completion for certain git commands to list branches.
# Modifies completion for 'git switch' and 'git checkout.
_fzf_complete_git() {
    if [[ "$@" == 'git switch '* || "$@" == 'git checkout '* ]]
	then
		_fzf_complete --reverse --multi -- "$@" < <(
			git branch --format='%(refname:short)'
		)
	else
		# Use default fzf completion.
        eval "zle ${fzf_default_completion:-expand-or-complete}"
	fi
}
