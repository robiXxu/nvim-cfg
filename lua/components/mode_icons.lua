local lualine_require = require("lualine_require")
local M = lualine_require.require("lualine.component"):extend()

function M:init(options)
	M.super.init(self, options)

	self.mode_map = {
		["n"] = "", -- Neovim Icon
		["i"] = "󰏫", -- Pencil/Edit Icon
		["v"] = "󰈈", -- Eye/View Icon
		["V"] = "󰈈 ", -- Eye + Lines
		["V-BLOCK"] = "󰈈 󰒙", -- Eye + Block
		["s"] = "󰒃", -- Cursor/Selection
		["R"] = "󰛔", -- Swap/Replace Icon
		["c"] = "", -- Command Terminal Icon
		["t"] = "", -- Terminal Icon
		["!"] = "",
	}
end

function M:update_status()
	local m = vim.api.nvim_get_mode().mode
	if self.mode_map[m] == nil then
		return m
	end
	return self.mode_map[m]
end

return M
