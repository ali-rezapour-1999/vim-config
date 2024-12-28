local M = {}

M = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    {
      "williamboman/mason.nvim",
      opts = {
        ensure_installed = {
          "pyright",
          "ruff",
          "black",
          "isort",
          "debugpy", -- Python
          "jdtls",
          "java-debug-adapter",
          "java-test",
          "spring-boot-language-server", -- Java
          "typescript-language-server",
          "eslint",                 -- TypeScript/JavaScript
          "css-lsp",
          "tailwindcss-language-server", -- CSS/TailwindCSS
          "stylua",
          "luacheck",               -- Lua
          "prettier",               -- General Formatter
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

      -- Keymaps for LSP features
      map("n", "<C-G>", vim.lsp.buf.declaration, "Go to Declaration")
      map("n", "<C-k>", function()
        require("telescope.builtin").lsp_definitions({ reuse_win = false })
      end, "Goto Definition")
      map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
      map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
      map("n", "ca", vim.lsp.buf.code_action, "Code Action")
      map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
      map("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, "Format")
    end

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    local servers = {
      pyright = {},
      jdtls = {},
      tsserver = {},
      cssls = {},
      tailwindcss = {},
      lua_ls = {
        settings = {
          Lua = {
            format = {
              enable = true,
            },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      },
    }

    for lsp, opts in pairs(servers) do
      opts.on_attach = on_attach
      opts.capabilities = capabilities
      lspconfig[lsp].setup(opts)
    end

    vim.diagnostic.config({
      virtual_text = { prefix = "●", source = "always" },
      float = { source = "always", border = "rounded" },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = "*.{py,java,ts,js,css,html,lua}",
      callback = function()
        vim.cmd("LspRestart")
      end,
    })
  end,
}

return M
