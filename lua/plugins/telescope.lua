local actions = require("telescope.actions")
local lactions = require("telescope.actions.layout")
local finders = require("telescope.builtin")

local Telescope = setmetatable({}, {
	__index = function(_, k)
		if vim.bo.filetype == "NvimTree" then
			vim.cmd.wincmd("l")
		end
		return finders[k]
	end,
})

return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		-- Useful for getting pretty icons, but requires a Nerd Font.
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	opts = {
		defaults = {
			winblend = 0,
			layout_strategy = "vertical",
			file_ignore_patterns = {
				"node_modules",
				"vendor",
				".git",
				".yardoc",
				"doc",
			},
			prompt_prefix = " ❯ ",
			initial_mode = "insert",
			sorting_strategy = "ascending",
			layout_config = {
				prompt_position = "top",
			},
			mappings = {
				i = {
					["<ESC>"] = actions.close,
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
					["<TAB>"] = actions.toggle_selection + actions.move_selection_next,
					["<C-s>"] = actions.send_selected_to_qflist,
					["<C-q>"] = actions.send_to_qflist,
					["<C-h>"] = lactions.toggle_preview,
				},
			},
		},
		extensions = {
			fzf = {
				fuzzy = true,
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- "smart_case" | "ignore_case" | "respect_case"
			},
		},
	},
	keys = {
		{
			"<C-P>",
			Telescope.find_files,
		},
		{
			"<leader>H",
			Telescope.help_tags,
		},
		{
			"'b",
			Telescope.buffers,
		},
		{
			"'w",
			Telescope.grep_strings,
		},
		{
			"'r",
			Telescope.live_grep,
		},
		{
			"'c",
			Telescope.git_status,
		},
	},
}
