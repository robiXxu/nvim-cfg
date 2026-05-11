return {
	"greggh/claude-code.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-lualine/lualine.nvim",
	},
	config = function()
		local claude = require("claude-code")

		claude.setup({
			-- Terminal window settings
			window = {
				position = "float", -- Use floating window for better focus
				-- split_ratio = 0.3,
				-- position = "botright", -- Bottom split for a "panel" feel
				enter_insert = true,
				hide_numbers = true,
				hide_signcolumn = true,
				float = {
					width = "80%",
					height = "80%",
					border = "rounded",
				},
			},
			-- File refresh settings
			refresh = {
				enable = true,
				updatetime = 100,
				timer_interval = 1000,
				show_notifications = true,
			},
			-- Git project settings
			git = {
				use_git_root = true, -- Auto-roots to project for @codebase context
			},
			-- Statusline integration for our custom component
			statusline = {
				enabled = true,
				updates = true,
			},
			-- Command settings
			command = "claude",
			command_variants = {
				continue = "--continue",
				resume = "--resume",
				verbose = "--verbose",
			},
			-- Internal Keymaps
			keymaps = {
				toggle = {
					normal = "<leader>cc",
					terminal = "<C-,>", -- Quick escape
					variants = {
						continue = "<leader>cC",
						resume = "<leader>cl",
					},
				},
				window_navigation = true,
				scrolling = true,
			},
		})

		-- --- ADVANCED CUSTOM KEYMAPS ---
		vim.keymap.set("n", "<leader>cs", function()
			claude.setup({ window = { position = "vertical" } })
			claude.toggle()
		end, { desc = "Claude: Sidebar" })

		-- KEYMAP: Floating Window Toggle
		-- vim.keymap.set("n", "<leader>cf", function()
		-- 	claude.setup({ window = { position = "float" } })
		-- 	claude.toggle()
		-- end, { desc = "Claude: Float" })

		-- 1. Context: Copy relative path and open Claude
		-- Useful for Bedrock: "/add <path>"
		vim.keymap.set("n", "<leader>cx", function()
			local path = vim.fn.expand("%:.")
			vim.fn.setreg("+", path)
			vim.notify("Path copied: " .. path .. ". Use /add in Claude.")
			claude.toggle()
		end, { desc = "Claude: Add File Context" })

		-- 2. Visual: Send selection to Claude via clipboard
		vim.keymap.set("v", "<leader>cv", function()
			vim.cmd('normal! "yy')
			claude.toggle()
			vim.notify("Selection copied. Paste into Claude.")
		end, { desc = "Claude: Send Selection" })

		-- 3. Kill: Force stop the session (Reset Bedrock if it hangs)
		vim.keymap.set("n", "<leader>ck", function()
			claude.stop()
			vim.notify("Claude session killed.", vim.log.levels.WARN)
		end, { desc = "Claude: Kill Session" })
	end,
}
