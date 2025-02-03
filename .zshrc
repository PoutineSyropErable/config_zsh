# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="fletcherm"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
	virtualenvwrapper
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# ---------------------------------------------------- Personal ZSH, PUT THE PREVIOUS STUFF HERE -----------------------------

eval "$(thefuck --alias)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"
source ~/.config/lf/lf.zsh


export TERMINAL=kitty
export EDITOR=nvim

alias cd="z"
alias v="nvim"
alias et="exit"
alias lg="lazygit"


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


alias pwc="pwd | c"
alias pwv='cd "$(p)"'
alias pwp='cd "$(p)"'


alias pythonvenv="$HOME/MainPython_Virtual_Environment/pip_venv/bin/python"
alias pv="pythonvenv"
alias govenv="source $HOME/MainPython_Virtual_Environment/pip_venv/bin/activate"
alias projvenv="source $HOME/MainPython_Virtual_Environment/project_venv/bin/activate"



alias r="source ~/.zshrc"
alias zmod="nvim ~/.zshrc"
alias fmod="nvim ~/.config/fish/config.fish"
alias tmod="vim ~/.tmux.conf"
alias cls="clear"

alias slf="sudo -E lf"
alias cnv="cd ~/.config/nvim ; nvim ."
alias nmod="cd ~/.config/nvim ; nvim ."
alias vmod="cd ~/.config/nvim ; nvim ."
alias keymod="cd ~/.config/nvim ; nvim lua/core/keymaps.lua"

alias bless="bat --color=always --paging=always"


alias ch='cd ~'
alias cco="cd ~/.config"
alias ce="cd ~/.config/eww"
alias cf="cd ~/.config/fish"
alias cH="cd ~/.config/hypr"
alias chy="cd ~/.config/hypr"
alias cir="cd ~/.config/ironbar"
alias ck="cd ~/.config/kanata"
alias cka="cd ~/.config/kanata"
alias cki="cd ~/.config/kitty"
alias clf="cd ~/.config/lf"
alias cP="cd ~/.config/polybar.old/"
alias cr="cd ~/.config/rofi"
alias cS="cd ~/.config/systemd"
alias ctm="cd ~/.config/tmux"
alias cz="cd ~/.config/zsh"
alias cw="cd ~/.config/waybar"



alias cs9="cd ~ ; cd sem9"
alias cdo="cd ~/Downloads"
alias cdoc="cd ~/Documents"
alias cm="cd ~/Music"
alias cpi="cd ~/Pictures"
alias chg=" cd ~/home_for_git"

alias fview="bat ~/.fishrc"
alias theme="kitty +kitten themes"



alias kmux="tmux kill-server"
alias lmux="tmux detach"
alias dmux="tmus detach"
alias qmux="tmux kill-session"
alias jmux="tmux kill-session"



alias kpane="tmux kill-pane"
alias rmux="tmux source-file ~/.tmux.conf"
alias umux="tmux source-file ~/.tmux.conf"
alias jj="tmux select-pane -L"
alias jk="tmux select-pane -D"
alias jl="tmux select-pane -R"
alias ji="tmux select-pane -U"



# Swap tmux panes
tswap() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: tswap pane1 pane2"
        return 1
    fi
    local pane1="$1"
    local pane2="$2"
    tmux swap-pane -s "$pane1" -t "$pane2"
}

# Compare MD5 hash
comparehash_md5() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: comparehash_md5 <file> <expected_hash>"
        return 1
    fi
    local file="$1"
    local expected_hash="$2"
    local actual_hash
    actual_hash=$(md5sum "$file" | awk '{print $1}')

    if [[ "$actual_hash" == "$expected_hash" ]]; then
        echo "Hashes match: $actual_hash"
    else
        echo "Hashes do not match:"
        echo "Actual hash:   $actual_hash"
        echo "Expected hash: $expected_hash"
    fi
}

# Compare SHA256 hash
comparehash_sha() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: comparehash_sha <file> <expected_hash>"
        return 1
    fi
    local file="$1"
    local expected_hash="$2"
    local actual_hash
    actual_hash=$(sha256sum "$file" | awk '{print $1}')

    if [[ "$actual_hash" == "$expected_hash" ]]; then
        echo "Hashes match: $actual_hash"
    else
        echo "Hashes do not match:"
        echo "Actual hash:   $actual_hash"
        echo "Expected hash: $expected_hash"
    fi
}



