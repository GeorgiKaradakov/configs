-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Function to prompt for a source directory
local function get_source_directory(callback)
  vim.ui.input({ prompt = "Enter source directory (default: ..): " }, function(input)
    local src_dir = input and input ~= "" and input or ".."
    callback(src_dir)
  end)
end

-- Function to initialize CMake
local function cmake_init()
  get_source_directory(function(src_dir)
    local cmd = string.format("mkdir -p build && cd build && cmake %s", src_dir)
    vim.cmd("!" .. cmd)
    print("CMake Initialized in build/ with source: " .. src_dir)
  end)
end

-- Function to generate compile_commands.json
local function cmake_generate_compile_commands()
  get_source_directory(function(src_dir)
    local cmd = string.format("mkdir -p build && cd build && cmake %s -DCMAKE_EXPORT_COMPILE_COMMANDS=ON", src_dir)
    vim.cmd("!" .. cmd)
    print("compile_commands.json generated in build/ with source: " .. src_dir)
  end)
end

-- Keybindings
vim.keymap.set(
  "n",
  "<leader>ci",
  cmake_init,
  { noremap = true, silent = true, desc = "Initialize CMake (specify source folder)" }
)

vim.keymap.set(
  "n",
  "<leader>cg",
  cmake_generate_compile_commands,
  { noremap = true, silent = true, desc = "Generate compile_commands.json (specify source folder)" }
)

-- update whichkey
local wk = require("which-key")

wk.register({
  c = {
    name = "code & CMake",
    i = { "<cmd>lua cmake_init()<CR>", "Initialize CMake (specify source folder)" },
    g = { "<cmd>lua cmake_generate_compile_commands()<CR>", "Generate compile_commands.json" },
  },
}, { prefix = "<leader>" })
