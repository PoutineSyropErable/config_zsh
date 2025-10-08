#!/bin/bash

# Backup existing ~/.config/lf if it exists, using numbered backups (~1, ~2, etc.)
[ -d ~/.config/lf ] && mv --backup=numbered ~/.config/lf ~/.config/lf_backup

# Clone the lf configuration repository
git clone https://github.com/PoutineSyropErable/config_lf ~/.config/lf

# Function to install ctpv depending on package manager
install_ctpv() {
	if command -v yay >/dev/null 2>&1; then
		yay -S --needed --noconfirm ctpv
	elif command -v paru >/dev/null 2>&1; then
		paru -S --needed --noconfirm ctpv
	elif command -v brew >/dev/null 2>&1; then
		brew install ctpv
	elif command -v apt >/dev/null 2>&1; then
		sudo apt update
		sudo apt install -y ctpv
	elif command -v dnf >/dev/null 2>&1; then
		sudo dnf install -y ctpv --skip-unavailable
	else
		echo "Could not find a known package manager. Please install ctpv manually."
	fi
}

install_ctpv
