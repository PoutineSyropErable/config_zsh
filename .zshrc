# ─────────────────────────────────────────────────────
# 🛠️ 1️⃣ Zsh & Environment Configuration
# ─────────────────────────────────────────────────────

# Oh My Zsh Path
export ZSH="$HOME/.oh-my-zsh"

# Set Theme
ZSH_THEME="fletcherm"

# Plugins
plugins=(
    git
    virtualenvwrapper
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Terminal & Editor Settings
export TERMINAL=kitty
export EDITOR=nvim

# ─────────────────────────────────────────────────────
# 🛠️  Initialize CLI Tools (With Warnings)
# ─────────────────────────────────────────────────────

# Initialize thefuck
if ! eval "$(thefuck --alias)"; then
    echo "⚠️ Warning: Failed to initialize 'thefuck'"
fi

# Initialize zoxide
if ! eval "$(zoxide init zsh)"; then
    echo "⚠️ Warning: Failed to initialize 'zoxide'"
fi

# Initialize atuin
if ! eval "$(atuin init zsh --disable-up-arrow)"; then
    echo "⚠️ Warning: Failed to initialize 'atuin'"
fi

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

alias pythonvenv="$HOME/MainPython_Virtual_Environment/pip_venv/bin/python"
alias pv="pythonvenv"
alias govenv="source $HOME/MainPython_Virtual_Environment/pip_venv/bin/activate"
alias projvenv="source $HOME/MainPython_Virtual_Environment/project_venv/bin/activate"

# ─────────────────────────────────────────────────────
# 📁 4️⃣ Navigation & Directory Shortcuts
# ─────────────────────────────────────────────────────

alias ch='cd ~'
alias cco="cd ~/.config"
alias ce="cd ~/.config/eww"
alias cf="cd ~/.config/fish"
alias chy="cd ~/.config/hypr"
alias cir="cd ~/.config/ironbar"
alias cka="cd ~/.config/kanata"
alias cki="cd ~/.config/kitty"
alias clf="cd ~/.config/lf"
alias cr="cd ~/.config/rofi"
alias ctm="cd ~/.config/tmux"
alias cz="cd ~/.config/zsh"
alias cw="cd ~/.config/waybar"
alias cdo="cd ~/Downloads"
alias cdoc="cd ~/Documents"
alias cm="cd ~/Music"
alias cpi="cd ~/Pictures"
alias chg="cd ~/home_for_git"

# ─────────────────────────────────────────────────────
# 🎨 5️⃣ Visual Enhancements
# ─────────────────────────────────────────────────────

alias fview="bat ~/.fishrc"
alias theme="kitty +kitten themes"
alias bless="bat --color=always --paging=always"

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

fzfv() {
    nvim "$(fzf -m --preview='bat --color=always {}')"
}
fzfc() {
    fzf -m --preview='feh {}' | c
}
fc() {
    cat "$@" | c
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

alias ga="git add ."
alias gdf="git diff --name-only"
alias gcm="gc"

gc() {
    git commit -m "$1"
}

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

git_push_all_msg() {
    if [[ $# -eq 0 ]]; then
        echo "Error: Commit message is required."
        return 1
    fi
    local commit_message="$1"
    git submodule foreach --recursive '
        git add --all
        git commit -m "'"$commit_message"'" || echo "No changes to commit"
        git push origin $(git branch --show-current)
    '
    git add --all
    git commit -m "$commit_message" || echo "No changes to commit in root repository"
    git push origin "$(git branch --show-current)"
}

git_push_all() {
    git_push_all_msg "super push, root git dir and all submodules"
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

