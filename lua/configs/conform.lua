local options = {
	formatters_by_ft = {
		lua = { "stylua" },
		css = { "prettier" },
		html = { "prettier" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		java = { "google-java-format" },
		python = { "black", "isort" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
}

vim.keymap.set({ "n", "v" }, "<leader>f", function()
	require("conform").format({
		async = true,
		lsp_fallback = true,
		timeout_ms = 500,
	})
end, { desc = "Format file or range" })

return options
