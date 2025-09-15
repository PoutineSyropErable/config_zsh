exec_once_file="$HOME/.zprofile"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


export AF_OPENCL_DEFAULT_DEVICE=1
export PYOPENCL_CTX="0:1"
export HCC_AMDGPU_TARGET=gfx1031  # Critical for RDNA 2 GPUs
export CUPY_INSTALL_USE_HIP=1
export ROCM_HOME=/opt/rocm  # Ensure ROCm path is set


# ROCm (HIP/AMD toolchain)
[[ -n "$ROCM_HOME" && -d "$ROCM_HOME/bin" && ":$PATH:" != *":$ROCM_HOME/bin:"* ]] && PATH="$ROCM_HOME/bin:$PATH"
export PATH # Ensure hipcc is in PAT
# export PATH=$ROCM_HOME/bin:$PATH   # equivalent

# echo "missing to add local paths (and not just repo path for git filter_remove), though adding it might be a bad idea. Sleep on it and"
# echo "implement it later."

# ─────────────────────────────────────────────────────
# 🛠️ 1️⃣ Zsh & Environment Configuration
# ─────────────────────────────────────────────────────

# Oh My Zsh Path
export ZSH="$HOME/.oh-my-zsh"

# Set Theme
# ZSH_THEME="fletcherm"
ZSH_THEME="powerlevel10k/powerlevel10k"


# Plugins
plugins=(
	# virtualenvwrapper
    zsh-syntax-highlighting
	zsh-autosuggestions
)

    # git

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Terminal & Editor Settings
export TERMINAL=kitty
export EDITOR=nvim


# Determine the flag based on the editor
if [[ "$EDITOR" == "nvim" ]]; then
    EDITOR_FLAG="--cmd \"autocmd VimEnter * CdHere\""  # Only for nvim
else
    EDITOR_FLAG=""  # No flag for other editors
fi


openrc() {
    local file=$1
    if [[ "$EDITOR" == "nvim" ]]; then
        "$EDITOR" --cmd 'autocmd VimEnter * CdHere' "$file"
    else
        "$EDITOR" "$file"
    fi
}

# Determine the flag based on the editor
if [[ "$EDITOR" == "nvim" ]]; then
    EDITOR_FLAG="--cmd \"autocmd VimEnter * CdHere\""  # Only for nvim
else
    EDITOR_FLAG=""  # No flag for other editors
fi



alias v="nvim"
alias vr="nvim -c 'set readonly'"
alias vim="nvim"
alias ovim="/usr/bin/vim"
alias pvim="nvim --startuptime ~/.config/nvim_logs/startup.log"


bindkey -s '^F' 'lf\n'
bindkey -r '^L'
bindkey '^G' clear-screen




