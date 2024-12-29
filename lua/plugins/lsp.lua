local M = {}

M = {
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, {
				"stylua",
				"selene",
				"luacheck",
				"shellcheck",
				"shfmt",
				"tailwindcss-language-server",
				"typescript-language-server",
				"css-lsp",
				"jdtls", -- Java Language Server
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.servers = vim.tbl_extend("force", opts.servers or {}, {
				cssls = {},
				tailwindcss = {
					root_dir = function(...)
						return require("lspconfig.util").root_pattern(".git")(...)
					end,
				},
				tsserver = {
					root_dir = function(...)
						return require("lspconfig.util").root_pattern(".git")(...)
					end,
					single_file_support = false,
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "literal",
								includeInlayFunctionParameterTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
							},
						},
					},
				},
				html = {},
				yamlls = {
					settings = {
						yaml = {
							keyOrdering = false,
						},
					},
				},
				lua_ls = {
					single_file_support = true,
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							diagnostics = { globals = { "vim" } },
							format = {
								enable = false,
								defaultConfig = {
									indent_style = "space",
									indent_size = "2",
								},
							},
						},
					},
				},
				-- Java configuration
				jdtls = {
					root_dir = function(fname)
						return require("lspconfig.util").root_pattern("pom.xml", "build.gradle", ".git")(fname)
					end,
					cmd = { "jdtls" },
					settings = {
						java = {
							home = "/usr/lib/jvm/java-17-openjdk", -- Adjust to your Java installation path
							configuration = {
								runtimes = {
									{
										name = "JavaSE-17",
										path = "/usr/lib/jvm/java-17-openjdk",
									},
									{
										name = "JavaSE-11",
										path = "/usr/lib/jvm/java-11-openjdk",
									},
								},
							},
						},
					},
					init_options = {
						workspaceFolders = {
							vim.fn.fnamemodify(vim.fn.getcwd(), ":p"),
						},
					},
				},
			})
		end,
	},
}

return M
