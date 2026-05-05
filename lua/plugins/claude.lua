return {
	"douglasjordan2/claudecode.nvim",
	build = function()
		require("claudecode.build").install()
	end,
	dependencies = {
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			-- config = function()
			-- 	-- Tracking Claude usage
			-- 	local CLAUDE_TRACKER_PATH = "~/root/assist/sefaira/tools/claude-usage-tracker.py"
			-- 	local claude_total_cost = "$-.--"
			--
			-- 	local function update_claude_usage()
			-- 		local cmd = "python3 " .. CLAUDE_TRACKER_PATH .. " --all"
			--
			-- 		-- Run as a background job so Neovim doesn't freeze
			-- 		vim.fn.jobstart(cmd, {
			-- 			stdout_buffered = true,
			-- 			on_stdout = function(_, data)
			-- 				if not data then
			-- 					return
			-- 				end
			-- 				-- Look for the line containing "SUBTOTAL" or "GRAND TOTAL"
			-- 				for _, line in ipairs(data) do
			-- 					if line:find("TOTAL") and line:find("%$") then
			-- 						-- Extract the dollar amount (e.g., $1.23)
			-- 						local cost = line:match("%$%d+%.%d+")
			-- 						if cost then
			-- 							claude_total_cost = cost
			-- 						end
			-- 					end
			-- 				end
			-- 			end,
			-- 			on_exit = function()
			-- 				require("lualine").refresh({ place = { "statusline" } })
			-- 			end,
			-- 		})
			-- 	end
			--
			-- 	update_claude_usage()
			-- 	local claude_cost_timer = vim.loop.new_timer()
			-- 	claude_cost_timer:start(0, 300000, vim.schedule_wrap(update_claude_usage)) -- 300,000ms = 5 mins
			--
			-- 	require("lualine").setup({
			-- 		sections = {
			-- 			lualine_x = {
			-- 				"claudecode",
			-- 				{
			-- 					function()
			-- 						return "🪙 " .. claude_total_cost
			-- 					end,
			-- 					color = { fg = "#f6c177", gui = "bold" }, -- Horizon Gold
			-- 					on_click = function()
			-- 						-- Optional: Clicking the cost runs the script in a terminal
			-- 						vim.cmd("split | term python3 " .. CLAUDE_TRACKER_PATH .. " --daily")
			-- 					end,
			-- 				},
			-- 				"encoding",
			-- 				"fileformat",
			-- 				"filetype",
			-- 			},
			-- 		},
			-- 	})
			-- end,
		},
	},
	config = function()
		require("claudecode").setup({
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
				toggle = "<leader>cc", -- toggle chat window
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
			permission_mode = "mode", -- permission mode for claude CLI
			binary_path = nil, -- custom path to bridge binary
		})
	end,
}
-- return {
-- 	"greggh/claude-code.nvim",
-- 	dependencies = {
-- 		"nvim-lua/plenary.nvim", -- Required for git operations
-- 	},
-- 	config = function()
-- 		require("claude-code").setup({
-- 			-- Terminal window settings
-- 			window = {
-- 				split_ratio = 0.3, -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
-- 				position = "float", -- Position of the window: "botright", "topleft", "vertical", "float", etc.
-- 				enter_insert = true, -- Whether to enter insert mode when opening Claude Code
-- 				hide_numbers = true, -- Hide line numbers in the terminal window
-- 				hide_signcolumn = true, -- Hide the sign column in the terminal window
--
-- 				-- Floating window configuration (only applies when position = "float")
-- 				float = {
-- 					width = "80%", -- Width: number of columns or percentage string
-- 					height = "80%", -- Height: number of rows or percentage string
-- 					row = "center", -- Row position: number, "center", or percentage string
-- 					col = "center", -- Column position: number, "center", or percentage string
-- 					relative = "editor", -- Relative to: "editor" or "cursor"
-- 					border = "rounded", -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
-- 				},
-- 			},
-- 			-- File refresh settings
-- 			refresh = {
-- 				enable = true, -- Enable file change detection
-- 				updatetime = 100, -- updatetime when Claude Code is active (milliseconds)
-- 				timer_interval = 1000, -- How often to check for file changes (milliseconds)
-- 				show_notifications = true, -- Show notification when files are reloaded
-- 			},
-- 			-- Git project settings
-- 			git = {
-- 				use_git_root = true, -- Set CWD to git root when opening Claude Code (if in git project)
-- 			},
-- 			-- Shell-specific settings
-- 			shell = {
-- 				separator = "&&", -- Command separator used in shell commands
-- 				pushd_cmd = "pushd", -- Command to push directory onto stack (e.g., 'pushd' for bash/zsh, 'enter' for nushell)
-- 				popd_cmd = "popd", -- Command to pop directory from stack (e.g., 'popd' for bash/zsh, 'exit' for nushell)
-- 			},
-- 			-- Command settings
-- 			command = "claude", -- Command used to launch Claude Code
-- 			-- Command variants
-- 			command_variants = {
-- 				-- Conversation management
-- 				continue = "--continue", -- Resume the most recent conversation
-- 				resume = "--resume", -- Display an interactive conversation picker
--
-- 				-- Output options
-- 				verbose = "--verbose", -- Enable verbose logging with full turn-by-turn output
-- 			},
-- 			-- Keymaps
-- 			keymaps = {
-- 				toggle = {
-- 					normal = "<C-,>", -- Normal mode keymap for toggling Claude Code, false to disable
-- 					terminal = "<C-,>", -- Terminal mode keymap for toggling Claude Code, false to disable
-- 					variants = {
-- 						continue = "<leader>mm", -- Normal mode keymap for Claude Code with continue flag
-- 						verbose = "<leader>cV", -- Normal mode keymap for Claude Code with verbose flag
-- 					},
-- 				},
-- 				window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
-- 				scrolling = true, -- Enable scrolling keymaps (<C-f/b>) for page up/down
-- 			},
-- 		})
-- 	end,
-- }
