return {
  "mfussenegger/nvim-dap",
  keys = "<leader>d",
  dependencies = {
    {
      "nvim-telescope/telescope-dap.nvim",
      dependencies = { "nvim-telescope/telescope.nvim" },
    },
    { "theHamsta/nvim-dap-virtual-text", config = true }, -- show current variable values
    { "rcarriga/nvim-dap-ui", config = true },            -- debugger ui
  },
  config = function()
    local dap = require "dap"
    local dap_widgets = require "dap.ui.widgets";
    local map = vim.keymap.set
    map("n", "<leader>db", dap.toggle_breakpoint, { desc = "[dap] toggle breakpoint" })
    map("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
      { desc = "[dap] conditional breakpoint" })
    map("n", "<leader>dh", dap_widgets.hover, { desc = "[dap] hover" })
    map("n", "<leader>dr", dap.repl.toggle, { desc = "[dap] toggle REPL" })
    map("n", "<leader>dus", function() dap_widgets.centered_float(dap_widgets.scopes) end, { desc = "[dap] ui scopes" })
    map("n", "<leader>duf", function() dap_widgets.centered_float(dap_widgets.frames) end, { desc = "[dap] ui frames" })
    map("n", "<leader>due", function() dap_widgets.centered_float(dap_widgets.expression) end,
      { desc = "[dap] ui expressions" })
    map("n", "<leader>dut", function() dap_widgets.centered_float(dap_widgets.threads) end, { desc = "[dap] ui threads" })
    map("n", "<leader>duu", require("dapui").toggle, { desc = "[dap] dapui toggle" })
    map("n", "<leader>dc", dap.continue, { desc = "[dap] continue" })

    if package.loaded["telescope"] then
      require("telescope").load_extension("dap")
    end
  end,
}

--[[
Is better add config by project using direnv, for example:

vim.api.nvim_create_autocmd("User",
  {
    group = vim.api.nvim_create_augroup("myproject", {}),
    pattern = "LazyLoad",
    callback = function(e)
      if e.data == "nvim-dap" then
        local dap = require("dap")

        dap.adapters.codelldb = {
          type = "server",
          port = "${port}",
          executable = {
            command = "codelldb",
            args = { "--port", "${port}" },
          },
        }

        dap.listeners.before["event_initialized"]["myproject"] = function()
          vim.fn.system("cargo build")
        end

        dap.configurations.rust = {
          {
            name = "Launch",
            type = "codelldb",
            request = "launch",
            program = "${workspaceFolder}/target/debug/${workspaceFolderBasename}",
            cwd = "${workspaceFolder}",
            console = "internalConsole",
          },
        }
      end
    end,
  })
]]
