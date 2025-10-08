# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt notify
bindkey -e
# End of lines configured by zsh-newuser-install

export EDITOR=vim
alias v="vim"
alias r="source ~/.zshrc"

alias vmod="$EDITOR ~/.vimrc"
alias zmod="$EDITOR ~/.zshrc"
alias bmod="$EDITOR ~/.bashrc"
alias tmod="$EDITOR ~/.tmux.conf"

autoload -Uz vcs_info

# Enable Git info via vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%F{green}(%b)%f'

# Run before every prompt
precmd() {
	vcs_info
}

setopt PROMPT_SUBST

# RGB escape helper (zsh >= 5.7)
rgb() {
	echo "%{\e[38;2;$1;$2;$3m%}"
}

# Virtualenv detection (only basename)
virtualenv_info() {
	[[ -n "$VIRTUAL_ENV" ]] && echo "%F{blue}($(basename "$VIRTUAL_ENV"))%f"
}

# Compose prompt
PROMPT='$(virtualenv_info) %{$(rgb 256 255 0)%}%~%f ${vcs_info_msg_0_} %# '

git_add_branch() {
	local target_repo="$1"
	local source_repo="$2"

	if [[ -z "$target_repo" || -z "$source_repo" ]]; then
		echo "Usage: git_add_branch <target_repo_dir> <source_repo_dir>"
		return 1
	fi

	if [[ ! -d "$target_repo/.git" ]]; then
		echo "Error: Target '$target_repo' is not a Git repo."
		return 2
	fi

	if [[ ! -d "$source_repo/.git" ]]; then
		echo "Error: Source '$source_repo' is not a Git repo."
		return 3
	fi

	local branch_name="${source_repo##*/}"
	local tmp_remote="temp_remote_$branch_name"

	# cd into target repo
	cd "$target_repo" || {
		echo "Failed to cd into $target_repo"
		return 4
	}

	# Add source repo as a remote (relative path)
	git remote add "$tmp_remote" "../$source_repo" 2>/dev/null || {
		echo "Remote $tmp_remote already exists. Removing and retrying."
		git remote remove "$tmp_remote"
		git remote add "$tmp_remote" "../$source_repo" || {
			echo "Failed to add remote $tmp_remote"
			cd - >/dev/null
			return 5
		}
	}

	# Fetch remote
	git fetch "$tmp_remote" || {
		echo "Failed to fetch from $tmp_remote"
		git remote remove "$tmp_remote"
		cd - >/dev/null
		return 6
	}

	# Find default branch of remote
	local default_branch
	default_branch=$(git remote show "$tmp_remote" | awk '/HEAD branch/ {print $NF}')

	# Create branch from fetched remote branch
	git branch "$branch_name" "$tmp_remote/$default_branch" || {
		echo "Failed to create branch $branch_name from $tmp_remote/$default_branch"
		git remote remove "$tmp_remote"
		cd - >/dev/null
		return 7
	}

	echo "Branch '$branch_name' created in '$target_repo' from '$source_repo' ($tmp_remote/$default_branch)."

	# Remove temporary remote
	git remote remove "$tmp_remote"

	# Return to original directory
	cd - >/dev/null
}

git_add_branch_number() {

	count="$1"

	if [[ -z "$count" ]]; then
		echo "Usage: gan <positive_integer>"
		return 1
	fi

	if ! [[ "$count" =~ ^[1-9][0-9]*$ ]]; then
		echo "Error: argument must be an integer greater than 0."
		return 2
	fi

	git_add_branch gotcha_implementation gotcha_implementation_"$count"

}

alias gab="git_add_branch"
alias gan="git_add_branch_number"

export PATH="$HOME/.local/bin:$PATH"

install_locally() {
	tmpdir="$HOME/.local/tmp_rpm_install"
	mkdir -p "$tmpdir" "$HOME/.local/bin"
	cd "$tmpdir" || return 2

	echo "Downloading rpm..."
	for pkg in "$@"; do
		dnf download "$pkg" --downloaddir="$tmpdir" || {
			echo "Failed to download $pkg"
			continue
		}
	done

	echo "Extracting rpms..."
	for rpm in *.rpm; do
		rpm3cpio "$rpm" | cpio -idmv
	done

	echo "Moving binaries to ~/.local/bin"
	move_all_needed=0
	for pkg in "$@"; do
		bin_path="usr/bin/$pkg"
		if [ -f "$bin_path" ]; then
			mv "$bin_path" "$HOME/.local/bin"
		else
			echo "Binary for '$pkg' not found. Contents of $tmpdir:"
			ls -lh "$tmpdir"
			move_all_needed=1
		fi
	done

	if [ $move_all_needed -eq 1 ]; then
		read -n 1 -p "Move all extracted files from $tmpdir to ~/.local/bin? [y/N]: " REPLY
		echo
		[[ $REPLY =~ [Yy]$ ]] && mv usr/bin/* "$HOME/.local/bin" && echo "Binaries moved"
	fi

	read -n 1 -p "Delete temporary directory $tmpdir? [y/N]: " REPLY
	echo
	[[ $REPLY =~ [Yy]$ ]] && rm -rf "$tmpdir" && echo "Temporary files deleted" || echo "Temporary files kept"

	echo "Installation complete"
}

function ranger {
	local IFS=$'\t\n'
	local tmpfile
	tmpfile=$(mktemp)

	# Launch ranger and tell it to write the last dir on quit
	ranger --choosedir="$tmpfile" "$@"

	if [[ -f "$tmpfile" ]] && [[ "$(cat "$tmpfile")" != "$(pwd)" ]]; then
		cd -- "$(cat "$tmpfile")" || return
	fi

	rm -f "$tmpfile"
}

alias lf="ranger"

#install ranger with
