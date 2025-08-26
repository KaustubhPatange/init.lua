#!/bin/sh

root_user=$(id -un 0)
current_user=$(whoami)

append_sudo=""
if [ "$root_user" != "$current_user" ]; then
  append_sudo="sudo"
fi

$append_sudo apt -y install git ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
git clone -b v0.11.0 --depth 1 https://github.com/neovim/neovim
cd neovim
make CMAKE_BUILD_TYPE=Release
$append_sudo make install
cd ..
rm -rf neovim

# Clone the config
if [ -e ~/.config/nvim ]; then
  mv ~/.config/nvim ~/.config/nvim.bak
fi

git clone https://github.com/KaustubhPatange/init.lua ~/.config/nvim

# Install ripgrep
$append_sudo apt install ripgrep
