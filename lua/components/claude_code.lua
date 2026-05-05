local lualine_require = require("lualine_require")
local M = lualine_require.require("lualine.component"):extend()

function M:init(options)
	M.super.init(self, options)

	self.options.bg = options.bg or "#232530"
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
	local ok, original_comp = pcall(require, "lualine.components.claudecode")
	if ok then
		-- Initialize the original component inside our custom one
		self.internal_comp = original_comp:new(options)
	end
end

function M:update_status()
	if not self.internal_comp then
		return ""
	end

	-- 1. Get the raw string from the original component
	-- (e.g., "%#Comment#⠋ 󰙺 Claude [thinking]")
	local str = self.internal_comp:update_status()

	-- 2. Get the current state from the ClaudeCode API
	local ok, claudecode = pcall(require, "claudecode")
	if not ok then
		return str
	end
	local state = claudecode.get_state()

	-- 3. Map the state to your custom Claude-only highlight groups
	-- These are the groups we defined in your init.lua
	local hl_map = {
		idle = "ClaudeIdle",
		thinking = "ClaudeThinking",
		streaming = "ClaudeStreaming",
		tool_use = "ClaudeTool",
		error = "ClaudeError",
	}
	local target_hl = hl_map[state] or "ClaudeIdle"

	-- 4. Search and replace the component's hardcoded highlights
	-- This swaps out things like %#Comment# for %#ClaudeThinking#
	return str:gsub("%%#(.-)#", "%%#" .. target_hl .. "#")
end

return M
