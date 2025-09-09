return { -- Autoformat
	"sbdchd/neoformat",
	event = { "BufWritePre" },
	cmd = { "Neoformat" },
	keys = {
		{
			"<leader>f",
			":Neoformat<CR>",
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	config = function()
		-- Enable format-on-save
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function()
				-- Disable format-on-save for specific filetypes
				local disable_filetypes = { c = true, cpp = true, yml = true, yaml = true, javascript = true }
				if not disable_filetypes[vim.bo.filetype] then
					vim.cmd("Neoformat")
				end
			end,
		})
	end,
}
