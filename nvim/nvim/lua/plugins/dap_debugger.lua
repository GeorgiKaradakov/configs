return {
  -- Install nvim-dap
  "mfussenegger/nvim-dap",

  dependencies = {
    "rcarriga/nvim-dap-ui", -- UI for nvim-dap
    "theHamsta/nvim-dap-virtual-text", -- Virtual text for variables
    "nvim-telescope/telescope-dap.nvim", -- Telescope integration
    "jay-babu/mason-nvim-dap.nvim", -- Automatic DAP installation
  },

  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()
    require("nvim-dap-virtual-text").setup()

    --add adapters
    dap.adapters.gdb = {
      type = "executable",
      command = "gdb",
      args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
    }

    --dap adapters config
    dap.configurations.cpp = {
      {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
      },
      {
        name = "Select and attach to process",
        type = "gdb",
        request = "attach",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        pid = function()
          local name = vim.fn.input("Executable name (filter): ")
          return require("dap.utils").pick_process({ filter = name })
        end,
        cwd = "${workspaceFolder}",
      },
      {
        name = "Attach to gdbserver :1234",
        type = "gdb",
        request = "attach",
        target = "localhost:1234",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
      },
    }

    --seting up keybinds
    local wk = require("which-key")
    wk.register({
      d = {
        name = "Debug",
        b = { "<cmd>lua require'dap'.toggle_breakpoint()<CR>", "Toggle Breakpoint" },
        c = { "<cmd>lua require'dap'.continue()<CR>", "Continue" },
        s = { "<cmd>lua require'dap'.step_over()<CR>", "Step Over" },
        i = { "<cmd>lua require'dap'.step_into()<CR>", "Step Into" },
        o = { "<cmd>lua require'dap'.step_out()<CR>", "Step Out" },
        r = { "<cmd>lua require'dap'.repl.open()<CR>", "Open REPL" },

        -- ✅ Toggle dap-ui manually
        u = { "<cmd>lua require'dapui'.toggle()<CR>", "Toggle Debug UI" },

        -- ✅ Reset dap-ui (close + reopen)
        R = {
          function()
            dapui.close()
            vim.defer_fn(function()
              dapui.open()
            end, 200)
          end,
          "Reset Debug UI",
        },
      },
    }, { prefix = "<leader>" })
  end,
}
