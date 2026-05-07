return {
	"douglasjordan2/claudecode.nvim",
	build = function()
		require("claudecode.build").install()
	end,
	dependencies = {
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},
	},
	config = function()
		local claudecode = require("claudecode")

		claudecode.setup({
			ui = {
				mode = "float", -- "split" or "float"
				split_width = 80, -- width of split panel
				float_width = 0.7, -- float width (0-1 = fraction, >1 = pixels)
				float_height = 0.8, -- float height (0-1 = fraction, >1 = pixels)
				border = "rounded", -- border style for float windows
				input_min_height = 2, -- minimum height of the input box
				input_max_height = 10, -- maximum height of the input box
			},
			keymaps = {
				-- toggle = "<leader>cc", -- toggle chat window
				send = "<leader>cs", -- focus input
				context = "<leader>cx", -- send with file context
				visual = "<leader>cv", -- send visual selection
				inline_edit = "<leader>ce", -- inline edit selection
				abort = "<leader>ca", -- abort current request
				accept_diff = "<leader>cy", -- accept diff in diff viewer
				reject_diff = "<leader>cn", -- reject diff in diff viewer
				sessions = "<leader>cl", -- list/resume sessions
			},
			statusline = {
				icons = {
					idle = "󰚩",
					thinking = "󱜸",
					streaming = "󰊳",
					tool_use = "󰒓",
					error = "󰅚",
				},
			},
			truncation = {
				tool_result = 120, -- max length for tool result display
				command = 60, -- max length for command display
			},
			model = nil, -- override Claude model
			allowed_tools = nil, -- restrict available tools
			append_system_prompt = nil, -- append to system prompt
			permission_mode = nil, -- permission mode for claude CLI
			binary_path = nil, -- custom path to bridge binary
		})
		-- 3. The "Smart Root" logic
		-- This function searches upwards for .claude or .git
		local function open_claude_at_root()
			local root = vim.fs.root(0, { ".claude" })
			if root then
				vim.api.nvim_set_current_dir(root)
			end

			vim.cmd("Claude")
		end

		-- 4. Bind your toggle key to the smart function
		vim.keymap.set("n", "<leader>cc", open_claude_at_root, { desc = "Claude (Smart Root)" })
	end,
}
