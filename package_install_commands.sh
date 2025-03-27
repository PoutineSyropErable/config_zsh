# one for virtualvenv, stuff like python and conda

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
	echo -n "\n\n-------------------WARNING: Unknown OS---------------------------------\n\n"
	printf "Check package_install.sh, and manually download the packages "
	exit 2
fi

#On arch: (Use yay or paru if you want lf-sixel-git)
if [ SYSTEM == "arch" ]; then
	printf "\n\n--------Installing Arch Linux Packages -------------\n\n"
	sudo pacman -S --needed \
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
		curl \
		wget \
		xclip \
		wl-clipboard \
		neofetch
fi

# maybe brew will failed to install some of them, if it does, just remove it untill it can install as much as possible
# I don't have mac, but for you guys it should be this (I hope)
if [ SYSTEM == "macOS" ]; then
	printf "\n\n--------Installing MacOs Packages -------------\n\n"
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
		curl \
		wget \
		neofetch \
		xclip
	# xclip probably useless cause no x11 lol
fi

# For my team member: pip doesn't work for you guys due to certificate auth
# So, we are using conda. So these two dirs aren't important
