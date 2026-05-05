local lualine_require = require("lualine_require")
local M = lualine_require.require("lualine.component"):extend()

function M:init(options)
	M.super.init(self, options)

	-- Define Horizon colors
	local colors = {
		added = "#29D398",
		modified = "#FAB795",
		removed = "#E95678",
	}

	-- Create our own private highlight groups
	self.highlights = {
		added = self:create_hl({ fg = colors.added }, "git_bundle_added"),
		modified = self:create_hl({ fg = colors.modified }, "git_bundle_modified"),
		removed = self:create_hl({ fg = colors.removed }, "git_bundle_removed"),
	}
end

function M:update_status()
	-- 1. Get the Branch (provided by gitsigns)
	local branch_name = vim.b.gitsigns_head or ""
	if branch_name == "" then
		return ""
	end

	-- 2. Get the Diff Data (provided by gitsigns)
	local gitsigns_dict = vim.b.gitsigns_status_dict
	local diff_str = ""

	if gitsigns_dict then
		local symbols = { added = "󰐙 ", modified = "󰏬 ", removed = " " }
		local parts = {}

		if gitsigns_dict.added and gitsigns_dict.added > 0 then
			table.insert(parts, self:format_hl(self.highlights.added) .. symbols.added .. gitsigns_dict.added)
		end
		if gitsigns_dict.changed and gitsigns_dict.changed > 0 then
			table.insert(parts, self:format_hl(self.highlights.modified) .. symbols.modified .. gitsigns_dict.changed)
		end
		if gitsigns_dict.removed and gitsigns_dict.removed > 0 then
			table.insert(parts, self:format_hl(self.highlights.removed) .. symbols.removed .. gitsigns_dict.removed)
		end

		diff_str = table.concat(parts, " ")
	end

	-- 3. Final Assembly
	-- Icon:  (GitLab)
	local res = " " .. branch_name
	if diff_str ~= "" then
		res = res .. "  " .. diff_str
	end

	return res
end

return M
