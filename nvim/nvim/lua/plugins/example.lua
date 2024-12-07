return {
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "VeryLazy",
  },
  {
    "aznhe21/actions-preview.nvim",
    config = function()
      require("actions-preview").setup({
        backend = { "nvim-lsp", "telescope" },
        vim.keymap.set(
          "n",
          "<leader>ca",
          require("actions-preview").code_actions,
          { noremap = true, silent = true, desc = "Show LSP Code Actions" }
        ),
      })
    end,
  },
}
