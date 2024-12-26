require "nvchad.mappings"

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("i", "jk", "<ESC>")

keymap.set("n", "nh", ":nohl<CR>")
keymap.set("n", ";;", ":w<Enter>")

keymap.set("n", "x", '"_x')

keymap.set("n", "dw", 'vb"_d')

keymap.set("n", "sv", "<C-w>v")
keymap.set("n", "sh", "<C-w>s")
keymap.set("n", "se", "<C-w>=")
keymap.set("n", "cl", ":q")

keymap.set("n", "to", ":tabnew<CR>")
keymap.set("n", "cl", ":q<Enter>")
keymap.set("n", "te", ":tabedit")

keymap.set("n", "<Space>", "<C-w>w")

keymap.set("n", "ff", "<cmd>Telescope find_files<cr>")
keymap.set("n", "fs", "<cmd>Telescope live_grep<cr>")
keymap.set("n", "fb", "<cmd>Telescope buffers<cr>")
keymap.set("n", "fh", "<cmd>Telescope help_tags<cr>")

keymap.set("n", "<leader>/", "<Plug>(comment_toggle_linewise_current)", { desc = "Comment Line" })
keymap.set("v", "<leader>/", "<Plug>(comment_toggle_linewise_visual)", { desc = "Comment Selected" })

keymap.set("i", "<C-j>", "<C-n>", { noremap = true, silent = true })
keymap.set("i", "<C-k>", "<C-p>", { noremap = true, silent = true })

keymap.set("n", "rss", ":LspRestart<CR>")
keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)

keymap.set("n", "<C-k>", function()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result, _, _)
    if not result or vim.tbl_isempty(result) then
      print "No definition found!"
      return
    end

    local target = result[1] or result
    local uri = target.uri or target.targetUri
    local range = target.range or target.targetSelectionRange
    local current_uri = vim.uri_from_bufnr(0)

    if uri == current_uri then
      local row = range.start.line + 1
      local col = range.start.character + 1
      vim.api.nvim_win_set_cursor(0, { row, col })
    else
      vim.cmd "tabedit"
      vim.lsp.util.jump_to_location(target, "utf-8")
    end
  end)
end, { noremap = true, silent = true, desc = "Go to definition, open in new tab" })
