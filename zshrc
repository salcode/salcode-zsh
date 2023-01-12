# Configuration for https://github.com/nvm-sh/nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Make tty value available for GPG agent.
export GPG_TTY=$(tty)

# Parent directory aliases
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."
alias ..6="cd ../../../../../.."
alias ..-="cd ../;cd -"

alias vi="nvim"

# Git aliases
alias ga="git add"
alias gb="git branch"
alias gbsc="git branch --show-current"
alias gc="git commit"
alias gca="git commit --amend"
alias gcnv="git commit --no-verify"
alias gcanv="git commit --amend --no-verify"
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

# Add this code to .zshrc after nvm initialization code.
#
# Check the current directory for a package.json file
# If the node version is defined (at .engines.node)
# run "nvm use" for the node version.
#
# If there is not a node version defined with package.json,
# run "nvm use default"
# Version: 20230112
#
# See https://salferrarello.com/automatic-switch-node-version-zsh-package-json
autoload -U add-zsh-hook
load-node-version-from-package-json() {
	local package_json_path="$(pwd)/package.json";

	# Check if $package_json_path file exists.
	if [ -f "$package_json_path" ]; then
		local node_version="$(jq -r '.engines.node | select(.!=null)' $package_json_path)"
		if [ "" = "$node_version" ]; then
			echo "package.json has no .engines.node version defined";
		elif [[ $node_version == *"~"* ]] || [[ $node_version == *">"* ]] || [[ $node_version == *"^"* ]]  then
			echo "nvm does not support special characters (^, >, ~)";
			echo "No changes applied, please use nvm to set manually";
			echo "package.json .engines.node is $node_version";
			return 0;
		else
			echo "This directory has a package.json file with .engines.node ($node_version)";
			nvm use $node_version;
			# Record modification of node version.
			export NODE_VERSION_MODIFIED=true;
			return 0;
		fi
	fi

	if $NODE_VERSION_MODIFIED; then
		# Revert to default node version.
		echo "Reverting to default node version.";
		nvm use default;
		export NODE_VERSION_MODIFIED=false;
	fi
}
add-zsh-hook chpwd load-node-version-from-package-json
load-node-version-from-package-json
