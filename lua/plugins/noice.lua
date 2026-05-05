return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		{
			"rcarriga/nvim-notify",
			opts = {
				-- Use the Rose Pine background from your Alacritty config
				background_colour = "#191724",
				-- Optional: "static" stages look better if you have Alacritty opacity set
				stages = "static",
				timeout = 2000,
				render = "wrapped-compact", -- "compact" or "wrapped-compact" feels less spammy
			},
		},
	},
	opts = {
		-- 1. LSP Configuration
		lsp = {
			-- override markdown rendering so they look better with your font
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			-- disable lsp_progress if you already use fidget.nvim
			progress = { enabled = false },
			signature = { enabled = false }, -- This is the most "spammy" feature
		},
		-- 2. Routing logic to stop the spam
		routes = {
			{
				-- Hide "written" messages (the most common spam)
				filter = {
					event = "msg_show",
					kind = "",
					find = "written",
				},
				opts = { skip = true },
			},
			{
				-- Redirect search_count and other small messages to a tiny "mini" view
				filter = {
					event = "msg_show",
					any = {
						{ find = "search hit BOTTOM" },
						{ find = "search hit TOP" },
						{ find = "pattern not found" },
					},
				},
				view = "mini",
			},
		},
		-- 3. UI Presets for a leaner look
		presets = {
			bottom_search = false, -- puts search at the bottom like a normal terminal
			command_palette = true, -- positions the cmdline at the top-center (modern)
			long_message_to_split = true, -- long messages go to a split instead of a popup
			inc_rename = false, -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = true, -- add a border to hover docs and signature help
		},
		-- 4. Views customization
		views = {
			cmdline_popup = {
				position = { row = "50%", col = "50%" },
				size = { width = 80, height = "auto" },
			},
			popupmenu = {
				relative = "editor",
				position = { row = 8, col = "50%" },
				size = { width = 60, height = 10 },
				border = { style = "rounded", padding = { 0, 1 } },
				win_options = { winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" } },
			},
		},
	},
}
