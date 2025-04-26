if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

local prefix = "<Leader>a"
return {
  "augmentcode/augment.vim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile", "User Astrofile" },
  config = function()
    -- Git root detection and workspace setup
    local function get_git_root()
      local handle = io.popen "git rev-parse --show-toplevel 2> /dev/null"
      if handle then
        local result = handle:read "*l"
        handle:close()
        return result
      end
      return nil
    end

    local workspace_path = get_git_root() or vim.fn.getcwd()
    if not get_git_root() then
      vim.notify("Not a git repository. Using current directory: " .. workspace_path, vim.log.levels.DEBUG)
    end

    vim.g.augment_workspace_folders = { workspace_path }

    vim.g.augment_auto_completion = true
    vim.g.augment_inline_suggestions = true
    vim.g.augment_format_on_save = true
    vim.g.augment_diagnostics = true

    -- Which-Key configuration
    local wk = require "which-key"

    wk.add {
      { prefix, group = "Augment" },
      { prefix .. "c", "<cmd>Augment chat<cr>", desc = "Chat", mode = { "n", "v" } },
      { prefix .. "n", "<cmd>Augment chat-new<cr>", desc = "New chat", mode = "n" },
      { prefix .. "t", "<cmd>Augment chat-toggle<cr>", desc = "Toggle chat", mode = "n" },
      { "<C-g>", "<cmd>call augment#Accept()<cr>", desc = "Accept suggestion", mode = "i" },
    }

    vim.g.augment_ignore_patterns = {
      -- Python
      "*.pyc",
      "__pycache__",
      "*.pyo",
      "*.pyd",
      ".Python",
      "env/",
      "venv/",
      ".env/",
      ".venv/",
      "pip-log.txt",
      "pip-delete-this-directory.txt",
      ".tox/",
      ".coverage",
      ".coverage.*",
      "htmlcov/",
      ".pytest_cache/",
      ".mypy_cache/",

      -- Rust
      "target/",
      "Cargo.lock",
      "**/*.rs.bk",

      -- Node/JavaScript/TypeScript
      "node_modules/",
      "npm-debug.log*",
      "yarn-debug.log*",
      "yarn-error.log*",
      ".pnpm-debug.log*",
      "dist/",
      "build/",
      ".next/",
      "out/",
      "*.tsbuildinfo",
      ".npm",
      ".eslintcache",
      ".node_repl_history",

      -- C/C++
      "*.o",
      "*.obj",
      "*.dll",
      "*.so",
      "*.dylib",
      "*.exe",

      -- IDE/Editor
      ".idea/",
      ".vscode/",
      "*.swp",
      "*.swo",
      ".DS_Store",

      -- Build outputs
      "bin/",
      "obj/",
      "build/",
      "dist/",

      -- Logs and databases
      "*.log",
      "*.sqlite",
      "*.db",

      -- Environment and secrets
      ".env",
      ".env.*",
      "*.pem",
      "*.key",
    }
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}
