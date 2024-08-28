call plug#begin()
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8'}
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'

" Colorscheme
Plug 'rebelot/kanagawa.nvim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'nyoom-engineering/oxocarbon.nvim'
Plug 'rockerBOO/boo-colorscheme-nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'feline-nvim/feline.nvim'
Plug 'f-person/git-blame.nvim'
Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive'

" Debugging
Plug 'rcarriga/nvim-notify'

" LSP Support
Plug 'neovim/nvim-lspconfig'                           " Required
Plug 'williamboman/mason.nvim', {'do': ':MasonUpdate'} " Optional
Plug 'williamboman/mason-lspconfig.nvim'               " Optional

" Autocompletion
Plug 'hrsh7th/nvim-cmp'     " Required
Plug 'hrsh7th/cmp-nvim-lsp' " Required
Plug 'L3MON4D3/LuaSnip'     " Required

Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v2.x'}

" Wiki and Calendar
Plug 'vimwiki/vimwiki'
call plug#end()

lua require('config')

highlight Normal ctermbg=none
highlight NonText ctermbg=none

autocmd vimenter * ++nested colorscheme kanagawa
" autocmd vimenter * ++nested colorscheme catppuccin-frappe
autocmd vimenter * ++nested set number
autocmd vimenter * ++nested set relativenumber
autocmd vimenter * ++nested highlight Normal ctermbg=none guibg=none
autocmd vimenter * ++nested highlight NormalNC ctermbg=none guibg=none
autocmd vimenter * ++nested highlight NonText ctermbg=none
autocmd BufRead,BufNewFile Jenkinsfile set filetype=groovy
autocmd BufRead,BufNewFile Jenkinsfile.* set filetype=groovy

let mapleader = " "
syntax enable
set t_Co=256
set nowrap
set mouse=a
set splitbelow
set splitright
set shiftwidth=2
set tabstop=2
set expandtab
set smartindent
set autoindent
set cursorline
set updatetime=50
set clipboard=unnamedplus
set noshowmode
set noshowcmd
set scrolloff=20
set nobackup
set colorcolumn=80

au! BufWritePost $MYVIMRC source %

set nocompatible
filetype plugin on
syntax on

" Spotify Stuff
nnoremap <leader>sl <cmd>lua require'spotify'.List()<cr>
nnoremap <leader>sps <cmd>lua require'spotify'.Pause()<cr>
nnoremap <leader>spp <cmd>lua require'spotify'.Play()<cr>
nnoremap <leader>spn <cmd>lua require'spotify'.Next()<cr>
nnoremap <leader>spa <cmd>lua require'spotify'.AddtoQueue()<cr>
nnoremap <leader>spt <cmd>lua require'spotify'.CurrentTrack()<cr>
nnoremap <leader>spu <cmd>silent !source ~/.zshrc && spotify vol up<cr>
nnoremap <leader>spd <cmd>silent !source ~/.zshrc && spotify vol down<cr>

" Color scheme
nnoremap <leader>fc <cmd> lua require'colorpicker'.ColorPicker()<cr>

" Git Fugitive
nnoremap <leader>gs <cmd>Git<CR>

" Undo Tree
nnoremap <leader>ut <cmd>UndotreeToggle<CR>

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fs <cmd>Telescope find_files hidden=true no_ignore=true<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fd <cmd>TodoTelescope <cr>

" No Escape
inoremap jk <Esc>
inoremap kj <Esc>

" Better Save and Quit
nnoremap <leader>w <cmd>w<cr>
nnoremap <leader>q <cmd>q<cr>
nnoremap <leader>wq <cmd>wq<cr>

" Window Splitting
nnoremap <leader>vsp <cmd>vsp<cr>
nnoremap <leader>sp <cmd>sp<cr>
nnoremap <leader>nt <cmd>tabnew<cr>

" Term Enter / Exit
nnoremap <leader>t <cmd>term<cr>
tnoremap <leader>tq <C-\><C-n>

" Window Resizing
nnoremap <S-j> <cmd>res +5<cr>
nnoremap <S-h> <cmd>vert res +5<cr>
nnoremap <S-k> <cmd>res -5<cr>
nnoremap <S-l> <cmd>vert res -5<cr>

" Window moving
nnoremap <leader>l <C-w>l
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k

" Better Tabbing
vnoremap < <gv
vnoremap > >gv

" NvimTree
nnoremap <leader>nn <cmd>NvimTreeToggle<cr>

" Quickly edit/reload this configuration file
nnoremap gev :e $MYVIMRC<CR>
nnoremap gvs :so $MYVIMRC<CR>

if has("persistent_undo")
   let target_path = expand('~/.undodir')

    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif

    let &undodir=target_path
    set undofile
endif
