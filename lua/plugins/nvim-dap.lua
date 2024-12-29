return {
	{
		"jay-babu/mason-nvim-dap.nvim",
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = { "java-debug-adapter", "java-test" },
				handlers = {},
			})
		end,
	},
	{
		"mfussenegger/nvim-jdtls",
		dependencies = {
			"mfussenegger/nvim-dap",
			"ray-x/lsp_signature.nvim",
		},
	},
	{
		"nvim-telescope/telescope-dap.nvim",
		requires = { "nvim-telescope/telescope.nvim" },
	},
	{
		"ray-x/lsp_signature.nvim",
		config = function()
			require("lsp_signature").setup({
				hint_enable = true,
				hint_prefix = "💡 ",
				handler_opts = {
					border = "rounded",
				},
			})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup({
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						position = "left",
						size = 40,
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						position = "bottom",
						size = 10,
					},
				},
			})

			require("nvim-dap-virtual-text").setup({
				enabled = true,
				highlight_new_as_changed = true,
				show_stop_reason = true,
			})

			dap.listeners.before.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.after.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.after.event_exited["dapui_config"] = function()
				dapui.close()
			end

			vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "Error", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapStopped",
				{ text = "➡️", texthl = "WarningMsg", linehl = "CursorLine", numhl = "" }
			)
			vim.keymap.set("n", "<A-b>", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
			vim.keymap.set("n", "<A-B>", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Set Conditional Breakpoint" })
			vim.keymap.set("n", "<A-c>", dap.continue, { desc = "Continue Debugging" })
			vim.keymap.set("n", "<A-o>", dap.step_over, { desc = "Step Over" })
			vim.keymap.set("n", "<A-i>", dap.step_into, { desc = "Step Into" })
			vim.keymap.set("n", "<A-u>", dap.step_out, { desc = "Step Out" })
			vim.keymap.set("n", "<A-r>", dap.repl.open, { desc = "Open REPL" })
			vim.keymap.set("n", "<A-l>", dap.run_last, { desc = "Run Last Debug Session" })
			vim.keymap.set("n", "<A-e>", dapui.eval, { desc = "Evaluate Expression" })
			vim.keymap.set("n", "<A-t>", dapui.toggle, { desc = "Toggle Debug UI" })
			vim.keymap.set("n", "<A-w>", function()
				dapui.eval(vim.fn.input("Expression: "))
			end, { desc = "Watch Expression" })
			vim.keymap.set("n", "<A-p>", function()
				dap.pause()
			end, { desc = "Pause Debugging" })
			vim.keymap.set("n", "<A-s>", function()
				dap.disconnect()
			end, { desc = "Stop Debugging" })
			vim.keymap.set("n", "<A-q>", function()
				dap.disconnect()
				dapui.close()
			end, { desc = "Quit Debugging" })
		end,
	},
}
