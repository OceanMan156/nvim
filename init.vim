call plug#begin()
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'rebelot/kanagawa.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'feline-nvim/feline.nvim'
Plug 'm4xshen/autoclose.nvim'
Plug 'f-person/git-blame.nvim'
Plug 'ms-jpq/lua-async-await', {'branch': 'neo'}

" Debugging
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'

" LSP Support
Plug 'neovim/nvim-lspconfig'                           " Required
Plug 'williamboman/mason.nvim', {'do': ':MasonUpdate'} " Optional
Plug 'williamboman/mason-lspconfig.nvim'               " Optional

" Autocompletion
Plug 'hrsh7th/nvim-cmp'     " Required
Plug 'hrsh7th/cmp-nvim-lsp' " Required
Plug 'L3MON4D3/LuaSnip'     " Required

Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v2.x'}
call plug#end()

lua require('config')
lua require('spotify')

highlight Normal ctermbg=none
highlight NonText ctermbg=none

autocmd vimenter * ++nested colorscheme kanagawa-dragon
autocmd vimenter * ++nested set number
autocmd vimenter * ++nested set relativenumber
autocmd vimenter * ++nested highlight Normal ctermbg=none guibg=none
autocmd vimenter * ++nested highlight NonText ctermbg=none

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

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

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

" Debugging
nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
nnoremap <silent> <F10> <Cmd>lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> <Cmd>lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>
nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.repl.open()<CR>
nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>
tnoremap <Esc> <C-\><C-n>

" Spotify
nnoremap <leader>sl <cmd>lua require'spotify'.List()<cr>
