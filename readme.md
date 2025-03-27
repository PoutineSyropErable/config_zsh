Here's what it looks like

You might want to checkout the parent:
For terminal: kitty + tmux + zsh + lf + nvim
configuration works well.

1. kitty is a terminal
2. tmux is the multiplexer to make one terminal = Many
   (Though kitty already has a multiplexer, i dont like it)
3. zsh is the shell
4. lf is a file manager
5. Neovim is a file editor, with all the ide features

<pre>
<a href="https://github.com/PoutineSyropErable/config_all">https://github.com/PoutineSyropErable/config_all</a>
# ^The parent, the children vv
<a href="https://github.com/PoutineSyropErable/config_kitty">https://github.com/PoutineSyropErable/config_kitty</a>
<a href="https://github.com/PoutineSyropErable/config_tmux">https://github.com/PoutineSyropErable/config_tmux</a>
<a href="https://github.com/PoutineSyropErable/config_lf">https://github.com/PoutineSyropErable/config_lf</a>
<a href="https://github.com/PoutineSyropErable/config_nvim">https://github.com/PoutineSyropErable/config_nvim</a>
</pre>

![Example of zsh config Image](zzz_Example.png)
(The look is from powerlevel-10k, I didn't write it. This is just an install script)

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
./zsh_clone_command.sh # clones oh-my-zsh and powerlevel-10k and other things
./package_install_commands.sh
# This also install a bunch of packages, look at it. It's a system wide install, you'll need
# admin privilede. It's supposed to just work for mac and arch. (I use arch only, mac was for friends)
# So, it should work on mac.

# Backup existing ~/.zshrc if it exists, using numbered backups
[ -f ~/.zshrc ] && mv --backup=numbered ~/.zshrc ~/.zshrc.bak
# Create a symbolic link only if the cloned .zshrc exists
ln -s ~/.config/zsh/.zshrc ~/.zshrc


# ----- Optional --------
./install_lf_config.sh
# ----- End of Optional -----


#mkdir -p $HOME/MainPython_Virtual_Environment # Old one, for pip venv, deprecated.
mkdir -p $HOME/PythonVenv                     # New one, for pip venv
python3 -m venv "$HOME/PythonVenv/pip_venv/"
source "$HOME/PythonVenv/pip_venv/bin/activate"
#btw, if your system is dumb like mac, you should add a softlink so
# python -> python3


pip install virtualenvwrapper
[ -f ~/.p10k.zsh ] && mv --backup=numbered ~/.p10k.zsh ~/.p10k.zsh.bak
ln -s ~/.config/zsh/.p10k.zsh ~/.p10k.zsh

zsh

printf -- "\n\n=====You are done=====\n\n" ; sleep 2

# to reconfigure powerlevel-10k: (The things which give the look) [ I give you my look]
p10k configure
# or my alias
change_look

```

then copy the commands from install commands.sh

Aka: check ./install_commands.sh, but don't really execute it. Maybe executing it will work, you'll most likely have to copy and paste
it's content one line at a time.
