return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = function()
		-- vim.opt.cmdheight = 0
		-- vim.opt.showcmd = false
		-- vim.opt.showmode = false
		-- vim.opt.laststatus = 3

		local function show_macro_recording()
			local recording_register = vim.fn.reg_recording()
			if recording_register == "" then
				return ""
			else
				return "󰑋  Recording @" .. recording_register
			end
		end
		-- refresh lualine when recording starts or stops to update the statusline with the recording status
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
					{
						"mode",
						fmt = function(str)
							-- Mapping modes to specific icons
							local mode_map = {
								["NORMAL"] = "", -- Neovim Icon
								["INSERT"] = "󰏫", -- Pencil/Edit Icon
								["VISUAL"] = "󰈈", -- Eye/View Icon
								["V-LINE"] = "󰈈 ", -- Eye + Lines
								["V-BLOCK"] = "󰈈 󰒙", -- Eye + Block
								["SELECT"] = "󰒃", -- Cursor/Selection
								["REPLACE"] = "󰛔", -- Swap/Replace Icon
								["COMMAND"] = "", -- Command Terminal Icon
								["TERMINAL"] = "", -- Terminal Icon
							}
							return mode_map[str] or str
						end,
					},
				},
				lualine_b = {
					"branch",
					"diff",
					{
						show_macro_recording,
						color = { fg = "#eb6f92", gui = "bold" },
					},
				},
				lualine_c = {
					{
						current_command,
						color = { fg = "#f6c177", gui = "bold" }, -- Rose Pine Gold
					},
					{
						"filename",
						cond = function()
							return vim.fn.getcmdline() == ""
						end,
					},
				},
				lualine_x = { "diagnostics", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		}
	end,
}
