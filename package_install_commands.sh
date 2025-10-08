#!/usr/bin/env bash

# Detect OS
if [ -f /etc/os-release ]; then
	source /etc/os-release
	if [[ "$ID" == "arch" || "$ID_LIKE" == "arch" ]]; then
		echo "Detected: Arch Linux"
		SYSTEM="arch"
	elif [[ "$ID" == "fedora" || "$ID_LIKE" == "fedora" ]]; then
		echo "Detected: Fedora Linux"
		SYSTEM="fedora"
		sudo dnf copr enable dejan/lazygit
	else
		echo "Detected: Other Linux ($ID)"
		SYSTEM="linux"
	fi
elif [[ "$(uname)" == "Darwin" ]]; then
	echo "Detected: macOS"
	SYSTEM="macOS"
else
	echo -e "\n\n-------------------WARNING: Unknown OS---------------------------------\n\n"
	printf "Check package_install.sh, and manually download the packages\n"
	exit 2
fi

# Packages list (common for all supported systems)
PKGS=(
	zoxide
	atuin
	thefuck
	fzf
	bat
	ripgrep
	fd
	tmux
	lf
	lsd
	lazygit
	neovim
	eza
	jq
	tree
	kitty
	git
	coreutils
	curl
	wget
	xclip
	wl-clipboard
	neofetch
)

# Install packages
if [[ "$SYSTEM" == "arch" ]]; then
	echo -e "\n\n--------Installing Arch Linux Packages -------------\n\n"
	if command -v yay >/dev/null 2>&1; then
		echo "Using yay to install packages..."
		yay -S --needed --noconfirm "${PKGS[@]}"
	elif command -v paru >/dev/null 2>&1; then
		echo "Using paru to install packages..."
		paru -S --needed --noconfirm "${PKGS[@]}"
	else
		echo "Falling back to pacman..."
		sudo pacman -S --needed "${PKGS[@]}"
	fi

elif [[ "$SYSTEM" == "fedora" ]]; then
	echo -e "\n\n--------Installing Fedora Packages -------------\n\n"
	# --skip-unavailable avoids failure if a package doesn't exist
	sudo dnf install -y "${PKGS[@]}" --skip-unavailable

elif [[ "$SYSTEM" == "macOS" ]]; then
	echo -e "\n\n--------Installing macOS Packages -------------\n\n"
	brew install "${PKGS[@]}"

else
	echo -e "\n\n--------Installing Other Linux Packages -------------\n\n"
	# Try apt (Debian/Ubuntu), zypper (openSUSE), or pacman fallback
	if command -v apt >/dev/null 2>&1; then
		sudo apt update
		sudo apt install -y "${PKGS[@]}"
	elif command -v zypper >/dev/null 2>&1; then
		sudo zypper install -y "${PKGS[@]}"
	elif command -v pacman >/dev/null 2>&1; then
		sudo pacman -S --needed "${PKGS[@]}"
	else
		echo "No known package manager found. Please install manually: ${PKGS[*]}"
	fi
fi

# Note: pip / conda setup handled separately as needed
