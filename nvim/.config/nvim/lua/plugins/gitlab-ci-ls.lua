return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  optional = true,
  opts = function(_, opts)
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "gitlab-ci-ls" })
  end,
}
