Install: 
  - gcc compiler
    Command Line Tools for Xcode for Mac
    apt install build-essential for Linux
  - Nodejs
  - Live Grep for telescope [here](https://github.com/BurntSushi/ripgrep)
  - Install Nvim 7+
  
  - Mac install:
    homebrew install neovim

  - Linux install:
    sudo apt-get install software-properties-common
    sudo add-apt-repository ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install neovim

  - Run PlugInstall
  - Install coc langauges
    coc-clangd: c/c++
    coc-json: json
    coc-sumneko-lua: lua
    coc-tsserver: javascript
    coc-snippets
    coc-go: go-lang
    coc-pyright: python

Usefull Links:

  https://www.digitalocean.com/community/tutorials/how-to-install-the-anaconda-python-distribution-on-ubuntu-22-04
  https://vi.stackexchange.com/questions/37453/installing-neovim-0-7-on-ubuntu


Error issue with pyright and opencv
# pyright: reportUndefinedVariable=false, reportGeneralTypeIssues=false
