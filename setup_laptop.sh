#!/usr/bin/env bash

set -euo pipefail

mkdir -p ~/bin

sudo apt update
sudo apt purge ubuntu-web-launchers
sudo apt install -y \
    bash-completion \
    build-essential \
    bzip2 \
    curl \
    direnv \
    exuberant-ctags \
    gcc \
    git \
    git-core \
    gnome-shell-extensions \
    gnome-tweak-tool \
    jq \
    libreadline-dev \
    libssl-dev \
    lynx \
    make \
    net-tools \
    openvpn-systemd-resolved \
    rtv \
    silversearcher-ag \
    tilix \
    tmux \
    urlview \
    vim-gnome \
    xclip \
    zlib1g-dev

# Pyenv
test -d ~/.pyenv || git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# Kube prompt
test -f ~/.kube-ps1.sh || curl -LSso ~/.kube-ps1.sh https://raw.githubusercontent.com/jonmosco/kube-ps1/master/kube-ps1.sh

# Git
test -f ~/.git-prompt.sh || curl -LSso ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"

# Docker
UBUNTU_RELEASE=$(lsb_release -cs)
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu ${UBUNTU_RELEASE} stable"
sudo apt install -y docker-ce

# master contains a breaking change, pinning to version 2.17.1
#test -f ~/.git-completion.bash || curl -LSso ~/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
test -f ~/.git-completion.bash || curl -LSso ~/.git-completion.bash https://raw.githubusercontent.com/git/git/v2.17.1/contrib/completion/git-completion.bash

# Linux Brew
test -d /home/linuxbrew || sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

brew tap blendle/blendle
brew tap johanhaleby/kubetail
brew tap wata727/tflint
brew install fzf kns shfmt kubetail tflint

# VIM
test -d ~/.vim || git clone git@github.com:vilelm/vim.git ~/.vim
~/.vim/install_plugins.sh
test -f ~/.vimrc || echo "source ~/.vim/vimrc" >~/.vimrc

# Neovim
#wget -q -O ~/bin/nvim.appimage https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
#chmod u+x ~/bin/nvim.appimage
#mkdir -p ~/.config/nvim
#brew install nvim
#pip install --user neovim
#ln -fs ~/.vim/vimrc ~/.config/nvim/init.vim
#ln -fs ~/.vim/autoload ~/.config/nvim/autoload
#ln -fs ~/.vim/bundle ~/.config/nvim/bundle

sudo update-alternatives --install /usr/bin/vim vim /usr/bin/vim.gtk3 100
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim.gtk3 100
sudo update-alternatives --set vim /usr/bin/vim.gtk3
sudo update-alternatives --set vi /usr/bin/vim.gtk3

# Fix trackpad - https://medium.com/@peterpang_84917/personal-experience-of-installing-ubuntu-18-04-lts-on-xps-15-9570-3e53b6cfeefe
sudo apt-get install -y xserver-xorg-input-libinput
sudo apt-get remove -y --purge xserver-xorg-input-synaptics

# Improve battery life
sudo apt install tlp tlp-rdw powertop
sudo tlp start
sudo powertop --auto-tune

# Set key repeat speed
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 18
gsettings set org.gnome.desktop.peripherals.keyboard delay 250

# Disable avahi-daemon
sudo systemctl mask avahi-daemon.socket
sudo systemctl mask avahi-daemon
sudo systemctl disable avahi-daemon
sudo systemctl disable avahi-daemon.socket
sudo systemctl stop avahi-daemon.socket
sudo systemctl stop avahi-daemon

# Clean up
sudo apt autoremove
