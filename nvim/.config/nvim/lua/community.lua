-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.colorscheme.kanagawa-nvim" },
  { import = "astrocommunity.colorscheme.tokyonight-nvim" },
  -- Misc
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.lsp.actions-preview-nvim" },
  { import = "astrocommunity.motion.flash-nvim" },
  { import = "astrocommunity.test.nvim-coverage" },
  { import = "astrocommunity.editing-support.undotree" },
  -- Language packs
  { import = "astrocommunity.pack.ansible" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.proto" },
  { import = "astrocommunity.pack.python-ruff" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.yaml" },

  -- Customize Plugins
  {
    "andythigpen/nvim-coverage",
    event = "User AstroFile",
    keys = function()
      local prefix = "<Leader>lc"

      local mappings = {
        {
          prefix,
          desc = "Code Coverage",
        },
        {
          prefix .. "c",
          function()
            require("coverage").clear()
            require("coverage").load(true)
          end,
          desc = "Show Code Coverage",
        },
        {
          prefix .. "h",
          function() require("coverage").hide() end,
          desc = "Hide Code Coverage",
        },
        {
          prefix .. "s",
          function()
            require("coverage").clear()
            require("coverage").load(false)
            require("coverage").summary()
          end,
          desc = "Show Code Coverage Summary",
        },
      }
      mappings = vim.tbl_filter(function(m) return m[1] and #m[1] > 0 end, mappings)
      return mappings
    end,
    opts = function(_, opts)
      opts.lang = opts.lang or {}
      opts.lang.rust = {
        coverage_command = "cargo llvm-cov report --json --output-path ${cwd}/coverage.json",
        project_files_only = true,
        project_files = { "src/**/*.rs" },
      }
    end,
  },
  {
    "folke/tokyonight.nvim",
    opts = function(_, opts) opts.dim_inactive = true end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    opts = function(_, opts)
      opts.parents = 0
      opts.name = { "venv", ".venv" }
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    opts = function(_, opts)
      opts.dimInactive = true
      opts.compile = true
    end,
  },
}
