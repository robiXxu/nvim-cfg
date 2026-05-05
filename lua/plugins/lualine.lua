return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = {
		options = {
			theme = "horizon",
			section_separators = { left = "", right = "" },
			component_separators = { left = "", right = "" },
		},
		sections = {
			lualine_a = {
				{
					"mode",
					fmt = function(str)
						-- Mapping modes to specific icons
						local mode_map = {
							["NORMAL"] = "", -- Neovim Icon
							["INSERT"] = "󰏫", -- Pencil/Edit Icon
							["VISUAL"] = "󰈈", -- Eye/View Icon
							["V-LINE"] = "󰈈 ", -- Eye + Lines
							["V-BLOCK"] = "󰈈 󰒙", -- Eye + Block
							["SELECT"] = "󰒃", -- Cursor/Selection
							["REPLACE"] = "󰛔", -- Swap/Replace Icon
							["COMMAND"] = "", -- Command Terminal Icon
							["TERMINAL"] = "", -- Terminal Icon
						}
						return mode_map[str] or str
					end,
				},
			},
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = { "filename" },
			lualine_x = { "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
	},
}
