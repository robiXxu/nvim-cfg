local lualine_require = require("lualine_require")
local M = lualine_require.require("lualine.component"):extend()

function M:init(options)
	M.super.init(self, options)
	vim.api.nvim_create_autocmd("RecordingEnter", {
		callback = function()
			require("lualine").refresh({ place = { "statusline" } })
		end,
	})

	vim.api.nvim_create_autocmd("RecordingLeave", {
		callback = function()
			require("lualine").refresh({ place = { "statusline" } })
		end,
	})
end

function M:update_status()
	if vim.fn.reg_recording() ~= "" then
		return "󰀥  Recording @" .. vim.fn.reg_recording()
	else
		return ""
	end
end

return M
