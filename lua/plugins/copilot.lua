return {
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""

      vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { expr = true, silent = true })

      vim.g.copilot_filetypes = {
        ["*"] = false, -- Disable Copilot for all filetypes by default
        ["python"] = true, -- Enable for Python
        ["javascript"] = true, -- Enable for JavaScript
        ["go"] = true, -- Enable for Go
        ["java"] = true, -- Enable for Java (including Spring Boot)
      }

      vim.cmd([[
        augroup CopilotSettings
          autocmd!
          autocmd FileType python let b:copilot_enabled = 1
          autocmd FileType javascript let b:copilot_enabled = 1
          autocmd FileType go let b:copilot_enabled = 1
          autocmd FileType java let b:copilot_enabled = 1
        augroup END
      ]])
    end,
  },
}