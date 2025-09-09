return {
	"github/copilot.vim",
	config = function()
		vim.keymap.set("n", "<leader>c", "<cmd>Copilot panel<CR>", { silent = true })
	end,
}
