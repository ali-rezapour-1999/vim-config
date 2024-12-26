return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require "null-ls"
    null_ls.setup {
      sources = {
        null_ls.builtins.formatting.stylua,
        require "none-ls.diagnostics.eslint_d",
        null_ls.builtins.formatting.prettierd.with {
          extra_args = function(params)
            return params.options
              and params.options.tabSize
              and {
                "--tab-width",
                params.options.tabSize,
              }
          end,
        },
      },
    }
  end,
}