alias slf="sudo -E lf"
alias svim="sudo -E nvim"
# fuck nano!
alias nano="nvim"
sudo() {
    if [[ $# -gt 0 && "$1" == "nano" ]]; then
        command sudo -E nvim "${@:2}"
    else
        command sudo "$@"
    fi
}






# ─────────────────────────────────────────────────────
# 🛠️  Initialize CLI Tools (With Warnings)
# ─────────────────────────────────────────────────────

# Initialize thefuck, when you make an error in terminal, type fuck and it will give you the correction
if ! eval "$(thefuck --alias)"; then
    echo "⚠️ Warning: Failed to initialize 'thefuck'"
fi

# Initialize zoxide. You don't need perfect path for cd. You can cd "bunch of keywords" and it will find the dir 
if ! eval "$(zoxide init zsh)"; then
    echo "⚠️ Warning: Failed to initialize 'zoxide'"
fi

# Initialize atuin. Makes the command history good and not suck. Control R works.
# I disabled up arrows but you can change that
if ! eval "$(atuin init zsh --disable-up-arrow)"; then
    echo "⚠️ Warning: Failed to initialize 'atuin'"
fi

# Allow q for cd and quit
# Source LF Configuration (With Error Handling)
if [[ -f ~/.config/lf/lf.zsh ]]; then
    if ! source ~/.config/lf/lf.zsh; then
        echo "⚠️ Warning: Failed to source ~/.config/lf/lf.zsh"
    fi
else
    echo "⚠️ Warning: LF config file not found: ~/.config/lf/lf.zsh"
	echo "Try doing the ./install_lf"
fi


# ─────────────────────────────────────────────────────
# 🌐 2️⃣ Universal Clipboard Configuration
# ─────────────────────────────────────────────────────

# Detect Display Server (Wayland, X11, macOS)
if [[ -z "$XDG_SESSION_TYPE" ]]; then
    if [[ -n "$WAYLAND_DISPLAY" ]]; then
        DISPLAY_SERVER="wayland"
    elif [[ -n "$DISPLAY" ]]; then
        DISPLAY_SERVER="x11"
    else
        DISPLAY_SERVER="unknown"
    fi
else
    DISPLAY_SERVER="$XDG_SESSION_TYPE"
fi

# Clipboard Aliases (Wayland, X11, macOS)
if [[ "$DISPLAY_SERVER" == "wayland" ]]; then
    alias c="wl-copy"
    alias paste="wl-paste --type text/plain"
    alias p="wl-paste --type text/plain"
elif [[ "$DISPLAY_SERVER" == "x11" ]]; then
    alias c="xclip -selection clipboard"
    alias paste="xclip -selection clipboard -o"
    alias p="xclip -selection clipboard -o"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    alias c="pbcopy"
    alias paste="pbpaste"
    alias p="pbpaste"
else
    echo "Warning: Unknown display server or unsupported OS!"
fi

# Copy image to clipboard (Wayland/X11)
img2clip() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: img2clip <image-path>"
    return 1
  fi

  local IMAGE_PATH="$1"

  # Check if file exists
  if [[ ! -f "$IMAGE_PATH" ]]; then
    echo "Error: File '$IMAGE_PATH' not found."
    return 1
  fi

  # Detect MIME type
  local MIME_TYPE=$(file --mime-type -b "$IMAGE_PATH" 2>/dev/null)

  # Verify it's an image
  if [[ ! "$MIME_TYPE" =~ ^image/ ]]; then
    echo "Error: '$IMAGE_PATH' is not an image (MIME: ${MIME_TYPE:-unknown})."
    return 1
  fi

  # Try wl-copy (Wayland) first, fall back to xclip (X11)
  if command -v wl-copy &>/dev/null; then
    wl-copy < "$IMAGE_PATH" && echo "✅ Image copied to clipboard (Wayland)."
  elif command -v xclip &>/dev/null; then
    xclip -selection clipboard -t "$MIME_TYPE" < "$IMAGE_PATH" && echo "✅ Image copied to clipboard (X11)."
  else
    echo "Error: Install 'wl-clipboard' (Wayland) or 'xclip' (X11)."
    return 1
  fi
}



hyprland_switch() {
	fish -c "kmux"
	# tmux kill-server
	tmux setenv -g HYPRLAND_INSTANCE_SIGNATURE "$HYPRLAND_INSTANCE_SIGNATURE"
}



# ─────────────────────────────────────────────────────
# 🚀 3️⃣ Python Virtual Environments
# ─────────────────────────────────────────────────────

# Define the base directory for Python virtual environments (from pip)
PYTHON_VENV_DIR="$HOME/.pip_venvs/"


pip_create() {
    if [[ -z "$1" ]]; then
        echo "❌ Usage: pip_create <venv_name> <version>"
        return 1
    fi
	mkdir -p "$PYTHON_VENV_DIR"
    VENV_PATH="$PYTHON_VENV_DIR/$1"

    if [[ -d "$VENV_PATH" ]]; then
        echo "⚠️ Virtual environment '$1' already exists at $VENV_PATH"
    else
        python -m venv "$VENV_PATH"
        echo "✅ Virtual environment '$1' created at $VENV_PATH"
    fi
}

pip_create_version() {
  if [[ -z "$1" ]]; then
        echo "❌ Usage: pip_create <venv_name> [python_version]"
        return 1
    fi

    local venv_name="$1"
	# pass stuff like 3.12 , 3.12.11
    local requested_version="${2:-system}"  # Default to system Python

    mkdir -p "$PYTHON_VENV_DIR"
    local VENV_PATH="$PYTHON_VENV_DIR/$venv_name"

    if [[ -d "$VENV_PATH" ]]; then
        echo "⚠️ Virtual environment '$venv_name' already exists at $VENV_PATH"
        return 0
    fi

    if [[ "$requested_version" == "system" ]]; then
        python_exe="python"
    else
        # Check if pyenv is installed
        if ! command -v pyenv >/dev/null 2>&1; then
            echo "❌ pyenv is not installed or not in PATH."
            return 1
        fi

        # Find all installed versions matching the requested prefix
        local installed_versions
        installed_versions=$(pyenv versions --bare | grep "^${requested_version}")

        if [[ -z "$installed_versions" ]]; then
            echo "🐍 No installed Python versions matching '$requested_version' found. Installing latest available..."

            # Find latest installable version from pyenv install --list
            local latest_version
            latest_version=$(pyenv install --list | sed 's/^[[:space:]]*//' | grep "^${requested_version}" | tail -1)

            if [[ -z "$latest_version" ]]; then
                echo "❌ Could not find any Python versions starting with '$requested_version' to install."
                return 1
            fi

            echo "🐍 Installing Python $latest_version via pyenv..."
            pyenv install "$latest_version" || { echo "❌ Failed to install Python $latest_version"; return 1; }
            python_exe="$(pyenv root)/versions/$latest_version/bin/python"
        else
            # Use the latest installed patch version from the installed versions list
            local latest_installed_version
            latest_installed_version=$(echo "$installed_versions" | sort -V | tail -1)

            read -rp "🐍 Python version '$latest_installed_version' matching '$requested_version' is already installed. Continue using it? [Y/n] " confirm
            confirm=${confirm:-Y}
            if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
                echo "❎ Aborting virtualenv creation."
                return 1
            fi

            python_exe="$(pyenv root)/versions/$latest_installed_version/bin/python"
        fi

        # Check if python_exe exists and is executable
        if [[ ! -x "$python_exe" ]]; then
            echo "❌ Python executable not found at $python_exe"
            return 1
        fi
    fi

    echo "🛠 Creating virtual environment '$venv_name' with Python executable: $python_exe ..."
    "$python_exe" -m venv "$VENV_PATH" || { echo "❌ Failed to create virtualenv"; return 1; }

    echo "✅ Virtual environment '$venv_name' created at $VENV_PATH"
}



pip_activate() {
    if [[ -z "$1" ]]; then
        echo "❌ Usage: pip_activate <venv_name>"
        return 1
    fi
    VENV_PATH="$PYTHON_VENV_DIR/$1"
    if [[ -d "$VENV_PATH" ]]; then
        source "$VENV_PATH/bin/activate"
        echo "✅ Activated virtual environment: $1"
    else
        echo "❌ Virtual environment '$1' does not exist in $PYTHON_VENV_DIR"
    fi
}

pip_delete() {
    if [[ -z "$1" ]]; then
        echo "❌ Usage: pip_delete <venv_name>"
        return 1
    fi

    local VENV_PATH="${PYTHON_VENV_DIR%/}/$1"

    # Safety checks
    if [[ ! -d "$VENV_PATH" ]]; then
        echo "❌ Virtual environment '$1' does not exist in $PYTHON_VENV_DIR"
        return 2
    fi

    case "$VENV_PATH" in
        "$HOME"/*) ;;  # ok
        *)
            echo "❌ Refusing to delete outside HOME directory: $VENV_PATH"
            return 3
            ;;
    esac

	local relpath="${VENV_PATH#"$HOME"/}"

    # Count slashes in relpath separately to avoid masking return values
    local count_slashes
    count_slashes=$(echo "$relpath" | awk -F/ '{print NF}')

    if (( count_slashes < 2 )); then
        echo "❌ Directory depth too shallow to delete safely: $VENV_PATH"
        echo "   Expected something like $HOME/some_folder/venv_name"
        return 4
    fi

    # Prompt for confirmation - read with -r to avoid backslash mangling
	echo -n "⚠️ Are you sure you want to delete the virtual environment '$1' at ($VENV_PATH)? [y/N] "
    read -r confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm -rf -- "$VENV_PATH"
        echo "🗑️ Deleted virtual environment: $1"
    else
        echo "❎ Deletion cancelled."
    fi
}


# Use a venv's Python without activating it
alias pythonvenv="$PYTHON_VENV_DIR/pip_venv/bin/python"
alias pv="pythonvenv"

# Activate common virtual environments
alias govenv="pip_activate pip_venv"
alias projvenv="pip_activate project_venv"

# Deactivate the current virtual environment
alias lvenv="deactivate"




conda_activate() {
    local conda_path="$HOME/miniconda3/bin/conda"
    
    if [[ -x "$conda_path" ]]; then
		eval "$("$conda_path" "shell.zsh" "hook")" # activate conda (base)
    else
        echo "❌ Error: Conda not found at $conda_path"
    fi
}


conda_master() {
    local conda_path="$HOME/miniconda3/bin/conda"
    
    if [[ -x "$conda_path" ]]; then
		eval "$("$conda_path" "shell.zsh" "hook")" # activate conda (base)
		conda activate master_venv # activate conda (master_venv)
    else
        echo "❌ Error: Conda not found at $conda_path"
    fi
}

conda_create() {
	conda_activate
	conda create --name "$1" python=3.12 numpy debugpy GitPython pillow pygame pytest requests tk virtualenvwrapper websocket-client yt-dlp

	# conda install
}
alias conda_dump="conda env export > environment.yml"
alias conda_load="conda env create -f environment.yml"

alias pip_dump="pip freeze > requirements.txt"
alias pip_load="pip install -r requirements.txt"


# possibly, you can just straight up do: "conda activate master_venv"
# but that's only gonna happen if conda_path was exported to path
# And that might fuck up some system wide install, because it tries to use that version of python
# rather then your system wide python, which is what should be used for system updates and operation

# Keeping the bellow commented out. With it commented out, conda activate master_venv won't work. because 
# conda is unknown command. With it not commented out, it will work. But see warning paragraph above
# export PATH="$HOME/miniconda3/bin/conda:$PATH"





#---------------------------------------------------------------------------------------------
# A premade wrapper: 
# These don't work with conda so they are kinda useless for you... But it does make some python stuff
# Easier I guess if you want to use that rather then my venvs example alias
# Like in further project where you'd rather use pip packages then conda packages

if false; then
	export WORKON_HOME=$HOME/.virtualenvs
	export VIRTUALENVWRAPPER_PYTHON=$(which python3)
	export VIRTUALENVWRAPPER_VIRTUALENV=$(which virtualenv)
	source $(which virtualenvwrapper.sh)
fi

# Command				What It Does
# mkvirtualenv myenv	Create a virtual environment named myenv
# workon myenv			Activate the myenv environment
# deactivate			Exit the active virtual environment
# rmvirtualenv myenv	Delete myenv
# lsvirtualenv			List all virtual environments
# cdvirtualenv			Go to the active virtual environment's directory
# cdsitepackages		Navigate to the site-packages directory


# ─────────────────────────────────────────────────────
# 📁 4️⃣ Navigation & Directory Shortcuts
# ─────────────────────────────────────────────────────

# This requires z oxide. It's a much better cd (see source comment at top of file)
alias cd="z"  # better cd
alias ls="lsd" # better ls
alias ols="/usr/bin/ls"


alias eva="eza" # another colored version of ls
alias ll='lsd -al'
alias la='lsd -a'
alias lsdir='lsd -d */'
alias lsa="lsd -a"

alias ch='cd ~' # just doing "cd" will work by itself but idc
alias cco="cd ~/.config"
alias cala="cd ~/.config/alacritty/"
alias ce="cd ~/.config/eww"
alias cfi="cd ~/.config/fish"
alias cH="cd ~/.config/hypr"
alias ci3="cd ~/.config/i3"
alias cir="cd ~/.config/ironbar"
alias cka="cd ~/.config/kanata"
alias cki="cd ~/.config/kitty"
alias clf="cd ~/.config/lf"
alias cP="cd ~/.config/polybar.old/"
alias cr="cd ~/.config/rofi"
alias crm="cd ~/.config/rmpc"
alias ctm="cd ~/.config/tmux"
alias cuw="cd ~/.config/uwsm"
alias cw="cd ~/.config/waybar"
alias cz="cd ~/.config/zsh"
alias cza="cd ~/.config/zathura/"


alias cdo="cd ~/Downloads"
alias cdoc="cd ~/Documents"
alias cm="cd ~/Music"
alias cpi="cd ~/Pictures"
alias cv="cd ~/Videos"


alias chg="cd ~/home_for_git"
alias ct="cd ~/.local/share/Trash/files"
alias cs9="cd ~ ; cd sem9"
alias cs1="cd ~/Documents/University (Real)/Semester 10/"
alias cs10="cs1"

# ─────────────────────────────────────────────────────
#   5️⃣  Config  Files Modification
# ─────────────────────────────────────────────────────

alias amod="$EDITOR $EDITOR_FLAG ~/.config/awesome/rc.lua"
alias bmod="openrc ~/.bashrc"
alias cmod="$EDITOR $EDITOR_FLAG ~/.config/conky/show_all/show_all_conf"
alias fmod="$EDITOR $EDITOR_FLAG ~/.config/fish/config.fish"
alias hmod="$EDITOR $EDITOR_FLAG ~/.config/hypr/hyprland.conf"
alias imod="$EDITOR $EDITOR_FLAG $HOME/.config/i3/config"
alias irmod="$EDITOR $EDITOR_FLAG ~/.config/ironbar/"
alias kamod="$EDITOR $EDITOR_FLAG ~/.config/kanata/kanata.kbd"
alias kimod="$EDITOR $EDITOR_FLAG ~/.config/kitty/kitty.conf"
alias keymod="cd ~/.config/nvim && $EDITOR lua/core/keymaps.lua"
alias lmod="$EDITOR $EDITOR_FLAG ~/.config/lf/lfrc"
alias mmod="$EDITOR $EDITOR_FLAG ~/.config/mpd/mpd.conf"
alias ncmod="$EDITOR $EDITOR_FLAG ~/.ncmpcpp/config"
alias nmod="$EDITOR $EDITOR_FLAG ~/.config/nvim"
alias pmod="$EDITOR $EDITOR_FLAG ~/.config/polybar.old/config"
alias smod="$EDITOR $EDITOR_FLAG ~/.config/sway/config"
alias tmod="$EDITOR $EDITOR_FLAG ~/.tmux.conf"
alias vmod="$EDITOR $EDITOR_FLAG ~/.config/vim/.vimrc"
alias wmod="$EDITOR $EDITOR_FLAG ~/.config/waybar/"
alias zmod="$EDITOR $EDITOR_FLAG ~/.zshrc"
alias zmod1="$EDITOR $EDITOR_FLAG ~/.zshrc1"

alias fview="bat ~/.fishrc"
alias tview="bat ~/.tmuxrc"
alias zview="bless ~/.zshrc"


# ─────────────────────────────────────────────────────
# 🔀 6️⃣ TMUX Configuration
# ─────────────────────────────────────────────────────

alias kmux="tmux kill-server"
alias lmux="tmux detach"
alias dmux="tmux detach"
alias qmux="tmux kill-session"
alias kpane="tmux kill-pane"
alias rmux="tmux source-file ~/.tmux.conf"
alias umux="tmux source-file ~/.tmux.conf"
alias jj="tmux select-pane -L"
alias jk="tmux select-pane -D"
alias jl="tmux select-pane -R"
alias ji="tmux select-pane -U"

# Swap TMUX Panes
tswap() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: tswap pane1 pane2"
        return 1
    fi
    local pane1="$1"
    local pane2="$2"
    tmux swap-pane -s "$pane1" -t "$pane2"
}


tret() {
	# reattach to a lost session i might have accidentally closed by doing a window kill
	local session_name="$1"
	tmux attach -t "$session_name"
}

# ─────────────────────────────────────────────────────
# 🔎 7️⃣ File Search & Clipboard Commands
# ─────────────────────────────────────────────────────

# Search a file with fzf, see its preview, and open it in 
# neovim to edit it
fzfv() {
    $EDITOR "$(fzf -m --preview='bat --color=always {} .')"

}

alias fv="fzfv"

# search for files with fzf with image preview and paste it to clipboard
fzfi() {
    fzf -m --preview='feh {}' | c
}

fzfc() {
    fzf -m --preview='bat --color=always {}' | c
}

# copy a file text content to clipboard
fcc() {
    cat "$@" | c
}


# Find files with a name containing the given argument (case-insensitive)
# This is dumb compared to the others but hey... 
# it could have a use
findc() {
    find . -iname "*$1*"
}


# mix rg with fzf
fuzzy_find_content() {
    local max_depth=${1:-3}
    local query result

    query=$(rg --max-depth "$max_depth" --no-heading --column --line-number . 2>/dev/null | \
        fzf --ansi --preview 'file=$(echo {} | cut -d: -f1); \
                              line=$(echo {} | cut -d: -f2); \
                              bat --color=always --highlight-line $line --line-range $((line-5)):$((line+5)) "$file"')

    [[ -z "$query" ]] && return

    result=$(echo "$query" | awk -F: '{print $1 ":" $2}')

    [[ -n "$result" ]] && ${EDITOR:-nvim} "+$(echo "$result" | cut -d: -f2)" "$(echo "$result" | cut -d: -f1)"
}



alias rgfzf="fuzzy_find_content"
alias fzfrg="fuzzy_find_content"

# ─────────────────────────────────────────────────────
# 📂 8️⃣ Advanced Directory Search
# ─────────────────────────────────────────────────────

# Find directories without depth restriction
fcd() {
    local search_term="$1"
    local dir
    dir=$(fd -t d --hidden "$search_term" | fzf)
    [[ -n "$dir" ]] && cd "$dir"
}

# Find directories with max depth = 1
fcd1() {
    local search_term="$1"
    local dir
    dir=$(fd -t d --hidden -d 1 "$search_term" | fzf)
    [[ -n "$dir" ]] && cd "$dir"
}

# Find directories with specified depth
fcdn() {
    if [[ -z "$1" ]]; then
        echo "Usage: fcdn <max-depth> [wildcard]"
        return 1
    fi
    local depth="$1"
    local search_term="${2:-}"
    local dir
    dir=$(fd -t d --hidden -d "$depth" "$search_term" | fzf)
    [[ -n "$dir" ]] && cd "$dir"
}




function cdf() {
	if [[ $# -eq 0 ]]; then
		echo "Usage: cdf <filepath>"
		return 1
	fi

	local target_dir
	target_dir=$(dirname -- "$1")

	if [[ ! -d "$target_dir" ]]; then
		echo "Directory does not exist: $target_dir" >&2
		return 2
	fi

	cd -- "$target_dir" || return 3
	echo "Changed to: $target_dir"

} 

function cf() {
	local file_path
	file_path=$(fd . --type f --hidden --follow --exclude .git . | fzf --preview='bat --color=always {} .')
	if [[ -n "$file_path" ]]; then
		abs_path="$(realpath "$file_path")"      # convert to absolute path
		cd "$(dirname "$abs_path")"              # cd to directory of absolute path
		nvim "$abs_path"
	fi
}


alias ff="$HOME/.local/bin/fzf_filemanager"

function symcd() {
  cd "$(dirname "$(readlink -f "$1")")"
}

alias cdsym="symcd"

# ─────────────────────────────────────────────────────
# 🛠️ 9️⃣ Git Functions & Aliases
# ─────────────────────────────────────────────────────

# Ensure no alias conflict before defining functions
unalias gc 2>/dev/null
unalias ga 2>/dev/null
unalias gcm 2>/dev/null

alias find_git_submodules="find . -type d -name '.git'"

# Commit with a message
gc() {
    git commit -m "$1"
}

# Add, commit, and push with a message
git_do_all() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: git_do_all <commit_message>"
        return 1
    fi
    local commit_msg="$1"
    git add .
    git commit -m "$commit_msg"
    git push origin "$(git branch --show-current)"
}

# Commit & push all submodules and main repo
git_push_all_msg() {
    if [[ $# -eq 0 ]]; then
        echo "Error: Commit message is required."
        return 1
    fi
    local commit_message="$1"

    echo "🔄 Processing all submodules..."
    echo "________________________________"

    git submodule foreach --recursive '
        echo "Updating submodule $name..."
        git add --all
        git commit -m "'"$commit_message"'" || echo "No changes to commit"
        git push origin $(git branch --show-current)
        echo "________________________________"
    '

	echo ""
    echo "________________________________"
    echo "🚀 Processing the main repository..."
    git add --all
    git commit -m "$commit_message" || echo "No changes to commit in root repository"
    git push --recurse-submodules=on-demand origin "$(git branch --show-current)"
}

# Push all with a hardcoded commit message
git_push_all() {
    git_push_all_msg "super push, root git dir and all submodules"
}


git_pull_all() {
    # Print processing message
    printf "Processing all submodules...\n"
    printf "________________________________\n\n"

    # Iterate over submodules and pull updates
    git submodule foreach --recursive '
        echo "Updating submodule $name..."
        git pull origin $(git branch --show-current)
        printf "________________________________\n\n"
    '
}

function git_pull_remote_branch() {
  local branch="$1"

  if [[ -z "$branch" ]]; then
    echo "Usage: git-pull-remote-branch <branch-name>"
    return 1
  fi

  # Fetch all branches from origin
  git fetch origin

  # Check if the branch exists remotely
  if git ls-remote --exit-code --heads origin "$branch" &>/dev/null; then
    # Create a local branch tracking the remote branch
    git checkout -b "$branch" "origin/$branch"
  else
    echo "Branch '$branch' does not exist on origin."
    return 1
  fi
}

git_diff_report() {
  local good="$1"
  local bad="$2"
  local out_file="lazydev_lua_attach_issue.diff"

  if [[ -z "$good" || -z "$bad" ]]; then
    echo "Usage: git_diff_report <good_commit> <bad_commit>"
    return 1
  fi

  git diff "$good" "$bad" > "$out_file"
  echo "Diff saved to $out_file"
}

function dirdiff() {
  # Usage: dirdiff [options] dir1 dir2
  local color_diff format side_by_side suppress_common show_counts
  zparseopts -D -E \
    c=color_diff -color=color_diff \
    y=side_by_side -side-by-side=side_by_side \
    u=suppress_common -unique=suppress_common \
    n=show_counts -count=show_counts

  if [[ $# -ne 2 ]]; then
    echo "Usage: dirdiff [options] dir1 dir2"
    echo "Options:"
    echo "  -c, --color      Colored output"
    echo "  -y, --side-by-side Parallel comparison"
    echo "  -u, --unique     Only show unique files"
    echo "  -n, --count      Show counts of unique files"
    return 1
  fi

  local dir1=${1:a} dir2=${2:a}  # Convert to absolute paths
  local ls_opts=(-1U)  # -1: one per line, -U: don't sort

  # Build diff command
  local cmd=(diff)
  [[ -n $side_by_side ]] && cmd+=(-y)
  [[ -n $suppress_common ]] && cmd+=(--suppress-common-lines)
  [[ -n $color_diff ]] && cmd=(colordiff "${cmd[@]}")

  # Execute comparison
  if [[ -n $show_counts ]]; then
    echo "\n=== Unique files ==="
    echo "Only in ${dir1:t}: $(comm -23 <(ls $ls_opts $dir1 | sort) <(ls $ls_opts $dir2 | sort) | wc -l)"
    echo "Only in ${dir2:t}: $(comm -13 <(ls $ls_opts $dir1 | sort) <(ls $ls_opts $dir2 | sort) | wc -l)"
  else
    $cmd <(ls $ls_opts $dir1 | sort) <(ls $ls_opts $dir2 | sort)
  fi
}



# ─────────────────────────────────────────────────────
# ⚡ Git Aliases for Quick Commands
# ─────────────────────────────────────────────────────


git4() {
	# activate git diff view
	git config --global merge.tool nvimdiff
	git config --global mergetool.nvimdiff.cmd 'nvim -d $LOCAL $BASE $REMOTE $MERGED -c "wincmd l" -c "wincmd l"'
	git config --global mergetool.prompt false
	git config --global mergetool.keepBackup false
}

gitv() {
	## Activate git conflict
	git config --global merge.tool nvimconflict
	git config --global mergetool.nvimconflict.cmd 'nvim "$MERGED"'
	git config --global mergetool.prompt false

}

gitm() {
	# Configure Meld as the Git mergetool
	git config --global merge.tool meld
	git config --global mergetool.meld.cmd 'meld "$LOCAL" "$BASE" "$REMOTE" --output="$MERGED"'
	git config --global mergetool.prompt false
	git config --global mergetool.keepBackup false
}

alias ga="git add --all"
alias gcm="gc"
alias gdf="git diff --name-only"

alias gpd="git push origin desktop"
alias gpl="git push origin laptop"
alias gpm="git push origin \$(git branch --show-current)"
alias gpu="git pull origin \$(git branch --show-current)"
alias gpr="git pull --rebase origin \$(git branch --show-current)"
alias gpmn="git push origin main"


alias gpf="git push -u myfork teleport_projectile_images"
alias gpfu="git pull myfork teleport_projectile_images"          # just pull from that remote/branch

alias gpam="git_push_all_msg"
alias gpa="git_push_all"

alias gda="git_do_all"

alias gas="git ls-files --others --modified --exclude-standard -z | xargs -0 du -h --apparent-size 2>/dev/null | sort -rh | bless"

##### THE FOLLOWING TWO FUNCTION, git_clone_nonlocal, and git_filter_remove are for securely rewritting the commit history to 
# remove a file from ever having been inside of it. Useful if you accidentally push your api key like a dumbass, or git add and commit 
# a huge file by doing git add ., and now it's been 10 commits and 10 hours of works, and so unless you want to go back on all that work, 
# you have to filter repo the project and remove it from history, this is to have a safe way to do it. And since you can't push due to the big file
#... then you also need to make a local clones, but it must not use hardlinks. 



git_clone_nonlocal() {
    # Ensure we are inside a Git repository
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo "Error: Not inside a Git repository."
        return 1
    fi

    # Get the absolute path of the Git repository root
    repo_path=$(git rev-parse --show-toplevel)
    repo_name=$(basename "$repo_path")

    # Get the absolute path of the directory above the Git repository
    clone_parent=$(realpath "$(dirname "$repo_path")")  # Convert to absolute path
    clone_path="${clone_parent}/${repo_name}_clone"

    # Prevent overwriting if the directory already exists
    if [[ -d "$clone_path" ]]; then
        echo "Error: '$clone_path' already exists. Choose a different name or remove it."
        return 1
    fi

    # Perform the non-local clone
    echo "Cloning '$repo_name' to '$clone_path' (non-local clone)..."
    git clone --no-local "$repo_path" "$clone_path"

    # Verify success
    if [[ -d "$clone_path/.git" ]]; then
        echo "Success: Non-local clone created at '$clone_path'."
    else
        echo "Error: Cloning failed."
        return 1
    fi
}


alias git_nonlocal_clone="git_clone_nonlocal"

rename_files_for_filter_repo() {
    local files=("$@")
    local renamed_files=()

    echo ""
    echo "🔄 Renaming files to prevent accidental removal..."

    for file in "${files[@]}"; do
        if [[ -e "$file" ]]; then
            local new_name="${file}_filter_repo_prevent"

            if [[ -e "$new_name" ]]; then
                echo "❌ Conflict detected: '$new_name' already exists. Aborting."
                return 1
            fi

            mv "$file" "$new_name"
            renamed_files+=("$new_name")
            echo "✅ Renamed: '$file' → '$new_name'"
        else
            echo "⚠️ Warning: '$file' does not exist in the working directory. Proceeding..."
        fi
    done

    # Store renamed files for later restoration
    echo "${renamed_files[@]}" > .filter_repo_renamed_files
}

restore_files_after_filter_repo() {
    if [[ ! -f .filter_repo_renamed_files ]]; then
        echo "❌ No renamed files found. Nothing to restore."
        return 1
    fi

    echo ""
    echo "🔄 Restoring renamed files..."

    local renamed_files=($(cat .filter_repo_renamed_files))

    for renamed_file in "${renamed_files[@]}"; do
        local original_name="${renamed_file%_filter_repo_prevent}" # Strip `_filter_repo_prevent`

        if [[ -e "$renamed_file" ]]; then
            mv "$renamed_file" "$original_name"
            echo "✅ Restored: '$renamed_file' → '$original_name'"
        else
            echo "⚠️ Warning: '$renamed_file' not found. Skipping..."
        fi
    done

    rm -f .filter_repo_renamed_files  # Cleanup
}





git_filter_remove_dryrun() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: git_filter_remove_dryrun [--force] <file-or-directory> [<file2> ...]"
        return 1
    fi

    local files_to_check=()
    local force_mode=false

    # Parse arguments
    for arg in "$@"; do
        if [[ "$arg" == "--force" ]]; then
            force_mode=true
        else
            files_to_check+=("$arg")
        fi
    done

    echo ""
    echo "🔍 Dry Run: Checking which files exist in history..."
    echo ""

    if [[ "$force_mode" == false ]]; then
        local verified_files=()
        for file in "${files_to_check[@]}"; do
            if git log --name-only --pretty=format: | sort -u | grep -qx "$file"; then
                verified_files+=("$file")
                echo "✅ File Found: $file"
                echo "📜 Affected Commits:"
                git log --oneline --name-only --pretty=format:"%h %s" | grep -B 1 "$file" | awk '!seen[$0]++'
                echo "--------------------------------------"
            else
                echo "❌ Warning: '$file' does not exist in Git history. Exiting to be safe."
                return 1
            fi
        done

        # If no files exist, exit safely
        if [[ ${#verified_files[@]} -eq 0 ]]; then
            echo "❌ No valid files found in Git history. Aborting."
            return 1
        fi
    fi

    echo ""
    echo "🚀 Running `git filter-repo --dry-run` simulation..."
    echo ""

	# Step 1️⃣: Rename files to avoid accidental removal
    rename_files_for_filter_repo "${files_to_remove[@]}" || {
        echo "❌ File renaming failed. Aborting."
        return 1
    }


    if [[ "$force_mode" == true ]]; then
        git filter-repo --invert-paths --dry-run --force --path "${files_to_check[@]}"
    else
        git filter-repo --invert-paths --dry-run --path "${files_to_check[@]}"
    fi
    filter_repo_exit_code=$?

    if [[ $filter_repo_exit_code -ne 0 ]]; then
        printf "\n❌ `git filter-repo --dry-run` failed. Aborting.\n"
        printf "💡 If the file does not exist in history, there's nothing to remove.\n"
        printf "💡 This usually happens if you're not in a fresh clone.\n"
        printf "🔄 Try running: git_clone_nonlocal\n\n"
        return 1
    fi

    restore_files_after_filter_repo

    echo ""
    echo "✅ Dry run complete. No changes were made."
}

git_filter_remove() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: git_filter_remove [--force] <file-or-directory> [<file2> ...]"
        return 1
    fi

    printf "\n Are you in a non-local clone? Use git_clone_nonlocal first, then filter remove there, and push from there.\n\n"

    local files_to_remove=()
    local force_mode=false

    # Parse arguments
    for arg in "$@"; do
        if [[ "$arg" == "--force" ]]; then
            force_mode=true
        else
            files_to_remove+=("$arg")
        fi
    done

    if [[ "$force_mode" == false ]]; then
        # Check if files exist in Git history before attempting removal
        for file in "${files_to_remove[@]}"; do
            if git log --name-only --pretty=format: | sort -u | grep -qx "$file"; then
                echo "✅ File Found: $file"
            else
                echo "❌ Warning: '$file' does not exist in Git history. Exiting to be safe."
                return 1
            fi
        done
    fi

    echo "🚀 The following files will be removed from history:"
    echo "${files_to_remove[*]}"
    echo ""
    echo "⚠️ This will PERMANENTLY rewrite commit history."
    read "confirm?Are you sure? This will proceed to a dry-run (yes/no): "

    if [[ "$confirm" != "yes" ]]; then
        echo "❌ Manually Aborted."
        return 1
    fi


    # Call the dry-run function first
    if [[ "$force_mode" == true ]]; then
        git_filter_remove_dryrun --force "${files_to_remove[@]}" || {
            printf "\n❌ Aborting due to dry-run failure.\n"
            return 1
        }
    else
        git_filter_remove_dryrun "${files_to_remove[@]}" || {
            printf "\n❌ Aborting due to dry-run failure.\n"
            return 1
        }
    fi

    echo ""
    echo ""
    echo ""
    echo "🟡 Warning: This is the last check. If you say yes, it will do permanent removal."
    read "confirm_dry_run?Does this look like the output of a correct dry-run? (yes/no): "
    if [[ "$confirm_dry_run" != "yes" ]]; then
        echo "❌ Manually Aborted."
        return 1
    fi

    echo ""
    echo ""
    echo ""

	# Step 1️⃣: Rename files to avoid accidental removal
    rename_files_for_filter_repo "${files_to_remove[@]}" || {
        echo "❌ File renaming failed. Aborting."
        return 1
    }

    # Remove files from history using git filter-repo
    if [[ "$force_mode" == true ]]; then
        git filter-repo --invert-paths --force --path "${files_to_remove[@]}"
    else
        git filter-repo --invert-paths --path "${files_to_remove[@]}"
    fi

    restore_files_after_filter_repo

    echo "✅ Successfully removed files from Git history."
}


git_pull_branch() {
    local local_branch="$1"
    local remote_branch="${2:-$local_branch}"

    if [[ -z "$local_branch" ]]; then
        echo "Usage: git_pull_branch <local-branch> [remote-branch]"
        return 1
    fi

	# ====================================
    # Fetch the latest from origin
    git fetch origin "$remote_branch" || return 1

    # Create and checkout the local branch tracking the remote
    git checkout -b "$local_branch" "origin/$remote_branch"
}

alias gpb="git_pull_branch"






# ─────────────────────────────────────────────────────
# 🌎 🔧 1️⃣0️⃣ System Paths & Java + JUnit Setup
# ─────────────────────────────────────────────────────

# Custom home binaries, cargo binaries and go binaries

# User-level binaries
for dir in "$HOME/bin" "$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/go/bin" "$HOME/Music" ; do
  [[ -d "$dir" && ":$PATH:" != *":$dir:"* ]] && PATH="$dir:$PATH"
done
export PATH



alias -g see_path='echo $PATH | tr : "\n"'



JAVA_USR_PATH="$HOME/.local/java"
JAVA_SYS_PATH="/usr/lib/jvm"
JAVA_PATH="$JAVA_USR_PATH"

export JAVA_HOME="$JAVA_PATH/java-21-openjdk"
export PATH_TO_FX="$JAVA_PATH/javafx-sdk-21.0.6/lib"
export JDTLS_HOME="$HOME/.local/share/eclipse.jdt.ls/bin"


# Java-related
[[ -n "$JAVA_PATH" && ":$PATH:" != *":$JAVA_PATH:"* ]] && PATH="$JAVA_PATH:$PATH"
[[ -n "$JAVA_HOME" && -d "$JAVA_HOME/bin" && ":$PATH:" != *":$JAVA_HOME/bin:"* ]] && PATH="$JAVA_HOME/bin:$PATH"
export PATH


# don't use it 
# export PATH="$JDTLS_HOME:$PATH"



export JUNIT5_PATH="$JAVA_USR_PATH/junit5"
export JUNIT4_PATH="$JAVA_USR_PATH/junit4"

# Define CLASSPATH for Java compilation & execution
export CLASSPATH=".:$JAVA_HOME/lib:$PATH_TO_FX:\
$JUNIT5_PATH/junit-jupiter-api-5.11.3.jar:\
$JUNIT5_PATH/junit-jupiter-engine-5.11.3.jar:\
$JUNIT5_PATH/junit-jupiter-params-5.11.3.jar:\
$JUNIT4_PATH/junit-4.13.2.jar"

# Java Tool Options for JavaFX modules
export JAVAC_TOOL_OPTIONS="--module-path $PATH_TO_FX"
# --add-modules=javafx.base,javafx.controls,javafx.fxml,javafx.graphics,javafx.media,javafx.swing,javafx.web"

# With the export classpath, you can now do 
# javac MyProgram.java -- works without needed extra option
# java MyProgram.java -- works without needed extra options


alias jetuml="JetUML"
alias jetUML="JetUML"


export UNCRUSTIFY_CONFIG="$HOME/uncrustify_default.cfg"
# For C formatting


# Define paths
AutoMakeJava_Path="${HOME}/Documents/University (Real)/Semester 10/Comp 303/AutomakeJava"
# Automake Java tool
[[ -n "$AutoMakeJava_Path" && -d "$AutoMakeJava_Path/src" && ":$PATH:" != *":$AutoMakeJava_Path/src:"* ]] && PATH="$AutoMakeJava_Path/src:$PATH"
# export PATH="$AutoMakeJava_Path/src:$PATH"
export PATH

# Path to Python executable inside the virtual environment
pythonFor_AutoMakeJava="$PYTHON_VENV_DIR/javaAM/bin/python"


# Unset alias if it exists (to avoid conflicts)
unalias automakeJava 2>/dev/null

# Function to run automake.py using the correct Python environment
automakeJava() {
	"$pythonFor_AutoMakeJava" "${AutoMakeJava_Path}/src/automake.py" "$@"
}


# Alias to call the function
alias java_run="automakeJava"
export AM="$AutoMakeJava_Path/src/automake.py"


#

# ─────────────────────────────────────────────────────
# 🌎 🔧 1️⃣0️⃣ System Paths (Perl Setup)
# ─────────────────────────────────────────────────────


# Function to prepend to a colon-separated env var if not already present
prepend_path() {
  local varname=$1
  local dir=$2
  # Get current value of variable indirectly
  local val
  val=$(eval echo "\$$varname")
  case ":$val:" in
    *":$dir:"*) ;;  # already present, do nothing
    *)
      if [ -z "$val" ]; then
        eval "$varname=\"$dir\""
      else
        eval "$varname=\"$dir:$val\""
      fi
      ;;
  esac
}

# Prepend directories safely
prepend_path PATH "/home/francois/perl5/bin"
prepend_path PERL5LIB "/home/francois/perl5/lib/perl5"
prepend_path PERL_LOCAL_LIB_ROOT "/home/francois/perl5"

export PATH PERL5LIB PERL_LOCAL_LIB_ROOT

# The following two are static strings, just export them
PERL_MB_OPT="--install_base \"/home/francois/perl5\""
PERL_MM_OPT="INSTALL_BASE=/home/francois/perl5"

export PERL_MB_OPT PERL_MM_OPT


# PATH="/home/francois/perl5/bin${PATH:+:${PATH}}"; export PATH;
# PERL5LIB="/home/francois/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
# PERL_LOCAL_LIB_ROOT="/home/francois/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
# PERL_MB_OPT="--install_base \"/home/francois/perl5\""; export PERL_MB_OPT;
# PERL_MM_OPT="INSTALL_BASE=/home/francois/perl5"; export PERL_MM_OPT;


# ─────────────────────────────────────────────────────
# 🔧 1️⃣1️⃣ General / Miscellaneous Shortcuts
# ─────────────────────────────────────────────────────


unalias r 2>/dev/null # it's for redoing. But fuck that, who needs redoing commands, just up arrow and enter
# Reload Zsh configuration
alias r="source ~/.zshrc"

# Clear terminal. Like on windows and it's faster to type
alias cls="clear"

alias theme="kitty +kitten themes"
alias bless="bat --color=always --paging=always"
alias cat="bat --paging=never --style=plain" # replace cat with better cat

# json files good looking
alias jat="jq . |  bat --language json"

# Get current public IP
alias myip="curl -s https://ipinfo.io/ip"

# Open Neovim config
alias cn="cd ~/.config/nvim"
alias cnv="cd ~/.config/nvim "
alias cvi="cd ~/.config/vim "
alias cV="cd ~/.config/vim "

# For cmd | invert, to reverse the order
alias invert="tac"
alias reverse="tac"

# Arch Install commands
alias sp="sudo pacman -S"
alias yp="yay -S"


# Safe file removal with confirmation
# alias rm="rm -i"


# System information
alias sysinfo="neofetch"

# Check disk usage
alias disk="df -h"

# See partition with names
alias lsblk1="lsblk -o +PARTLABEL"

alias fpr="/home/francois/.config/nvim/scripts/find_project_root"

# List all open ports
alias ports="ss -tuln"

checkport() {
    if [[ -z "$1" ]]; then
        echo "Usage: checkport <port>"
        return 1
    fi

    local port="$1"
    
    if ss -tulnp | grep -w ":$port" >/dev/null 2>&1; then
        ss -tulnp | grep -w ":$port"
    else
        echo "❌ No socket found on port $port"
    fi
}


# Show processes in a tree format
alias psg="ps auxf"

# Copy current working directory to clipboard
alias pwc="pwd | c"
alias pwp='cd "$(p)"'
alias pwv="pwp"
alias prevc="history --max=1 | c"

copy_history() {
    local n=${1:-10}  # Default to 10 if no argument is given
    history | tail -n "$n" | awk '{$1=""; print substr($0,2)}' | c  
}


# Change directory to last visited
alias back="cd -"


alias et="exit"
alias lg="lazygit"
alias bottom="btm"
alias timeshift-wayland="sudo -E timeshift-gtk"

alias find_pacman_cycle="$HOME/.config/zsh/pacman_dep_tree/find_cycles.py"


c_debug() {
    ulimit -c unlimited
    echo "core.%e.%p" | sudo tee /proc/sys/kernel/core_pattern
}
# When a C program crash, it will dump the core file in the current dir, so you can use it for gdb

c_debug_stop() {
    # Reset the core dump file pattern to the default value
    echo "core" | sudo tee /proc/sys/kernel/core_pattern > /dev/null
    
    # Set the core dump size limit back to 0 (disable core dumps)
    ulimit -c 0
    
    echo "Core dump debugging has been disabled."
}

real_mounts() {
  {
    echo -e "Filesystem Type Size Used Avail Use% Mounted_on"
    df -hT -x tmpfs -x devtmpfs -x squashfs | awk '$1 ~ /^\/dev\//'
  } | column -t
}




show_files() {
  local dir="${1:-.}"
  local IGNORED_DIRS=(".git" ".nvim-session" "node_modules" "__pycache__")

  # Build find exclude arguments
  local FIND_IGNORE_ARGS=()
  for ignore in "${IGNORED_DIRS[@]}"; do
    FIND_IGNORE_ARGS+=( -path "$dir/$ignore" -prune -o )
  done

  # Find and process files
  find "$dir" "${FIND_IGNORE_ARGS[@]}" -type f -print 2>/dev/null | while read -r file; do
    # Check if it's a text file
    if file --mime-type "$file" | grep -q 'text/'; then
      echo -e "\n==> $file <=="
      cat "$file"
    else
      echo -e "\n==> $file (Not a text file, skipped) <=="
    fi
done
}

function kill_using_path() {
  local target="$1"
  if [[ -z "$target" ]]; then
    echo "Usage: kill_using_path /path/to/mountpoint"
    return 1
  fi

  echo "🔍 Checking processes using: $target"
  local output
  output=$(fuser -m "$target" 2>/dev/null)

  if [[ -z "$output" ]]; then
    echo "✅ No processes are using $target"
    return 0
  fi

  echo
  echo "🔗 Access Mode Legend:"
  echo "  c - current directory"
  echo "  e - executable being run"
  echo "  f - open file"
  echo "  F - open file for writing"
  echo "  r - root directory"
  echo "  m - memory-mapped file or library"

  echo
  echo "🧠 Found PIDs: $output"

  for pid_flag in ${(z)output}; do
    local pid="${pid_flag%%[a-zA-Z]}"
    local flag="${pid_flag:${#pid}}"

    echo
    echo "🔎 Process $pid is using it as: $flag"
    ps -p "$pid" -o pid,ppid,user,%cpu,%mem,etime,cmd

    echo
    read "?❓ Kill process $pid normally? [y/N] " reply
    if [[ "$reply" =~ ^[Yy]$ ]]; then
      kill "$pid" && echo "✅ Sent SIGTERM to $pid" || {
        echo "❌ Normal kill failed."
        read "?💥 Force kill (SIGKILL -9)? [y/N] " reply2
        if [[ "$reply2" =~ ^[Yy]$ ]]; then
          kill -9 "$pid" && echo "✅ Sent SIGKILL to $pid" || echo "❌ Force kill failed."
        fi
      }
    fi
  done
}




# ─────────────────────────────────────────────────────
# 🛠️ Zsh Functions for Background Execution with Logging
# ─────────────────────────────────────────────────────

# Function to execute a command in the background without logging
execp() {
    nohup "$@" > /dev/null 2>&1 &
}

# Function to execute a command in the background with logging
execpl_nohup() {
    mkdir -p "$HOME/.config/execp_logs"
    log_file="$HOME/.config/execp_logs/${1%% *}.log"

    printf "\n\n--------------------(%s)--------------------\n\n" "$(date)" >> "$log_file"

    nohup "$@" >> "$log_file" 2>&1 &
}

# Function to execute a command in the background using systemd
execpl_systemd() {
    mkdir -p "$HOME/.config/execp_logs"
    log_file="$HOME/.config/execp_logs/${1%% *}.log"

    printf "\n\n--------------------(%s)--------------------\n\n" "$(date)" >> "$log_file"

    systemd-run --user --unit="${1%% *}" --output=append:"$log_file" "$@"
}

# Alias to use systemd-based execution by default
alias execpl='execpl_nohup'


alias eth="execp thunar ."





alias change_prompt_look="p10k configure"
alias change_look="p10k configure"







replace_word() {
    local word_to_replace="$1"
    local replace_to="$2"
    local exception1="${3:-}"
    local exception2="${4:-}"

    if [[ -z "$word_to_replace" || -z "$replace_to" ]]; then
        echo "Usage: replace_word <word_to_replace> <replace_to> [exception1] [exception2]"
        return 1
    fi

    # Print info
    echo "Replacing: '$word_to_replace' → '$replace_to'"
    [[ -n "$exception1" ]] && echo "Excluding: '$exception1'"
    [[ -n "$exception2" ]] && echo "Excluding: '$exception2'"

    # Use ripgrep to find all files that contain the word
    local files=($(rg -l --fixed-strings "$word_to_replace"))

    for file in $files; do
        # Skip binary files (optional)
        if file "$file" | grep -q 'binary'; then
            continue
        fi

        # Perform in-place replacement using perl for precise matching
        perl -i -pe '
            my $from = $ARGV[0];
            my $to = $ARGV[1];
            my $ex1 = $ARGV[2];
            my $ex2 = $ARGV[3];

            s/\b$from\b(?!\w)/$to/g if (!defined($ex1) || $_ !~ /\b$ex1\b/) && (!defined($ex2) || $_ !~ /\b$ex2\b/);
        ' "$word_to_replace" "$replace_to" "$exception1" "$exception2" "$file"
    done

    echo "Done."
}


#======== Nvim ports commands

# Function to get the current project root using fpr
get_project_root() {
    # Run fpr and capture only stdout, stderr will be printed directly to the terminal
    project_root=$(fpr)

    # Capture the exit status of fpr
    local fpr_exit_code=$?

    # Handle different exit codes of fpr
    if [[ $fpr_exit_code -eq 1 ]]; then
        # fpr failed, default to current working directory (pwd)
        echo "Can't find project root, fpr defaulted to pwd" >&2  # Print error to stderr
        project_root=$(pwd)  # Default to current working directory
    elif [[ $fpr_exit_code -ne 0 ]]; then
        # fpr returned an invalid exit code (exit 2 or 3), print error message to stderr
        echo "Error: fpr returned an invalid exit code ($fpr_exit_code), exiting." >&2
        return 1  # Exit the function early, but don't exit the shell session
    fi

    # Check if the output is a valid directory
    if [[ ! -d "$project_root" ]]; then
        echo "Project root ($project_root) is not a valid directory, exiting." >&2  # Print error to stderr
        return 1  # Exit the function early, but don't exit the shell session
    fi

    # Return the project root (stdout)
    echo "$project_root"  # Return the valid path
}








alias rv="$HOME/.config/nvim/scripts/pythonScripts/open_remote_nvim.py"
alias rvmod="rv $HOME/.config/nvim/scripts/pythonScripts/open_remote_nvim.py"
alias sv="$HOME/.config/nvim/scripts/pythonScripts/send_to_nvim.py"

DEFAULT_RSM="default"
alias rv1="rv --name=1"
alias rv2="rv --name=2"
alias rv3="rv --name=3"
alias sv1="sv --name=1"
alias sv2="sv --name=2"
alias sv3="sv --name=3"




# -------- Weird stuff V2: Latex Boogaloo
export CHKTEXRC=/usr/local/etc/chktexrc

send_notification() {
    $PYTHON_VENV_DIR/pip_venv/bin/python \
    /home/francois/Documents/PhoneNotification/send_notification.py \
    --title="$1" --content="$2"
}

#ignore ctrl + d. so no close
setopt IGNORE_EOF


alias unfuck_sudo="sudo rm /var/run/faillock"
alias unfuck_sudo_clean="sudo faillock --user=francois --reset"
# need to login as recovery

# ─────────────────────────────────────────────────────
# 🔢 Line counter
# ─────────────────────────────────────────────────────


function lcount_tree() {
	"$HOME/.config/zsh/lcount_tree.py"
}

alias count_lines="lcount_tree"

lcount_total() {
  local total=0
  while IFS= read -r lines; do
    (( total += lines ))
  done < <(find . -type f -not -path '*/.*' -exec wc -l {} + | awk '$2 != "total" {print $1}')
  echo $total
}

lcount1() { find . -type f -exec wc -l {} + ; } # also gets hidden files, so .git fucks
lcount2() { find . -type f -not -path '*/.*' -exec wc -l {} + ; } # the good one to copy paste to another pc
lcount3() { find . -type f -not -path '*/.*' -exec wc -l {} + | awk '$2 != "total" {sum += $1} END {print sum}'; }
#3 just recalc the total. it's less good

lcount() {
  find . -type f \
    -not -path '*/.*' \
    -not -name '*.pyc' \
    -not -name '*.png' \
    -exec wc -l {} +
}


lcount_type() {
  if (( $# == 0 )); then
    echo "Usage: lcount_type ext1 ext2 ..."
    return 1
  fi

  local find_args=(.)

  # build -name patterns for each extension
  local name_args=()
  for ext in "$@"; do
    ext="${ext#.}"  # remove leading dot
    name_args+=(-o -name "*.$ext")
  done
  # remove first -o
  name_args=("${name_args[@]:1}")

  find "${find_args[@]}" -type f \( "${name_args[@]}" \) \
    -not -path './.git/*' \
    -not -name '*.pyc' \
    -not -name '*.png' \
    -exec wc -l {} +
}


#------- C alias ------------
# alias c89="gcc -std=c89"
# alias c90="gcc -std=c90"
# alias c99="gcc -std=c99"
# alias c11="gcc -std=c11"
# alias c17="gcc -std=c17"
# alias c18="gcc -std=c18"
# alias c23="gcc -std=c23"
                              
                              
                             1
#---------------------------- ------------ END OF FILE ---------
                             1
# Add this (replace false to  true ) in ~/.p10k.zsh 
# typeset -g POWERLEVEL9K_STA2TUS_ERROR=true

# typeset -g POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true
typeset -g POWERLEVEL9K_HOST_FOREGROUND=red

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh


