return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "douglasjordan2/claudecode.nvim" },
	event = "VeryLazy",
	opts = function()
		local claude_usage = require("../components/claude_cost")
		local claude_code = require("../components/claude_code")
		local macro_recording = require("../components/macro_recording")
		local mode_icons = require("../components/mode_icons")
		local file_icon = require("../components/file_icon")

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

		vim.api.nvim_set_hl(0, "StatusLine", { bg = "none", ctermbg = "none" })
		vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none", ctermbg = "none" })
		local custom_transparent_theme = {
			normal = {
				a = { fg = "#81a1c1", bg = "none", gui = "bold" },
				b = { fg = "#d8dee9", bg = "none" },
				c = { fg = "#d8dee9", bg = "none" },
			},
			insert = { a = { fg = "#b48ead", bg = "none", gui = "bold" } },
			visual = { a = { fg = "#ebcb8b", bg = "none", gui = "bold" } },
			replace = { a = { fg = "#bf616a", bg = "none", gui = "bold" } },
			inactive = {
				a = { fg = "#4c566a", bg = "none" },
				b = { fg = "#4c566a", bg = "none" },
				c = { fg = "#4c566a", bg = "none" },
			},
		}

		local sep = ""

		return {
			options = {
				globalstatus = true,
				-- theme = "nord",
				theme = custom_transparent_theme,
				section_separators = { right = sep, left = sep },
				component_separators = { right = sep, left = sep },
			},
			sections = {
				lualine_a = {
					{
						function()
							return ""
						end,
						color = { bg = "#ff2525", fg = "#ffffff", gui = "bold" },
						separator = { left = " ", right = " " },
						padding = { left = 1, right = 1 },
					},
					mode_icons,
				},
				lualine_b = {
					{
						"branch",
						icon = "󰊤",
						color = { fg = "#eb6f92", gui = "bold" },
					},
					{
						"diff",
						color = { fg = "#eb6f92", gui = "bold" },
						symbols = {
							added = " ",
							modified = " ",
							removed = " ",
						},
						diff_color = {
							added = { fg = "#29D398", gui = "bold" },
							modified = { fg = "#FAB795", gui = "bold" },
							removed = { fg = "#E95678", gui = "bold" },
						},
					},
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
						-- separator = { left = "", right = "" },
						color = { bg = "#232530", gui = "bold" },
					},
					{
						claude_usage,
						padding = { left = 1, right = 1 },
						color = { fg = "#f6c177", gui = "bold" },
					},
					{
						file_icon,
						padding = { left = 1, right = 2 },
						color = { gui = "bold" },
					},
					-- "encoding",
					-- "fileformat",
					-- "filetype",
				},
				lualine_y = { "progress" },
				lualine_z = {
					"location",
					{
						function()
							return ""
						end,
						color = { bg = "#ff2525", fg = "#ffffff", gui = "bold" },
						separator = { left = " ", right = " " },
						padding = { left = 1, right = 1 },
					},
				},
			},
		}
	end,
}
