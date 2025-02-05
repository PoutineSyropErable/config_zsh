# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#### ---- Commands with ZSH_CUSTOM should probably be runned while zsh is the active shell. But the default is still given

# Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
	${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# zsh plugins for autosuggestions and syntax highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions \
	${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
	${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# one for virtualvenv, stuff like python and conda
pip install virtualenvwrapper

if [ -f /etc/os-release ]; then
	# Detect Linux distribution
	source /etc/os-release
	if [[ "$ID" == "arch" || "$ID_LIKE" == "arch" ]]; then
		echo "Detected: Arch Linux"
		SYSTEM="arch"
	else
		echo "Detected: Other Linux ($ID)"
		SYSTEM="linux"
	fi
elif [ "$(uname)" == "Darwin" ]; then
	echo "Detected: macOS"
	SYSTEM="macOS"
else
	echo "Unknown OS"
	SYSTEM="unknown"
fi

#On arch: (Use yay or paru if you want lf-sixel-git)
if [ SYSTEM == "arch"]; then
	pacman -S --needed \
		zoxide \
		atuin \
		thefuck \
		fzf \
		bat \
		ripgrep \
		fd \
		tmux \
		lf \
		lsd \
		lazygit \
		neovim \
		eza \
		jq \
		tree \
		kitty \
		git \
		coreutils \
		xclip \
		curl \
		wget \
		neofetch
fi

# maybe brew will failed to install some of them, if it does, just remove it untill it can install as much as possible
# I don't have mac, but for you guys it should be this (I hope)
if [ SYSTEM == "macOS"]; then
	brew install \
		zoxide \
		atuin \
		thefuck \
		fzf \
		bat \
		ripgrep \
		fd \
		tmux \
		lf \
		lsd \
		lazygit \
		neovim \
		eza \
		jq \
		tree \
		kitty \
		git \
		coreutils \
		xclip \
		curl \
		wget \
		neofetch
fi

mkdir -p $HOME/MainPython_Virtual_Environment # Old one, for pip venv
mkdir -p $HOME/PythonVenv                     # New one, for pip venv
# For my team member: pip doesn't work for you guys due to certificate auth
# So, we are using conda. So these two dirs aren't important
