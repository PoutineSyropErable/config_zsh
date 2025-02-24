# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Add this (replace false to true ) in ~/.p10k.zsh 
# typeset -g POWERLEVEL9K_STATUS_ERROR=true

echo "missing to add local paths (and not just repo path for git filter_remove), though adding it might be a bad idea. Sleep on it and"
echo "implement it later."

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
	virtualenvwrapper
    zsh-syntax-highlighting
	zsh-autosuggestions
)

    # git

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Terminal & Editor Settings
export TERMINAL=kitty
export EDITOR=nvim

alias v="nvim"
alias vim="nvim"
alias ovim="/usr/bin/vim"
alias pvim="nvim --startuptime ~/.config/nvim_logs/startup.log"


bindkey -s '^F' 'lf\n'
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



# ─────────────────────────────────────────────────────
# 🚀 3️⃣ Python Virtual Environments
# ─────────────────────────────────────────────────────

# Define the base directory for Python virtual environments (from pip)
export PYTHON_VENV_DIR="$HOME/MainPython_Virtual_Environment"

# Aliases for managing virtual environments
alias pythonvenv="$PYTHON_VENV_DIR/pip_venv/bin/python" #without activating the venv, using its python to run a file 
# you can do: "pv file.py" for example
alias pv="pythonvenv"

# activate and deactivate venvs
alias govenv="source $PYTHON_VENV_DIR/pip_venv/bin/activate"
alias projvenv="source $PYTHON_VENV_DIR/project_venv/bin/activate"
alias lvenv="deactivate"



# A premade wrapper: 
# These don't work with conda so they are kinda useless for you... But it does make some python stuff
# Easier I guess if you want to use that rather then my venvs example alias
# Like in further project where you'd rather use pip packages then conda packages
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=$(which python3)
export VIRTUALENVWRAPPER_VIRTUALENV=$(which virtualenv)
source $(which virtualenvwrapper.sh)

# Command				What It Does
# mkvirtualenv myenv	Create a virtual environment named myenv
# workon myenv			Activate the myenv environment
# deactivate			Exit the active virtual environment
# rmvirtualenv myenv	Delete myenv
# lsvirtualenv			List all virtual environments
# cdvirtualenv			Go to the active virtual environment's directory
# cdsitepackages		Navigate to the site-packages directory

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

# possibly, you can just straight up do: "conda activate master_venv"
# but that's only gonna happen if conda_path was exported to path
# And that might fuck up some system wide install, because it tries to use that version of python
# rather then your system wide python, which is what should be used for system updates and operation

# Keeping the bellow commented out. With it commented out, conda activate master_venv won't work. because 
# conda is unknown command. With it not commented out, it will work. But see warning paragraph above
# export PATH="$HOME/miniconda3/bin/conda:$PATH"



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
alias ce="cd ~/.config/eww"
alias cf="cd ~/.config/fish"
alias cH="cd ~/.config/hypr"
alias cir="cd ~/.config/ironbar"
alias cka="cd ~/.config/kanata"
alias cki="cd ~/.config/kitty"
alias clf="cd ~/.config/lf"
alias cP="cd ~/.config/polybar.old/"
alias cr="cd ~/.config/rofi"
alias ctm="cd ~/.config/tmux"
alias cw="cd ~/.config/waybar"
alias cz="cd ~/.config/zsh"


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

alias amod="vim ~/.config/awesome/rc.lua"
alias bmod="vim ~/.bashrc"
alias cmod="vim ~/.config/conky/show_all/show_all_conf"
alias fmod="nvim ~/.config/fish/config.fish"
alias hmod="cd ~/.config/hypr && vim hyprland.conf"
alias imod="vim ~/.i3rc"
alias irmod="cd ~/.config/ironbar && vim ~/.config/ironbar/"
alias kamod="vim ~/.config/kanata/kanata.kbd"
alias kimod="vim ~/.config/kitty/kitty.conf"
alias keymod="cd ~/.config/nvim && nvim lua/core/keymaps.lua"
alias mmod="vim ~/.config/mpd/mpd.conf"
alias ncmod="vim ~/.ncmpcpp/config"
alias nmod="cd ~/.config/nvim && nvim ."
alias pmod="vim ~/.config/polybar.old/config"
alias smod="vim ~/.config/sway/config"
alias tmod="nvim ~/.tmux.conf"
alias vmod="cd ~/.config/nvim && nvim ."
alias wmod="cd ~/.config/waybar && vim ~/.config/waybar/"
alias zmod="nvim ~/.zshrc"

alias zview="bless ~/.zshrc"

alias fview="bat ~/.fishrc"
alias tview="bat ~/.tmuxrc"


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



# ─────────────────────────────────────────────────────
# 🔎 7️⃣ File Search & Clipboard Commands
# ─────────────────────────────────────────────────────

# Search a file with fzf, see its preview, and open it in 
# neovim to edit it
fzfv() {
    nvim "$(fzf -m --preview='bat --color=always {} .')"
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



# ─────────────────────────────────────────────────────
# 🛠️ 9️⃣ Git Functions & Aliases
# ─────────────────────────────────────────────────────

# Ensure no alias conflict before defining functions
unalias gc 2>/dev/null
unalias ga 2>/dev/null
unalias gcm 2>/dev/null

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


# ─────────────────────────────────────────────────────
# ⚡ Git Aliases for Quick Commands
# ─────────────────────────────────────────────────────

alias ga="git add ."
alias gcm="gc"
alias gdf="git diff --name-only"

alias gpd="git push origin desktop"
alias gpl="git push origin laptop"
alias gpm="git push origin \$(git branch --show-current)"
alias gpu="git pull origin \$(git branch --show-current)"
alias gpmn="git push origin main"

alias gpam="git_push_all_msg"
alias gpa="git_push_all"

alias gda="git_do_all"



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
    # Remove files from history using git filter-repo
    if [[ "$force_mode" == true ]]; then
        git filter-repo --invert-paths --force --path "${files_to_remove[@]}"
    else
        git filter-repo --invert-paths --path "${files_to_remove[@]}"
    fi

    echo "✅ Successfully removed files from Git history."
}





# ─────────────────────────────────────────────────────
# 🌎 🔧 1️⃣0️⃣ System Paths & JUnit Setup
# ─────────────────────────────────────────────────────

export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:$HOME/Music:$PATH"

export JUNIT5_PATH="/usr/lib/jvm/junit5"
export JUNIT4_PATH="/usr/lib/jvm/junit4"

export CLASSPATH="$JUNIT5_PATH/junit-jupiter-api-5.11.3.jar:\
$JUNIT5_PATH/junit-jupiter-engine-5.11.3.jar:\
$JUNIT5_PATH/junit-jupiter-params-5.11.3.jar:\
$JUNIT4_PATH/junit-4.13.2.jar"

JAVA_PATH="$HOME/.local/java"
export JAVA_HOME="$JAVA_PATH/java-23-openjdk"
export PATH_TO_FX="$JAVA_PATH/javafx-sdk-23/lib"
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="$JAVA_PATH:$PATH"

alias jetuml="JetUML"
alias jetUML="JetUML"


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

# List all open ports
alias ports="ss -tuln"

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


c_debug() {
    ulimit -c unlimited
    echo "core.%e.%p" | sudo tee /proc/sys/kernel/core_pattern
}
# When a C program crash, it will dump the core file in the current dir, so you can use it for gdb


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


# -------- Weird stuff V2: Latex Boogaloo
export CHKTEXRC=/usr/local/etc/chktexrc


#---------------------------------------- END OF FILE ---------
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
