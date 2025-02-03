check ./install_commands.sh, but don't really execute it. Maybe executing it will work, you'll most likely have to copy and paste
it's content one line at a time.

Also, to install do:

```
git clone https://github.com/PoutineSyropErable/config_zsh ~/.config/zsh

mv ~/.zshrc ~/.zshrc.bak # create a backup of your old zshrc

ln -s ~/.config/zsh/.zshrc ~/.zshrc

zsh
```

then copy the commands from install commands.sh
