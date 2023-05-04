vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

-- Auto Pair setup
require("nvim-autopairs").setup {}

-- Treesitter setup
require("nvim-tree").setup()

require'nvim-treesitter.configs'.setup {
   ensure_installed = { "c", "rust", "lua", "javascript", "go", "vim" },
	 highlight = {enable = true,},
	 indent = {enable = true,},
}

-- Status bar setup
require('feline').setup()
require('feline').winbar.setup()

-- LSP Config
local lsp = require('lsp-zero').preset({})
lsp.ensure_installed ({
   'tsserver',
   'gopls'
})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
lsp.setup()

-- Autocomplete Setup
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

-- Go Debug Adapter
local dap = require('dap')
dap.adapters.delve = {
  type = 'server',
  port = '${port}',
  executable = {
    command = 'dlv',
    args = {'dap', '-l', '127.0.0.1:${port}'},
  }
}
dap.configurations.go = {
  {
    type = 'go';
    name = 'Main';
    request = 'launch';
    program = "${file}";
  },
  {
    type = "delve",
    name = "Debug",
    request = "launch",
    program = "."
  },
}

-- Dap UI Setup
require("dapui").setup()
local dapui = require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
