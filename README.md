Idiot you need to install a gcc compiler
You need the newst version of nodejs
You need https://github.com/BurntSushi/ripgrep for live grep
you need the NVIM 7+
  sudo apt-get install software-properties-common
  sudo add-apt-repository ppa:neovim-ppa/stable
  sudo apt-get update
  sudo apt-get install neovim

install pylint locally and generate pylintrc
  
  pylint --generate-rcfile > ${HOME}/.pylintrc

edit pylintrc

  extension-pkg-whitelist=cv2
  argument-naming-style=
  attr-naming-style=
  function-naming-style=
  max-line-length=

