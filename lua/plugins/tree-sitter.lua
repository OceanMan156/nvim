return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
 		require('nvim-treesitter.install').prefer_git = false
 		require('nvim-treesitter.install').compilers = { "clang" }
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "c", "cpp", "lua" },
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end
}
