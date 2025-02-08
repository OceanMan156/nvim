#!/bin/bash

if [[ "$OSTYPE" == "linux-gnu" ]]; then 
  sudo apt-get install ninja-build gettext cmake curl build-essential
elif [[ "$OSTYPE" == "darwin" ]]; then
  brew install ninja cmake gettext curl
else
  echo "Dont Run this on windows"
  exit 0
fi

echo "Installing NVIM"
git clone https://github.com/neovim/neovim $HOME/neovim
pushd neovim $HOME/neovim

make CMAKE_BUILD_TYPE=Release
sudo make install
