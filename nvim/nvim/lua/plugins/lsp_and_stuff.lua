return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "pyright",
        "eslint_d",
        "ts_ls",
        "ruff",
        "prettier",
        "prettierd",
        "vue-language-server",
        "clangd",
        "clang-format",
        "cpplint",
        "sqls",
        "sql-formatter",
        "sqlfluff",
        "omnisharp",
        "csharpier",
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        python = { "ruff" },
        svelte = { "eslint_d" },
        kotlin = { "ktlint" },
        terraform = { "tflint" },
        ruby = { "standardrb" },
        cpp = { "cpplint" },
        sql = { "sqlfluff" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      require("lint").linters.sqlfluff = {
        cmd = "sqlfluff",
        args = { "lint", "-" },
        stdin = true,
        stream = "stdout",
        ignore_exitcode = true,
        parser = require("lint.parser").from_errorformat("%f:%l:%c: %m"),
      }

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      vim.keymap.set("n", "<leader>ll", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        javascript = { "prettier", "prettierd" },
        typescript = { "prettier", "prettierd" },
        python = { "ruff" },
        javascriptreact = { "prettier", "prettierd" },
        typescriptreact = { "prettier", "prettierd" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        sql = { "sql_formatter" },
        cs = { "csharpier" },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    enabled = true,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,preview,noselect",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = lspkind.cmp_format({
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      end

      require("lspconfig").pyright.setup({
        on_attach = on_attach,
      })

      require("lspconfig").ts_ls.setup({
        on_attach = on_attach,
      })

      require("lspconfig").eslint.setup({
        on_attach = on_attach,
      })

      require("lspconfig").volar.setup({
        on_attach = on_attach,
      })

      require("lspconfig").clangd.setup({
        on_attach = on_attach,
        cmd = { "clangd", "--background-index", "--suggest-missing-includes" },
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      require("lspconfig").omnisharp.setup({
        cmd = { "omnisharp" },
        on_attach = on_attach,
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        root_dir = require("lspconfig.util").root_pattern(".git", "*.sln", "*.csproj"),
        enable_editorconfig_support = true,
        enable_ms_build_load_projects_on_demand = true,
        enable_roslyn_analyzers = true,
        organize_imports_on_format = true,
        enable_import_completion = true,
        sdk_include_prereleases = true,
        analyze_open_documents_only = false,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "c",
        "cpp",
        "python",
        "typescript",
        "javascript",
        "lua",
        "vue",
        "sql",
        "css",
        "html",
        "bash",
        "json",
        "yaml",
        "markdown",
        "markdown_inline",
        "regex",
        "ruby",
        "terraform",
        "kotlin",
        "java",
        "rust",
        "c_sharp", -- Enable C# syntax highlighting
      },
      highlight = { enable = true },
      indent = { enable = true },
      additional_vim_regex_highlighting = false,
    },
  },
  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {},
  },

  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  {
    "rafamadriz/friendly-snippets",
  },
}
