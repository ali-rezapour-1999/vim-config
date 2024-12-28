-- Path: ~/.config/nvim/lua/plugins/lsp.lua
local M = {}

M = {
	"neovim/nvim-lspconfig",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		{
			"williamboman/mason.nvim",
			opts = {
				ensure_installed = {
					"jdtls",
					"java-debug-adapter",
					"java-test",
					"spring-boot-language-server",
					"gradle-language-server",
					"maven-language-server",
					"pyright",
					"pylint",
					"black",
					"isort",
					"debugpy",
					"ruff",
					"mypy",
					"tailwindcss-language-server",
					"typescript-language-server",
					"css-lsp",
					"stylua",
					"selene",
					"luacheck",
					"shellcheck",
					"shfmt",
				},
			},
		},
	},
	config = function()
		local lspconfig = require("lspconfig")
		local on_attach = function(client, bufnr)
			local function map(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
			end

			-- Enhanced LSP Keymaps
			map("n", "<C-G>", vim.lsp.buf.declaration, "Go to Declaration")
			map("n", "<C-k>", function()
				require("telescope.builtin").lsp_definitions({ reuse_win = false })
			end, "Goto Definition")
			map("n", "K", function()
				if not client.server_capabilities.hoverProvider then
					return
				end
				local params = vim.lsp.util.make_position_params()
				client.request("textDocument/hover", params, function(err, result)
					if err or not result or not result.contents then
						return
					end
					vim.lsp.util.open_floating_preview(
						vim.lsp.util.convert_input_to_markdown_lines(result.contents),
						"markdown"
					)
				end, bufnr)
			end, "Hover Documentation")
			map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
			map("n", "ca", vim.lsp.buf.code_action, "Code Action")
			map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
			map("n", "DD", vim.lsp.buf.type_definition, "Type Definition")
			map("n", "gr", require("telescope.builtin").lsp_references, "References")

			-- Additional useful mappings
			map("n", "<leader>f", function()
				vim.lsp.buf.format({ async = true })
			end, "Format")
			map("n", "<leader>sl", require("telescope.builtin").diagnostics, "Show Diagnostics")
			map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
			map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")

			-- Maven specific mappings
			map("n", "<leader>mc", ":!mvn clean<CR>", "Maven Clean")
			map("n", "<leader>mi", ":!mvn install<CR>", "Maven Install")
			map("n", "<leader>mt", ":!mvn test<CR>", "Maven Test")
			map("n", "<leader>mp", ":!mvn package<CR>", "Maven Package")
		end

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
		capabilities.textDocument.completion.completionItem.snippetSupport = true

		-- Get user's home directory
		local home = vim.fn.expand("$HOME")
		local m2_home = home .. "/.m2"
		local m2_settings = m2_home .. "/settings.xml"

		local servers = {
			"cssls",
			"tailwindcss",
			"ts_ls",
			"html",
			"yamlls",
			"lua_ls",
			"jdtls",
			"pyright",
			"spring_boot_ls",
		}

		for _, lsp in ipairs(servers) do
			local opts = {
				on_attach = on_attach,
				capabilities = capabilities,
			}

			if lsp == "jdtls" then
				opts.settings = {
					java = {
						configuration = {
							updateBuildConfiguration = "automatic",
							runtimes = {
								{
									name = "JavaSE-17",
									path = vim.fn.expand("~/.sdkman/candidates/java/17.0.0-tem"),
									default = true,
								},
								{
									name = "JavaSE-11",
									path = vim.fn.expand("~/.sdkman/candidates/java/11.0.0-tem"),
								},
							},
							maven = {
								enabled = true,
								userSettings = m2_settings,
								globalSettings = m2_settings,
								notificationsEnabled = true,
								downloadSources = true,
								updateSnapshots = true,
							},
						},
						maven = {
							downloadSources = true,
							updateSnapshots = true,
							defaultMavenConfig = m2_settings,
							repository = {
								localRepo = {
									path = m2_home .. "/repository",
								},
							},
						},
						implementationsCodeLens = { enabled = true },
						referencesCodeLens = { enabled = true },
						references = {
							includeDecompiledSources = true,
						},
						inlayHints = {
							parameterNames = { enabled = "all" },
						},
						format = {
							enabled = true,
							settings = {
								url = vim.fn.stdpath("config") .. "/lang-servers/eclipse-java-google-style.xml",
							},
						},
						signatureHelp = { enabled = true },
						completion = {
							favoriteStaticMembers = {
								"org.junit.Assert.*",
								"org.junit.Assume.*",
								"org.junit.jupiter.api.Assertions.*",
								"org.junit.jupiter.api.Assumptions.*",
								"org.junit.jupiter.api.DynamicContainer.*",
								"org.junit.jupiter.api.DynamicTest.*",
								"org.mockito.Mockito.*",
								"org.mockito.ArgumentMatchers.*",
								"org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
								"org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
								"org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.*",
								"org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.*",
							},
							filteredTypes = {
								"com.sun.*",
								"io.micrometer.shaded.*",
								"java.awt.*",
								"jdk.*",
								"sun.*",
							},
						},
						sources = {
							organizeImports = {
								starThreshold = 9999,
								staticStarThreshold = 9999,
							},
						},
						project = {
							resourceFilters = {
								"node_modules",
								".git",
								"target",
								"bin",
							},
						},
					},
				}
			elseif lsp == "spring_boot_ls" then
				opts.settings = {
					spring = {
						bootVersion = "3.x.x",
						initializr = {
							defaultLanguage = "java",
							defaultJavaVersion = "17",
						},
					},
					java = {
						server = {
							launchMode = "Standard",
						},
						configuration = {
							maven = {
								userSettings = m2_settings,
								globalSettings = m2_settings,
							},
						},
						recommendations = {
							dependency = {
								analytics = {
									enabled = true,
								},
							},
						},
					},
				}
			end

			lspconfig[lsp].setup(opts)
		end

		-- Configure LSP diagnostics
		vim.diagnostic.config({
			virtual_text = {
				prefix = "●",
				source = "always",
			},
			float = {
				source = "always",
				border = "rounded",
				header = "",
				prefix = "",
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		-- Set up file watchers for Maven files
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			pattern = { "pom.xml" },
			callback = function()
				vim.cmd("LspRestart")
			end,
		})
	end,
}

return M
