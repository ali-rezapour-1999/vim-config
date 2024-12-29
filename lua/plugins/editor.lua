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
	{
		"rcarriga/nvim-notify",
		lazy = false,
		config = function()
			local notify = require("notify")
			notify.setup({
				position = "top_right",
				stages = "fade",
				timeout = 5000,
				top_down = true,
				render = "default",
				border = "rounded",
				background_colour = "#1e1e2e",
				max_height = function()
					return math.floor(vim.o.lines * 0.75)
				end,
				max_width = function()
					return math.floor(vim.o.columns * 0.75)
				end,
				on_open = function(win)
					vim.api.nvim_win_set_config(win, {
						border = "rounded",
						relative = "editor",
						anchor = "NE",
						row = 1,
						col = vim.o.columns - 1,
					})
				end,
			})
			vim.notify = notify
		end,
	},
}
