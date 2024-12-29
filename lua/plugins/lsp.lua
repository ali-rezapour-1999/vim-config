local M = {}

M = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    {
      "williamboman/mason.nvim",
      opts = {
        ensure_installed = {
          -- Python
          "pyright",
          "ruff",
          "black",
          "isort",
          "debugpy",
          -- Java
          "jdtls",
          "java-debug-adapter",
          "java-test",
          -- TypeScript/JavaScript
          "typescript-language-server",
          "eslint",
          -- CSS/TailwindCSS
          "css-lsp",
          "tailwindcss-language-server",
          -- Lua
          "stylua",
          "luacheck",
          -- General Formatter
          "prettier",
        },
      },
    },
    -- Add nvim-java and its dependencies
    {
      "nvim-java/nvim-java",
      dependencies = {
        "nvim-java/lua-async-await",
        "nvim-java/nvim-java-core",
        "nvim-java/nvim-java-test",
        "nvim-java/nvim-java-dap",
        "MunifTanjim/nui.nvim",
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-dap-ui",
        {
          "williamboman/mason.nvim",
          opts = {
            registries = {
              "github:nvim-java/mason-registry",
              "github:mason-org/mason-registry",
            },
          },
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
      
      map("n", "<C-G>", vim.lsp.buf.declaration, "Go to Declaration")
      map("n", "<C-k>", function()
        require("telescope.builtin").lsp_definitions({ reuse_win = false })
      end, "Goto Definition")
      map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
      map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
      map("n", "ca", vim.lsp.buf.code_action, "Code Action")
      map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
      map("n", "66", function()
        require("conform").format({
          async = true,
          lsp_fallback = true,
          timeout_ms = 500,
        })
      end, "Format File or Range")
    end

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    require("java").setup({
      jdk = {
        auto_install = false, 
      },
      jdtls = {
        auto_install = false, 
      },
      settings = {
        java = {
          format = {
            enabled = true,
            settings = {
              url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
            },
          },
          signatureHelp = { enabled = true },
          contentProvider = { preferred = "fernflower" },
          completion = {
            favoriteStaticMembers = {},
            filteredTypes = {
              "com.sun.*",
              "io.micrometer.shaded.*",
              "java.awt.*",
              "jdk.*",
              "sun.*",
            },
          },
        },
      },
    })

    local servers = {
      pyright = {},
      jdtls = {},
      ts_ls = {},
      cssls = {},
      tailwindcss = {},
      lua_ls = {
        settings = {
          Lua = {
            format = { enable = true },
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
      virtual_text = {
        prefix = "●",
        source = "always",
      },
      float = {
        source = "always",
        border = "rounded",
      },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })
  end,
}

return M
