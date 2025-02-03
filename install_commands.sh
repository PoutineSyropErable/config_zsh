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


# maybe brew will failed to install some of them, if it does, just remove it untill it can install as much as possible
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
  lazygit \
  neovim \
  exa \
  jq \
  tree \
  kitty \
  git \
  coreutils \
  xclip \
  curl \
  wget \
  neofetch




mkdir -p $HOME/MainPython_Virtual_Environment


