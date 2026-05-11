return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"mxsdev/nvim-dap-vscode-js", -- You can keep this or remove it; it's harmless now that we bypass its setup
		"nvim-neotest/nvim-nio",
	},
	event = "VeryLazy",
	config = function()
		local dap = require("dap")
		dap.set_log_level("DEBUG")
		local dapui = require("dapui")

		-- 1. Initialize the DAP UI
		dapui.setup()

		-- 2. Automatically open/close the DAP UI
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		-- 3. Define the adapter as a SERVER, not an executable
		dap.adapters["pwa-chrome"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = {
					vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
					"${port}",
				},
			},
		}
		-- 3. Manually define the adapter with the correct Mason path
		-- dap.adapters["pwa-chrome"] = {
		-- 	type = "executable",
		-- 	command = "node",
		-- 	args = {
		-- 		-- Using stdpath("data") to safely point to Mason's installation
		-- 		vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
		-- 		"${port}",
		-- 	},
		-- }

		-- 4. Your specific project configurations
		dap.configurations.typescript = {
			{
				type = "pwa-chrome",
				request = "attach",
				name = "Attach to SketchUp (Mac)",
				port = 9222,
				webRoot = "${workspaceFolder}",
				sourceMaps = true,
				sourceMapPathOverrides = {
					["webpack:///./*"] = "${workspaceFolder}/*",
					["webpack:///src/*"] = "${workspaceFolder}/src/*",
				},
				userDataDir = false,
			},
		}

		-- Replicate for javascript
		dap.configurations.javascript = dap.configurations.typescript

		-- 5. Keymaps
		vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
		vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP Continue" })
		vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Step Over" })
		vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
		vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
	end,
}
