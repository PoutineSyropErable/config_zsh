Here's what it looks like

![Example of zsh config Image](zzz_Example.png)

Also, to install do:

```bash
# Backup existing ~/.config/zsh if it exists, using numbered backups (~1, ~2, etc.)
[ -d ~/.config/zsh ] && mv --backup=numbered ~/.config/zsh ~/.config/zsh_backup

# Clone the repository if ~/.config/zsh does not exist
git clone https://github.com/PoutineSyropErable/config_zsh ~/.config/zsh

# Backup existing ~/.zshrc if it exists, using numbered backups
[ -f ~/.zshrc ] && mv --backup=numbered ~/.zshrc ~/.zshrc.bak


cd ~/.config/zsh
chmod 744 ./install_commands.sh
./zsh_clone_command.sh # If there's an error, we'll have to manually install what fails
./package_install_commands.sh
# This also install a bunch of packages, look at it.

# Backup existing ~/.zshrc if it exists, using numbered backups
[ -f ~/.zshrc ] && mv --backup=numbered ~/.zshrc ~/.zshrc.bak
# Create a symbolic link only if the cloned .zshrc exists
ln -s ~/.config/zsh/.zshrc ~/.zshrc

cd ~/PythonVenv
python3 -m venv "~/PythonVenv/pip_venv/"
#btw, if your system is dumb like mac, you should add a softlink so
# python -> python3
pip install virtualvenvwrapper
zsh

```

then copy the commands from install commands.sh

Aka: check ./install_commands.sh, but don't really execute it. Maybe executing it will work, you'll most likely have to copy and paste
it's content one line at a time.
