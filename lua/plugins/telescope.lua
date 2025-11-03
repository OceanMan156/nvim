return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.8',
	dependencies = {
		'nvim-lua/plenary.nvim'
	},
  	lazy = true,
	keys = {
            { "<leader>ff", function() require("telescope.builtin").find_files() end, desc="Find: Files" },
            { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc="Find: Files" },
            { "<leader>fb", function() require("telescope.builtin").buffers() end, desc="Find: Files" },
            { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc="Find: Files" },
    	},
	config = function()
	    local actions = require("telescope.actions")
	    require("telescope").setup {
		    defaults = {
		    },
	    }
	end
}

