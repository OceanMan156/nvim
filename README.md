## 🎯 Table of Contents  
- [Requirements](#requirements)  
- [Installation](#installation)  

## Requirements  
Before installing, make sure your system meets the following requirements:

### 💻 Optional (Recommended)
- [**ripgrep (`rg`)**](https://github.com/BurntSushi/ripgrep) – Improves file searching (used by telescope)
- [**fd**](https://github.com/sharkdp/fd) – Fast and user-friendly alternative to `find`
- **Node.js** (v16+) – Needed for LSPs and completion plugins (like `mason`)
- **Python 3** – For Python-based plugins (`:checkhealth` will verify)
- **npm**, **pip**, or **cargo** – Depending on language servers or tools you install

### 🧠 Developer Tools
- **LSP servers** – Managed via `mason.nvim` or installed manually  
- **Formatter/Linter binaries** – e.g., `prettier`, `stylua`, `eslint`, etc. 

## Installation  
```bash
# Clone this repo (or your fork) into your Neovim config directory.

```bash
git clone https://github.com/OceanMan156/nvim.git ~/.config/nvim
```

# Run the bootstrap script to install required nvim dependencies

* Script will also clone and build nvim from source *

```bash
cd ~/.config/nvim
./setup.sh
```
