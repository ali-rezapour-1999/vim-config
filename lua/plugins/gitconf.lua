return {
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("lazygit").setup()
    end,
    keys = {
      { "gl", ":LazyGit<CR>", desc = "Open Lazygit" },
    },
    cmd = "LazyGit",
  },
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
      require("gitsigns").setup {
        current_line_blame = true,
      }
    end,
  },

  {
    "tpope/vim-fugitive",
  },
}
