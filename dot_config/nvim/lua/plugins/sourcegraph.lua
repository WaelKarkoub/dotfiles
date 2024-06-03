return {
  {
    "sourcegraph/sg.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function() require("sg").setup {} end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "sourcegraph/sg.nvim" },
    opts = function(_, opts)
      -- Inject copilot into cmp sources, with high priority
      table.insert(opts.sources, 1, {
        name = "cody",
        group_index = 1,
        priority = 10000,
      })
    end,
  },
}
