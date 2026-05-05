local lualine_require = require("lualine_require")
local M = lualine_require.require("lualine.component"):extend()

function M:update_claude_usage()
	-- IMPORTANT: 'self' is lost inside jobstart callbacks.
	-- We store it in a local variable so the callbacks can "see" it.
	local component = self
	local cmd = "python3 " .. self.options.tracker_path

	vim.fn.jobstart(cmd, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if not data then
				return
			end
			for _, line in ipairs(data) do
				if line:find("GRAND TOTAL") and line:find("%$") then
					local cost = line:match("%$%s*([%d%.]+)")
					if cost then
						-- Update the component's state
						component.claude_total_cost = "" .. cost
					end
				end
			end
		end,
		on_exit = function()
			-- Refresh lualine once the data is fetched
			require("lualine").refresh({ place = { "statusline" } })
		end,
	})
end

function M:init(options)
	-- 1. Initialize the super class
	M.super.init(self, options)

	-- 2. Use options for flexibility (with defaults)
	self.options.tracker_path = options.tracker_path
		or vim.fn.expand("~/root/assist/sefaira/tools/claude-usage-tracker.py")
	self.claude_total_cost = "-.--"

	-- 3. Trigger the first run
	self:update_claude_usage()

	-- 4. Setup the timer
	self.timer = vim.loop.new_timer()
	-- We must wrap the call to ensure 'self' is passed correctly every 5 mins
	self.timer:start(
		300000,
		300000,
		vim.schedule_wrap(function()
			self:update_claude_usage()
		end)
	)
end

-- 5. Lualine specifically looks for 'update_status', not 'get_claude_cost'
function M:update_status()
	return "󱙺 " .. self.claude_total_cost
end

return M
