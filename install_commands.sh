# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k 
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k


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


git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

pip install virtualenvwrapper

mkdir -p $HOME/MainPython_Virtual_Environment


