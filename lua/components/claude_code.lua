local lualine_require = require("lualine_require")
local M = lualine_require.require("lualine.component"):extend()

function M:init(options)
	M.super.init(self, options)

	-- Your custom highlight groups
	self.options.bg = options.bg or "NONE"
	self.options.cl_colors = options.cl_colors
		or {
			ClaudeIdle = { fg = "#6C6F93", bg = self.options.bg },
			ClaudeThinking = { fg = "#f6c177", bg = self.options.bg, bold = true },
			ClaudeStreaming = { fg = "#29D398", bg = self.options.bg, bold = true },
			ClaudeTool = { fg = "#21BFC2", bg = self.options.bg, bold = true },
			ClaudeError = { fg = "#E95678", bg = self.options.bg, bold = true },
		}

	for name, opts in pairs(self.options.cl_colors) do
		vim.api.nvim_set_hl(0, name, opts)
	end
end

function M:update_status()
	local ok, claude = pcall(require, "claude-code")
	if not ok then
		return ""
	end

	-- Fetch state from greggh/claude-code.nvim API
	local status_data = claude.get_status and claude.get_status() or { status = "offline" }
	local state = status_data.status

	local config = {
		idle = { icon = "󰚩", hl = "ClaudeIdle", label = "Claude" },
		thinking = { icon = "󱜸", hl = "ClaudeThinking", label = "Thinking" },
		generating = { icon = "󰊳", hl = "ClaudeStreaming", label = "Streaming" },
		tool = { icon = "󰒓", hl = "ClaudeTool", label = "Tool" },
		error = { icon = "󰅚", hl = "ClaudeError", label = "Error" },
		offline = { icon = "󰚩", hl = "ClaudeIdle", label = "Off" },
	}

	local active = config[state] or config.idle

	-- Display model name (Handy for AWS Bedrock)
	local model_info = ""
	if status_data.model and state ~= "offline" then
		local m = status_data.model:match("([^/]+)$") or status_data.model
		model_info = string.format(" [%s]", m:sub(1, 10))
	end

	return string.format("%%#%s#%s %s%s", active.hl, active.icon, active.label, model_info)
end

return M
