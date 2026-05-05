return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "douglasjordan2/claudecode.nvim" },
	event = "VeryLazy",
	opts = function()
		local claude_usage = require("../components/claude_cost")
		local claude_code = require("../components/claude_code")
		local macro_recording = require("../components/macro_recording")
		local mode_icons = require("../components/mode_icons")
		local git_info = require("../components/git_info")

		local function current_command()
			local cmd = vim.fn.getcmdline()
			if cmd == "" then
				return ""
			end
			local type = vim.fn.getcmdtype()
			local icon = (type == ":" and " " or (type == "/" and " " or " "))
			return icon .. " " .. cmd
		end
		vim.api.nvim_create_autocmd({ "CmdlineChanged", "CmdlineEnter", "CmdlineLeave" }, {
			callback = function()
				require("lualine").refresh({ place = { "statusline" } })
			end,
		})

		return {
			options = {
				theme = "horizon",
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = {
					mode_icons,
				},
				lualine_b = {
					{
						git_info,
						-- Standard padding/separators for the whole git block
						padding = { left = 1, right = 1 },
					},
					-- { "branch", icon = "" },
					-- {
					-- 	"diff",
					-- 	colored = true,
					-- 	symbols = {
					-- 		added = "󰐙 ",
					-- 		modified = "󰏬 ",
					-- 		removed = " ",
					-- 	},
					-- 	diff_color = {
					-- 		-- Explicitly using Horizon-style colors to make them "pop"
					-- 		added = { fg = "#29D398" }, -- Horizon Green
					-- 		modified = { fg = "#FAB795" }, -- Horizon Orange/Gold
					-- 		removed = { fg = "#E95678" }, -- Horizon Red/Pink
					-- 	},
					-- },
					{
						macro_recording,
						color = { fg = "#eb6f92", gui = "bold" },
					},
				},
				lualine_c = {
					{
						current_command,
						color = { fg = "#f6c177", gui = "bold" },
					},
					{
						"filetype",
						icon_only = true,
						colored = true,
						separator = "",
						padding = { left = 1, right = 0 }, -- Tighten the gap
						cond = function()
							return vim.fn.getcmdline() == ""
						end,
					},
					{
						"filename",
						cond = function()
							return vim.fn.getcmdline() == ""
						end,
						file_status = true, -- Displays file status (readonly, modified)
						newfile_status = false, -- Display new file status (new file means no status)
						path = 0, -- 0: Just filename, 1: Relative path, 2: Absolute path

						-- Customizing the look
						symbols = {
							modified = " 󰏫", -- Icon when file is changed (Pencil)
							readonly = " 󰌾", -- Icon when file is readonly (Lock)
							unnamed = "[No Name]", -- Text for unnamed buffers
							newfile = " 󰝒", -- Icon for new files
						},

						-- Coloring the filename specifically for Horizon
						color = { fg = "#21BFC2", gui = "bold" }, -- Horizon Teal/Cyan
					},
				},
				lualine_x = {
					{
						claude_code,
						-- The rest of your styling stays the same
						separator = { left = "", right = "" },
						color = { bg = "#232530", gui = "bold" },
					},
					{
						claude_usage,
						padding = { left = 1, right = 1 },
						color = { fg = "#f6c177", gui = "bold" },
					},
					-- {
					-- 	function()
					-- 		return "󱙺 " .. claude_total_cost
					-- 	end,
					-- 	padding = { left = 1, right = 1 }, -- Tighten the gap
					-- 	color = { fg = "#f6c177", gui = "bold" }, -- Horizon Gold
					-- 	on_click = function()
					-- 		-- Optional: Clicking the cost runs the script in a terminal
					-- 		vim.cmd("split | term python3 " .. CLAUDE_TRACKER_PATH .. " --daily")
					-- 	end,
					-- },
					"encoding",
					"fileformat",
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		}
	end,
}
