local M = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    {
      "williamboman/mason.nvim",
      opts = {
        ensure_installed = {
          "stylua",
          "selene",
          "luacheck",
          "shellcheck",
          "shfmt",
          "tailwindcss-language-server",
          "typescript-language-server",
          "css-lsp",
          -- Java tools
          "jdtls",
          "java-debug-adapter",
          "java-test",
          "spring-boot-language-server",
          -- Python tools
          "pyright",
          "pylint",
          "black",
          "isort",
          "debugpy",
        },
      },
    },
  },
  config = function()
    local lspconfig = require "lspconfig"
    local on_attach = function(client, bufnr)
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- LSP Keymaps
      map("n", "<C-G>", vim.lsp.buf.declaration, "Go to Declaration")
      map("n", "<C-k>", function()
        require("telescope.builtin").lsp_definitions { reuse_win = false }
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
          vim.lsp.util.open_floating_preview(vim.lsp.util.convert_input_to_markdown_lines(result.contents), "markdown")
        end, bufnr)
      end, "Hover Documentation")
      map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
      map("n", "ca", vim.lsp.buf.code_action, "Code Action")
      map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
      map("n", "DD", vim.lsp.buf.type_definition, "Type Definition")
      map("n", "gr", require("telescope.builtin").lsp_references, "References")
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    local servers = {
      "cssls",
      "tailwindcss",
      "ts_ls",
      "html",
      "yamlls",
      "lua_ls",
      "jdtls",
      "pyright",
    }

    for _, lsp in ipairs(servers) do
      local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      if lsp == "lua_ls" then
        opts.settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            completion = { workspaceWord = true, callSnippet = "Both" },
            hint = {
              enable = true,
              setType = false,
              paramType = true,
              paramName = "Disable",
              semicolon = "Disable",
              arrayIndex = "Disable",
            },
            diagnostics = {
              disable = { "incomplete-signature-doc", "trailing-space" },
              groupSeverity = { strong = "Warning", strict = "Warning" },
            },
          },
        }
      elseif lsp == "ts_ls" then
        opts.root_dir = require("lspconfig.util").root_pattern ".git"
        opts.single_file_support = false
        opts.settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "literal",
              includeInlayFunctionParameterTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
            },
          },
        }
      elseif lsp == "yamlls" then
        opts.settings = {
          yaml = {
            keyOrdering = false,
          },
        }
      elseif lsp == "jdtls" then
        opts.settings = {
          java = {
            configuration = { updateBuildConfiguration = "automatic" },
            maven = { downloadSources = true },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = { enabled = true },
            references = { includeDecompiledSources = true },
            inlayHints = { parameterNames = { enabled = "all" } },
            format = { enabled = false },
            signatureHelp = { enabled = true },
            completion = {
              favoriteStaticMembers = {
                "org.junit.Assert.*",
                "org.junit.Assume.*",
                "org.junit.jupiter.api.Assertions.*",
                "org.junit.jupiter.api.Assumptions.*",
                "org.junit.jupiter.api.DynamicContainer.*",
                "org.junit.jupiter.api.DynamicTest.*",
                "org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
                "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
              },
            },
          },
        }
      elseif lsp == "pyright" then
        opts.settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "basic",
              djangoDebugging = true,
            },
            linting = {
              pylintEnabled = true,
              enabled = true,
            },
          },
        }
      end

      lspconfig[lsp].setup(opts)
    end
  end,
}

return M
