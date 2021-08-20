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
alias gd="git diff"
alias gds="git diff --staged"
alias gdno="git diff --name-only"
alias go="git checkout"
alias gs="git status"
alias gsno="git show --name-only"

# Use custom 'git lg' if it exists, otherwise use default git log.
# See https://salferrarello.com/improve-git-log/
function gl() {
	# Run git lg (git alias) with command line arguments ($@)
	# suppress any output on stderr (2>/dev/null)
	# stop if exit code is zero (||)
	git lg "$@" 2>/dev/null || \
	# if exit code is 141 stop (git log often exits with 141)
	[ $? -eq 141 ] || \
	# the attempt to run git lg did not have exit code 0 nor 141
	# fallback to using git log with arguments ($@)
	git log --oneline --graph "$@"
}

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

# Redeliver a GitHub webhook
#
# Finds the first webhook defined for a repo,
# locates the most recent webhook sent that
# "closed" a "pull_request"
# and redelivers that webhook
#
# @param $1 A GitHub PR URL (e.g. https://github.com/salcode/webhook-testing-abc123/pull/2)
#
function ghredeliver() {
	# Owner and Repo from Pull Request URL.
	# e.g. OWNERREPO="salcode/webhook-testing-abc123"
	OWNERREPO=$(echo $1 | cut -d '/' -f 4-5)

	# Pull Request number from Pull Request URL.
	# e.g. PRNUM="2"
	PRNUM=$(echo $1 | cut -d '/' -f 7)

	# ID of the first webhook defined for this repo.
	# e.g. WEBHOOKID="313740872"
	WEBHOOKID=$(gh api /repos/$OWNERREPO/hooks --jq '.[0] | .id')

	# ID of the last Delivery for the given webhook with:
	#     - action: 'closed'
	#     - event: 'pull_request"
	#     - pull request id matching <the Pull Request Number from the PR URL>
	# e.g. DELIVERYID="4349086192"
	DELIVERYID=$(gh api /repos/$OWNERREPO/hooks/$WEBHOOKID/deliveries --jq \
			'.[] | select(.action == "closed") | select(.event == "pull_request") | .id' \
		| xargs -I % -n1 gh api /repos/$OWNERREPO/hooks/$WEBHOOKID/deliveries/% \
		| jq --slurp "[.[] | select(.request.payload.number == ${PRNUM}) | .id] | .[0]")

	# Redeliver the last Delivery
	echo "gh api --method POST /repos/$OWNERREPO/hooks/$WEBHOOKID/deliveries/$DELIVERYID/attempts"
	echo "END"
}
