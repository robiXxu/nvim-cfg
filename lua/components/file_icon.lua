local lualine_component = require("lualine.component")
local M = lualine_component:extend()

function M:init(options)
	M.super.init(self, options)
	self.devicons = require("nvim-web-devicons")

	-- Define our format mappings
	self.format_icons = {
		unix = "", -- Linux/Unix
		dos = "", -- Windows
		mac = "", -- macOS
	}
end

function M:update_status()
	local ft = vim.bo.filetype
	local fformat = vim.bo.fileformat
	local encoding = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc

	local format_icon = self.format_icons[fformat] or fformat
	local main_icon = ""

	-- Logic for netrw (Directory Preview)
	if ft == "netrw" then
		local curdir = vim.b.netrw_curdir or vim.fn.expand("%:p")
		local icons = {}
		local seen = {}

		-- Scan files in the directory
		local ok, files = pcall(function()
			return vim.fn.readdir(curdir, function(n)
				return #n < 6
			end)
		end)
		if ok then
			for _, file in ipairs(files) do
				local ext = vim.fn.fnamemodify(file, ":e")
				if ext ~= "" and not seen[ext] and #icons < 3 then
					local icon = self.devicons.get_icon(file, ext, { default = false })
					if icon then
						table.insert(icons, icon)
						seen[ext] = true
					end
				end
			end
		end
		main_icon = #icons > 0 and table.concat(icons, " ") or "󰉖"
	else
		-- Logic for standard files
		local icon, _ = self.devicons.get_icon(vim.fn.expand("%:t"), vim.fn.expand("%:e"), { default = true })
		main_icon = icon or "󰈔"
	end

	return string.format("%s", main_icon)
end

return M
