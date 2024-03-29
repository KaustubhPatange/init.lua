#!/bin/sh

sudo apt -y install git ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
git clone -b release-0.9 --depth 1 https://github.com/neovim/neovim
cd neovim
make CMAKE_BUILD_TYPE=Release
sudo make install
cd ..
rm -rf neovim
