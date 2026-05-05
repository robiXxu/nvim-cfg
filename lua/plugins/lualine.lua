return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "douglasjordan2/claudecode.nvim" },
	event = "VeryLazy",
	opts = function()
		local horizon_bg = "#232530"
		local cl_colors = {
			ClaudeIdle = { fg = "#6C6F93", bg = horizon_bg },
			ClaudeThinking = { fg = "#f6c177", bg = horizon_bg, bold = true },
			ClaudeStreaming = { fg = "#29D398", bg = horizon_bg, bold = true },
			ClaudeTool = { fg = "#21BFC2", bg = horizon_bg, bold = true },
			ClaudeError = { fg = "#E95678", bg = horizon_bg, bold = true },
		}

		for name, opts in pairs(cl_colors) do
			vim.api.nvim_set_hl(0, name, opts)
		end
		-- vim.opt.cmdheight = 0
		-- vim.opt.showcmd = false
		-- vim.opt.showmode = false
		-- vim.opt.laststatus = 3

		-- Tracking Claude usage
		local CLAUDE_TRACKER_PATH = "~/root/assist/sefaira/tools/claude-usage-tracker.py"
		local claude_total_cost = "$-.--"

		local function update_claude_usage()
			local cmd = "python3 " .. CLAUDE_TRACKER_PATH

			-- Run as a background job so Neovim doesn't freeze
			vim.fn.jobstart(cmd, {
				stdout_buffered = true,
				on_stdout = function(_, data)
					if not data then
						return
					end
					for _, line in ipairs(data) do
						if line:find("GRAND TOTAL") and line:find("%$") then
							-- Extract the dollar amount (e.g., $1.23)
							local cost = line:match("%$%s*([%d%.]+)")
							if cost then
								claude_total_cost = "" .. cost
							end
						end
					end
				end,
				on_exit = function()
					require("lualine").refresh({ place = { "statusline" } })
				end,
			})
		end

		update_claude_usage()
		local claude_cost_timer = vim.loop.new_timer()
		claude_cost_timer:start(0, 300000, vim.schedule_wrap(update_claude_usage)) -- 300,000ms = 5 mins

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
					{ "branch", icon = "" },
					{
						"diff",
						colored = true,
						symbols = {
							added = "󰐙 ",
							modified = "󰏬 ",
							removed = " ",
						},
						diff_color = {
							-- Explicitly using Horizon-style colors to make them "pop"
							added = { fg = "#29D398" }, -- Horizon Green
							modified = { fg = "#FAB795" }, -- Horizon Orange/Gold
							removed = { fg = "#E95678" }, -- Horizon Red/Pink
						},
					},
					{
						show_macro_recording,
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
						"claudecode",
						-- fmt intercepts the string after claudecode is done building it
						fmt = function(str)
							-- 1. Get the current state from the ClaudeCode API
							local ok, claudecode = pcall(require, "claudecode")
							if not ok then
								return str
							end

							local state = claudecode.get_state()

							-- 2. Map the state to our custom Claude-only highlight groups
							local hl_map = {
								idle = "ClaudeIdle",
								thinking = "ClaudeThinking",
								streaming = "ClaudeStreaming",
								tool_use = "ClaudeTool",
								error = "ClaudeError",
							}

							local target_hl = hl_map[state] or "ClaudeIdle"

							-- 3. Search and replace the component's hardcoded highlights
							-- This swaps out things like %#Comment# for %#ClaudeIdle#
							return str:gsub("%%#(.-)#", "%%#" .. target_hl .. "#")
						end,

						-- The rest of your styling stays the same
						separator = { left = "", right = "" },
						color = { bg = "#232530", gui = "bold" },
					},
					{
						function()
							return "󱙺 " .. claude_total_cost
						end,
						padding = { left = 1, right = 1 }, -- Tighten the gap
						color = { fg = "#f6c177", gui = "bold" }, -- Horizon Gold
						on_click = function()
							-- Optional: Clicking the cost runs the script in a terminal
							vim.cmd("split | term python3 " .. CLAUDE_TRACKER_PATH .. " --daily")
						end,
					},
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
