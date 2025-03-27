#!/bin/bash

# Backup existing ~/.config/lf if it exists, using numbered backups (~1, ~2, etc.)
[ -d ~/.config/lf ] && mv --backup=numbered ~/.config/lf ~/.config/lf_backup

# Clone the lf configuration repository
git clone https://github.com/PoutineSyropErable/config_lf ~/.config/lf

yay -S --needed ctpv || paru -S --needed ctpv || sudo brew install ctpv || sudo apt install ctpv || echo "Can't install ctpv"
