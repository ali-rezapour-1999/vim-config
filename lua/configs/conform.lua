local options = {
	formatters_by_ft = {
		lua = { "stylua" },
		css = { "prettier" },
		html = { "prettier" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		python = { "black", "isort" },
	},
	format_on_save = true,
}

vim.keymap.set({ "n", "v" }, "66", function()
	require("conform").format({
		async = true,
		lsp_fallback = true,
		timeout_ms = 500,
	})
end, { desc = "Format file or range" })

return options
