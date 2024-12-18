# Configuration for https://github.com/nvm-sh/nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Make tty value available for GPG agent.
export GPG_TTY=$(tty)

# Render tabs as 4 spaces in less.
export LESS="-x4R"

# Parent directory aliases
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."
alias ..6="cd ../../../../../.."
alias ..-="cd ../;cd -"

alias sayresult="say 'Task complete' || say 'Failure'"
alias vi="nvim"

# Open ripgrep results in Vim
function vrg() {
	vi -q <(rg $@ --vimgrep);
}

# git clone and cd into directory, e.g.
# gccd git@github.com:salcode/salcode-git.git
function gccd() {
	git clone $1;
	cd "$(basename $1 .git)";
}

# Git aliases
alias ga="git add"
alias gb="git branch"
alias gbsc="git branch --show-current"
alias gc="git commit"
alias gca="git commit --amend"
alias gcnv="git commit --no-verify"
alias gcanv="git commit --amend --no-verify"
alias gd="git diff"
alias gd-1="git diff @{-1}"
alias gds="git diff --staged"
alias gdno="git diff --name-only"
alias go="git checkout"
alias gs="git status"
alias gsno="git show --name-only"
alias gw="git switch"
alias gwc="git switch --create"

# Note: if gl does not work, try running the following line and try again.
# git config --global alias.lg "log --oneline --graph"
# More details at https://salferrarello.com/improve-git-log/
alias gl="git lg"

# Read node version from one of the following sources:
# - .node-version file
# - .nvmrc file
# - the '.engines.node' key in package.json
# and run "nvm use" with that node version.
function snode() {
	if ! command -v nvm &> /dev/null
	then
		echo "This command requires nvm"
		echo "See https://github.com/nvm-sh/nvm"
		return 1
	fi

	if [[ -r .node-version ]]
	then
		echo "Setting node version based on .node-version"
		nvm use $(cat .node-version)
		return 0
	fi

	if [[ -r .nvmrc ]]
	then
		echo "Setting node version based on .nvmrc"
		nvm use $(cat .nvmrc)
		return 0
	fi

	if ! command -v jq &> /dev/null
	then
		echo "Unable to find node version in .node-version nor .nvmrc"
		echo "We didn't check package.json for .engines.node because jq is not installed"
		echo "See https://stedolan.github.io/jq/"
		return 1
	fi

	if [[ -r package.json ]]
	then
		node_ver=$(jq -r '.engines.node' package.json)
		if [[ $node_ver != '' ]]
		then
			echo "Setting node version based on package.json .engines.node entry"
			nvm use $node_ver
			return 0
		fi
	fi

	echo "Unable to find node version in .node-version, .nvmrc, nor in package.json under '.engines.node'"
	return 1
}

# Read node version from package.json property .engines.node
# and run "nvm use" with the node version.
# See https://salferrarello.com/jq-nvm-set-node-version/.
function nvmpe() {
	if ! command -v nvm &> /dev/null
	then
		echo "This command requires nvm"
		echo "See https://github.com/nvm-sh/nvm"
		return 1
	fi
	if ! command -v jq &> /dev/null
	then
		echo "This command require jq"
		echo "See https://stedolan.github.io/jq/"
		return 1
	fi

	if [[ ! -r package.json ]]
	then
		echo 'Can not read package.json in this directory'
		return 1
	fi

	node_ver=$(jq -r '.engines.node' package.json)
	if [[ $node_ver -eq '' ]]
	then
		echo "package.json does not contain an .engines.node entry"
		return 1
	fi

	# Set node version.
	nvm use $node_ver
}

# Find the full package name(s) in composer.json
# .require section and copy the name(s)
# into the clipboard
#
# @param string that appears in package name(s)
function jqcfind() {
	jq --raw-output --arg x "$1" \
	'.require | to_entries[] | select(.key | contains($x)) | .key' \
	composer.json | tee >(pbcopy)
}

# jq git composer diff
#
# @param (string) Git branch to use when comparing
#                 the .require section of composer.json
#                 to the current Git branch.
# See https://salferrarello.com/compare-composer-json-on-two-different-git-branches/
function jqgcdiff() {
	diff \
	<(jq --sort-keys '.require' composer.json) \
	<(git show "$1":composer.json | jq --sort-keys '.require')
}

# Remove Newline at End of File.
alias chompeof="perl -pi -e 'chomp if eof'"

# Aliases to copy pwd and cd to clipboard
alias pwdcp="pwd | pbcopy"
function cdp() {
	cd $(pbpaste)
}

# Add alias to source zsh configuration.
alias sourcez="source ~/.zshrc"

alias pu="./vendor/bin/phpunit"

# Autoload zsh add-zsh-hook and vcs_info functions (-U autoload w/o substition, -z use zsh style)
autoload -Uz add-zsh-hook vcs_info
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

# Use brew installed program completions
# See https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
if type brew &>/dev/null
then
	FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
	autoload -Uz compinit
	compinit
fi

# Use Git's tab completion (_git) installed by brew instead of zsh's default
if type brew &>/dev/null && [ -f "$(brew --prefix)/share/zsh/site-functions/_git" ];
then
	_git () {
		builtin autoload -XUz "$(brew --prefix)/share/zsh/site-functions"
	}
fi


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
