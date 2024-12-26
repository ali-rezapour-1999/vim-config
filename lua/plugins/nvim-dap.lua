return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require "dap"
    local dapui = require "dapui"

    dapui.setup()

    dap.listeners.before.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.after.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.after.event_exited["dapui_config"] = function()
      dapui.close()
    end

    vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "➡️", texthl = "", linehl = "", numhl = "" })

    vim.keymap.set("n", "<A-t>", dap.toggle_breakpoint, { desc = "[D]ebug [T]oggle Breakpoint" })
    vim.keymap.set("n", "<A-s>", dap.continue, { desc = "[D]ebug [S]tart" })
    vim.keymap.set("n", "<A-c>", dapui.close, { desc = "[D]ebug [C]lose" })
    vim.keymap.set("n", "<F8>", dap.continue, { desc = "[F5] Continue" })
    vim.keymap.set("n", "<F10>", dap.step_over, { desc = "[F10] Step Over" })
    vim.keymap.set("n", "<F11>", dap.step_into, { desc = "[F11] Step Into" })
    vim.keymap.set("n", "<F12>", dap.step_out, { desc = "[F12] Step Out" })

    vim.keymap.set("n", "<A-r>", function()
      dap.repl.open()
    end, { desc = "[D]ebug [R]epl Open" })

    vim.keymap.set("n", "<A-l>", function()
      dap.run_last()
    end, { desc = "[D]ebug [L]ast" })

    vim.keymap.set("n", "<A-e>", function()
      dapui.eval()
    end, { desc = "[D]ebug [E]valuate" })
  end,
}
