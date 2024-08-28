local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values

local getSchemes = function ()
  -- Get Schemes in string and remove brackets
  Schemes = vim.api.nvim_command_output("echo getcompletion('', 'color')")
  Schemes = string.sub(Schemes, 2, string.len(Schemes)-1)
  Schemes = vim.trim(Schemes)

  -- Split string into workable table
  Scheme = vim.split(Schemes, ",")
  for key, _ in pairs(Scheme) do
    Scheme[key] = vim.trim(Scheme[key])
    Scheme[key] = string.sub(Scheme[key], 2, string.len(Scheme[key])-1)
  end
end

-- our picker function: colors
local colors = function(opts)
  getSchemes()
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "colorschemes",
    finder = finders.new_table {
      results = Scheme
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd("colorscheme " .. selection[1])
      end)
      return true
    end,
  }):find()
end

local function ColorPicker()
  colors(require("telescope.themes").get_dropdown{})
end

return {
  ColorPicker = ColorPicker
}
