return {
	{
		"stevearc/conform.nvim",
		opts = require("configs.conform"),
	},

	{
		"numToStr/Comment.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},

	{
		"mg979/vim-visual-multi",
		event = "BufRead",
		config = function() end,
	},

	{
		"danymat/neogen",
		keys = {
			{
				"<leader>cc",
				function()
					require("neogen").generate({})
				end,
				desc = "Generate Documentation with Neogen",
			},
		},
		opts = { snippet_engine = "luasnip" },
		config = function(_, opts)
			require("neogen").setup(opts)
		end,
	},

	{
		"folke/flash.nvim",
		opts = {
			search = {
				forward = true,
				multi_window = false,
				wrap = false,
				incremental = true,
			},
		},
		config = function(_, opts)
			require("flash").setup(opts)
		end,
	},

	{
		"b0o/incline.nvim",
		event = "BufReadPre",
		priority = 1200,
		config = function(_, opts)
			require("incline").setup(opts)
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
	},
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				size = 30,
				open_mapping = [[,,]],
				direction = "horizontal",
			})
		end,
	},
}
