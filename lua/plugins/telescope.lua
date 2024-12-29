return {

  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-lua/plenary.nvim",
    },
    "nvim-telescope/telescope-file-browser.nvim",
  },
  keys = {
    {
      "<C-m>",
      function()
        local word = vim.fn.expand "<cword>"
        require("telescope.builtin").grep_string {
          search = word,
          only_sort_text = true,
          path_display = { "shorten" },
          cwd = vim.fn.getcwd(),
        }
      end,
    },
    {
      ";r",
      function()
        local builtin = require "telescope.builtin"
        builtin.resume()
      end,
    },

    {
      ";b",
      function()
        local builtin = require "telescope.builtin"
        builtin.resume()
      end,
    },
    {
      "nn",
      function()
        local telescope = require "telescope"

        local function telescope_buffer_dir()
          return vim.fn.expand "%:p:h"
        end

        telescope.extensions.file_browser.file_browser {
          path = "%:p:h",
          cwd = telescope_buffer_dir(),
          respect_gitignore = false,
          hidden = true,
          grouped = true,
          previewer = false,
          initial_mode = "normal",
          layout_config = { height = 40, width = 150 },
        }
      end,
    },
  },
  config = function(_, opts)
    local telescope = require "telescope"

    opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
      wrap_results = true,
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 0,
      mappings = {
        n = {},
      },
    })
    opts.pickers = {
      diagnostics = {
        theme = "ivy",
        initial_mode = "normal",
        layout_config = {
          preview_cutoff = 9999,
        },
      },
    }
    telescope.setup(opts)
    require("telescope").load_extension "file_browser"
  end,
}
