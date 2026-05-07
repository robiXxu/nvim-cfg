return {
	"jesseleite/macroni.nvim",
	lazy = false,
	opts = function()
		vim.keymap.set({ "n", "v" }, "<Leader>m", function()
			require("telescope").extensions.macroni.saved_macros()
		end)
		return {
			macros = {
				-- make_todo_list_item = {
				-- 	macro = "^i-<Space>[<Space>]<Space>",
				-- 	keymap = "<Leader>t",
				-- 	mode = { "n", "v" }, -- By default, macros will be mapped to both normal & visual modes
				-- 	desc = "Make a markdown list item!", -- Description for whichkey or similar
				-- },
			},
			-- Your custom options here
		}
		-- All of your `setup(opts)` and saved macros will go here when using lazy.nvim
	end,
}