fzfv() {
    nvim "$(fzf -m --preview='bat --color=always {}')"
}
fzfc() {
    fzf -m --preview='feh {}' | c 
}


fc() {
    cat "$@" | c
}


# fcd: No max depth restriction, supports hidden directories and wildcards
fcd() {
  local search_term="$1"
  local dir
  dir=$(fd -t d --hidden "$search_term" | fzf)

  if [[ -n "$dir" ]]; then
    cd "$dir"
  fi
}

# fcd1: Restrict to max depth = 1, supports hidden directories and wildcards
fcd1() {
  local search_term="$1"
  local dir
  dir=$(fd -t d --hidden -d 1 "$search_term" | fzf)

  if [[ -n "$dir" ]]; then
    cd "$dir"
  fi
}

# fcdn: Specify max depth, supports hidden directories and wildcards
fcdn() {
  if [[ -z "$1" ]]; then
    echo "Usage: fcdn <max-depth> [wildcard]"
    return 1
  fi

  local depth="$1"
  local search_term="${2:-}"  # Optional second argument
  local dir
  dir=$(fd -t d --hidden -d "$depth" "$search_term" | fzf)

  if [[ -n "$dir" ]]; then
    cd "$dir"
  fi
}


ndiff() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: ndiff file1 file2"
        return 1
    fi
    diff --color "$1" "$2" | diff-so-fancy | bat
}

bdiff() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: bdiff file1 file2"
        return 1
    fi
    git diff --no-index --color "$1" "$2" | diff-so-fancy | bat
}



# Aliases
alias ga="git add ."
alias gdf="git diff --name-only"

# Function to commit with a message
gc() {
    git commit -m "$1"
}

# Function to switch to laptop branch inside ~/.config
gcl() {
    cd ~/.config || return
    git checkout laptop
    cd - || return
}

# Function to switch to desktop branch inside ~/.config
gcd() {
    cd ~/.config || return
    git checkout desktop
    cd - || return
}

# Function to add, commit, and push with a message
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

# Function to commit and push all submodules and the main repo
git_push_all_msg() {
    if [[ $# -eq 0 ]]; then
        echo "Error: Commit message is required."
        return 1
    fi

    local commit_message="$1"

    echo "Processing all submodules..."
    echo "________________________________"

    git submodule foreach --recursive '
        echo "Updating submodule $name..."
        git add --all
        git commit -m "'"$commit_message"'" || echo "No changes to commit in $name"
        git push origin $(git branch --show-current)
        echo "________________________________"
    '

    echo "Processing the current repository..."
    git add --all
    git commit -m "$commit_message" || echo "No changes to commit in the root repository"
    git push origin "$(git branch --show-current)"
}

# Function to push all with a hardcoded commit message
git_push_all() {
    git_push_all_msg "super push, root git dir and all submodules"
}

# Function to commit all submodules and the main repo
git_commit_all() {
    echo "Processing all submodules..."
    echo "________________________________"

    git submodule foreach --recursive '
        echo "Updating submodule $name..."
        git add .
        git commit -m "all update commit"
        echo "________________________________"
    '

    git add .
    git commit -m "all update commit"
    git push origin "$(git branch --show-current)"
}

# Function to pull all submodules and the main repo
git_pull_all() {
    echo "Processing all submodules..."
    echo "________________________________"

    git submodule foreach --recursive '
        echo "Updating submodule $name..."
        git pull origin $(git branch --show-current)
        echo "________________________________"
    '
}

# Additional Git Aliases
alias gcm="gc"
alias git_file_diff="git diff --name-only HEAD"
alias gfd="git_file_diff"

alias gpd="git push origin desktop"
alias gpl="git push origin laptop"
alias gpm="git push origin master"
alias gpmn="git push origin main"

alias gpam="git_push_all_msg"
alias gpa="git_push_all"

alias gda="git_do_all"







export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

export PATH="$HOME/Music:$PATH"





# Set paths for JUnit 5 and JUnit 4
export JUNIT5_PATH=/usr/lib/jvm/junit5
export JUNIT4_PATH=/usr/lib/jvm/junit4

# Add JUnit paths to CLASSPATH
export CLASSPATH="$JUNIT5_PATH/junit-jupiter-api-5.11.3.jar:\
$JUNIT5_PATH/junit-jupiter-engine-5.11.3.jar:\
$JUNIT5_PATH/junit-jupiter-params-5.11.3.jar:\
$JUNIT4_PATH/junit-4.13.2.jar"
