vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true
require("nvim-tree").setup()

require'nvim-treesitter.configs'.setup {
   ensure_installed = { "c", "rust", "lua", "javascript", "go", "vim" },
	 hightlight = {enable = true,},
	 indent = {enable = true,},
}
require('feline').setup()
require('feline').winbar.setup()

local lsp = require('lsp-zero').preset({})
lsp.ensure_installed ({
   'tsserver'
})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  preselect = 'item',
	completion = {
    completeopt = 'menu,menuone,noinsert'
	},
  window = {
    completion = cmp.config.window.bordered({
      border = "double",
    }),
  },
  mapping = {
    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({select = false}),
		['<Tab>'] = cmp_action.tab_complete(),

    -- Ctrl+Space to trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
  }
})
