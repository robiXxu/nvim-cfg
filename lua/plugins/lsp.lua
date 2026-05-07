return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"ray-x/lsp_signature.nvim",
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {},
		},
	},
	config = function()
		-- 1. Setup Mason
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = { "vtsls", "angularls", "lua_ls" },
		})
		require("lazydev").setup({
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		})

		vim.diagnostic.config({
			virtual_text = {
				prefix = "",
				spacing = 4,
			},
			signs = true,
			underline = true,
			update_in_insert = false, -- Don't flicker errors while typing
			severity_sort = true,
		})
		local lsp_signature = require("lsp_signature")
		lsp_signature.setup({
			bind = true, -- This is mandatory, otherwise border config won't get registered
			handler_opts = {
				border = "rounded",
			},
			hint_enable = true, -- This is the "Virtual Text" part
			hint_prefix = "󰏪 ", -- Icon for the signature
			hint_scheme = "Comment", -- Color for the virtual text (we can change this)
			hi_parameter = "LspSignatureActiveParameter", -- Highlight for current param
			max_height = 12,
			max_width = 80,
			timer_interval = 200,
			extra_trigger_chars = {}, -- Array of extra characters that can trigger signature help
		})

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- VTSLS (TypeScript) with Relative Imports
		vim.lsp.config["vtsls"] = {
			capabilities = capabilities,
			settings = {
				typescript = {
					preferences = {
						importModuleSpecifier = "relative",
						importModuleSpecifierEnding = "minimal",
					},
				},
				javascript = {
					preferences = {
						importModuleSpecifier = "relative",
					},
				},
			},
		}

		vim.lsp.config["eslint"] = {
			capabilities = capabilities,
			settings = {
				eslint = {
					codeAction = {
						disableRuleComment = { enable = true, location = "separateLine" },
						showDocumentation = { enable = true },
					},
				},
			},
		}

		-- Lua
		vim.lsp.config["lua_ls"] = {
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = {
						enable = false,
					},
				},
			},
		}
		local announced_servers = {}
		-- Keybinds (LspAttach)
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(event)
				local opts = { buffer = event.buf }
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

				-- The specific command for vtsls relative imports
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and not announced_servers[client.id] then
					vim.notify("🚀 LSP [" .. client.name .. "] active", vim.log.levels.INFO, {
						title = "LSP Startup",
						timeout = 2000,
					})
					announced_servers[client.id] = true
				end
				if client and client.name == "eslint" then
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = event.buf,
						callback = function()
							-- This is the native equivalent of EslintFixAll
							vim.lsp.buf.code_action({
								context = { only = { "source.fixAll.eslint" } },
								apply = true,
							})
						end,
					})
				end
				if client and client.name == "vtsls" then
					-- 1. Organize Imports (Force Relative)
					vim.keymap.set("n", "<leader>fk", function()
						client.request("workspace/executeCommand", {
							command = "_typescript.organizeImports",
							arguments = { vim.api.nvim_buf_get_name(0) },
						}, function(err)
							if err then
								vim.notify("❌ Failed to organize: " .. err.message, vim.log.levels.ERROR)
							else
								vim.notify("📦 Imports organized (Relative)", vim.log.levels.INFO)
							end
						end)

						client.request("workspace/executeCommand", {
							command = "_typescript.sortImports",
							arguments = { vim.api.nvim_buf_get_name(0) },
						}, function(err)
							if not err then
								vim.notify("🔡 Imports sorted alphabetically", vim.log.levels.INFO)
							end
						end)

						client.request("workspace/executeCommand", {
							command = "_typescript.fixAll",
							arguments = { vim.api.nvim_buf_get_name(0) },
						}, function(err)
							if not err then
								vim.notify("🛠️ Fix All applied", vim.log.levels.INFO)
							end
						end)
					end, { buffer = event.buf, desc = "Unfuck everything" })
				end
			end,
		})
		local ensure_installed = { "stylua", "prettierd" } -- Non-LSP tools
		require("mason-tool-installer").setup({
			ensure_installed = ensure_installed,
			auto_update = true,
			run_on_start = true,
		})
	end,
}
