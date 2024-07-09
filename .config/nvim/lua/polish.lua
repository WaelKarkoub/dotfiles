-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    if vim.bo.ft == "python" then
      vim.lsp.buf.code_action {
        context = { only = { "source.fixAll.ruff" } },
        apply = true,
      }
    end
  end,
})

vim.filetype.add {
  extension = {
    mdx = "markdown",
    zsh = "sh",
    sh = "sh",
  },
  filename = {
    [".zshrc"] = "sh",
    [".zshenv"] = "sh",
  },
}
