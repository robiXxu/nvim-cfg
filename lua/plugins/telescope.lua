local actions = require("telescope.actions")
local lactions = require("telescope.actions.layout")

-- This helper ensures Telescope doesn't open inside the NvimTree window
local Telescope = setmetatable({}, {
	__index = function(_, k)
		if vim.bo.filetype == "NvimTree" then
			vim.cmd.wincmd("l")
		end
		return require("telescope.builtin")[k]
	end,
})

return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- Recommended for performance
	},

	opts = {
		defaults = {
			debug = true,
			winblend = 0,
			layout_strategy = "vertical",
			layout_config = {
				vertical = {
					width = 0.8,
					height = 0.9,
					prompt_position = "top",
				},
			},
			prompt_prefix = " ❯ ",
			selection_caret = "  ",
			initial_mode = "insert",
			sorting_strategy = "ascending",
			file_ignore_patterns = { "node_modules", "vendor", ".git", ".yardoc", "doc" },
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
		-- PICKERS must be inside the opts table
		pickers = {
			marks = {
				attach_mappings = function(prompt_bufnr, map)
					map("i", "<C-d>", function()
						actions.delete_mark(prompt_bufnr)
					end)
					return true
				end,
			},
		},
		extensions = {
			["ui-select"] = {
				require("telescope.themes").get_dropdown(),
			},
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
		},
	},

	-- Configuration function to load extensions
	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)
		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")
	end,

	keys = {
		{ "<C-P>", Telescope.find_files, desc = "Find Files" },
		{ "<leader>H", Telescope.help_tags, desc = "Help Tags" },
		{ "'b", Telescope.buffers, desc = "Buffers" },
		{ "'w", Telescope.grep_string, desc = "Grep Word" },
		{ "'r", Telescope.live_grep, desc = "Live Grep" },
		{ "'c", Telescope.git_status, desc = "Git Status" },
		{ "'m", Telescope.marks, desc = "Marks" },
		{
			"<leader>fa",
			function()
				require("telescope.builtin").find_files({ no_ignore = true, hidden = true })
			end,
			desc = "Find All Files",
		},
		-- Modern Diagnostic view
		{
			"<leader>t",
			Telescope.diagnostics,
			desc = "Workspace Diagnostics",
		},
		-- Search specifically in the Quickfix list
		{
			"<leader>q",
			Telescope.quickfix,
			desc = "Search Quickfix",
		},
	},
}
