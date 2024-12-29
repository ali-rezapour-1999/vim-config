return {
	{
		"nvim-treesitter/playground",
		cmd = "TSPlaygroundToggle",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		build = ":TSUpdate",
		config = function()
			local config = require("nvim-treesitter.configs")
			config.setup({
				auto_install = true,
				sync_install = true,
				ensure_installed = {
					"cmake",
					"cpp",
					"css",
					"fish",
					"gitignore",
					"go",
					"graphql",
					"http",
					"java",
					"scss",
					"sql",
					"svelte",
				},
				ignore_install = { "haskell" },
				modules = {},

				highlight = {
					enable = true,
				},

				indent = {
					enable = false,
				},

				autotag = {
					enable = true,
				},
			})
		end,
	},
}
