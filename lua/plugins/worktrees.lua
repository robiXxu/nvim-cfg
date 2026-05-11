return {
	"ThePrimeagen/git-worktree.nvim",
	dependencies = { "nvim-telescope/telescope.nvim" },
	config = function()
		local worktree = require("git-worktree")
		local telescope = require("telescope")

		worktree.setup()
		telescope.load_extension("git_worktree")

		-- Mappings
		vim.keymap.set("n", "<leader>gw", function()
			telescope.extensions.git_worktree.git_worktrees()
		end, { desc = "Telescope Git Worktrees" })

		vim.keymap.set("n", "<leader>gn", function()
			telescope.extensions.git_worktree.create_git_worktree()
		end, { desc = "Create Git Worktree" })

		vim.keymap.set("n", "<leader>fA", function()
			require("telescope.builtin").find_files({
				cwd = "..", -- Look one level up at all worktrees
				prompt_title = "Find in All Worktrees",
			})
		end, { desc = "Search all worktrees" })

		-- Force everything to sync to the current worktree path
		vim.keymap.set("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", { desc = "Sync CWD to current file" })

		worktree.on_tree_change(function(op, metadata)
			if op == worktree.Operations.Switch then
				-- Close all buffers that aren't the current one to prevent cross-contamination
				vim.cmd("silent bufdo bd")
				print("Cleaned buffers and switched to: " .. metadata.path)
			end
		end)
	end,
}
