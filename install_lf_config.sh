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
		return 1
	fi
}

install_ctpv_fedora() {
	# Save current directory
	local _orig_dir="$PWD"

	# Ensure we return to the original directory even if something fails
	trap 'cd "$_orig_dir"' RETURN

	# Install dependencies
	sudo dnf install -y file-devel git make gcc

	# Clone and install ctpv
	local _tmp_dir
	_tmp_dir=$(mktemp -d) || {
		echo "Failed to create temp dir"
		return 1
	}
	git clone https://github.com/NikitaIvanovV/ctpv "$_tmp_dir/ctpv" || return 2

	cd "$_tmp_dir/ctpv" || return 3
	make || return 4
	sudo make install || return 5

	echo "ctpv installed successfully!"

}

install_ctpv
#if last fail, use the install_ctpv_fedora

# Capture the exit code
last_status=$?

# If it failed, run the Fedora manual build
if [ $last_status -ne 0 ]; then
	echo "General package install failed. Trying Fedora manual build..."
	install_ctpv_fedora
	last_status=$?
fi

# Exit with the final status
exit $last_status
