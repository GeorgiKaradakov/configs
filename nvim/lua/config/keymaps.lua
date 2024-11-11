-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.api.nvim_set_keymap("n", "<leader>oc", ":ChatGPT<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>cc", ":ChatGPTCompleteCode<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>rc", ":ChatGPTRun", { noremap = true })

local chatgpt = require("chatgpt")
require("which-key").register({
  { "<leader>p", group = "ChatGPT", mode = "v" },
  {
    "<leader>pe",
    function()
      chatgpt.edit_with_instructions()
    end,
    desc = "Edit with instructions",
    mode = "v",
  },
})
