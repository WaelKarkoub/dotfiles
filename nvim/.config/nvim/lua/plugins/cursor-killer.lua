-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

local prefix = "<Leader>a"
local function get_git_root()
  local handle = io.popen "git rev-parse --show-toplevel 2> /dev/null"
  if handle then
    local result = handle:read "*l"
    handle:close()
    return result
  end
  return nil
end
local additional_prompt_1 = [[
You are an agent - please keep going until the user’s query is completely resolved, before ending your turn and yielding back to the user. Only terminate your turn when you are sure that the problem is solved.]]

local additional_prompt_2 = [[
If you are not sure about file content or codebase structure pertaining to the user’s request, use your tools to read files and gather the relevant information: do NOT guess or make up an answer.]]

local additional_prompt_3 = [[
You MUST plan extensively before each function call, and reflect extensively on the outcomes of the previous function calls. DO NOT do this entire process by making function calls only, as this can impair your ability to solve the problem and think insightfully.]]

-- Set workspace path to either Git root or current working directory
local workspace_path = get_git_root() or vim.fn.getcwd()
return {
  {
    "yetone/avante.nvim",
    event = "User AstroFile",
    version = false, -- Never set this value to "*"! Never!
    build = "make",
    cmd = {
      "AvanteAsk",
      "AvanteBuild",
      "AvanteEdit",
      "AvanteRefresh",
      "AvanteSwitchProvider",
      "AvanteChat",
      "AvanteToggle",
      "AvanteClear",
    },
    opts = {
      -- add any opts here
      -- for example
      provider = "gemini", -- default provider
      auto_suggestions_provider = "copilot",

      cursor_applying_provider = "groq_llama_70",

      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-7-sonnet-20250219",
        temperature = 0,
        max_tokens = 8192,
      },

      gemini = {
        model = "gemini-2.5-pro-exp-03-25",
        max_tokens = 65536,
      },

      vendors = {
        groq_deepseek_r1 = {
          __inherited_from = "openai",
          api_key_name = "GROQ_API_KEY",
          endpoint = "https://api.groq.com/openai/v1/",
          model = "deepseek-r1-distill-llama-70b",
          max_completion_tokens = 32768,
          reasoning_format = "hidden",
          tool_choice = "auto",
        },
        groq_llama_70 = {
          __inherited_from = "openai",
          api_key_name = "GROQ_API_KEY",
          endpoint = "https://api.groq.com/openai/v1/",
          model = "llama-3.3-70b-versatile",
          max_completion_tokens = 32768,
          tool_choice = "auto",
        },
      },

      -- dual_boost = {
      --   enabled = true,
      --   first_provider = "claude",
      --   second_provider = "gemini",
      --   prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
      --   timeout = 60000, -- Timeout in milliseconds
      -- },

      web_search_engine = {
        provider = "tavily", -- tavily, serpapi, searchapi, google or kagi
      },

      rag_service = {
        enabled = true, -- Set to true to enable it
        host_mount = workspace_path, -- Or adjust path as needed (e.g., "/")
        provider = "openai", -- CHOOSE EITHER "openai" OR "ollama" HERE
        -- For OpenAI:
        endpoint = "https://api.openai.com/v1",
        llm_model = "", -- Optional: specify a model for RAG tasks if needed
        embed_model = "text-embedding-3-small", -- Optional: specify an embedding model
      },

      system_prompt = function()
        -- This is the initial default prompt if mcphub fails
        local default_prompt = [[You are an expert coding assistant. Respond with valid JSON when tools are used.]]

        -- This variable will hold the prompt determined by the logic below
        local base_prompt = default_prompt

        -- Attempt to get the prompt from mcphub
        local ok, hub, mcphub, prompt_from_hub

        ok, mcphub = pcall(require, "mcphub")
        if ok then -- mcphub required successfully
          ok, hub = pcall(mcphub.get_hub_instance)
          if ok and hub then -- hub instance obtained successfully
            ok, prompt_from_hub = pcall(hub.get_active_servers_prompt, hub)
            if ok and prompt_from_hub then -- prompt fetched successfully
              -- If we successfully got the prompt from the hub, use it as the base
              base_prompt = prompt_from_hub
            end
          end
        end
        -- If any pcall failed along the way, base_prompt remains default_prompt

        -- Concatenate the base prompt with the additional instructions
        -- We add newline characters (\n) for better separation
        local final_prompt = base_prompt
          .. "\n"
          .. additional_prompt_1
          .. "\n"
          .. additional_prompt_2
          .. "\n"
          .. additional_prompt_3

        -- Return the combined prompt
        return final_prompt
      end,

      custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
          -- add more custom tools here
        }
      end,

      disabled_tools = {
        "list_files",
        "search_files",
        "read_file",
        "create_file",
        "rename_file",
        "delete_file",
        "create_dir",
        "rename_dir",
        "delete_dir",
        "bash",
        "python",
        "fetch",
        "execute_lua",
      },

      behaviour = {
        auto_suggestions = false, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
        enable_token_counting = true, -- Whether to enable token counting. Default to true.
        enable_cursor_planning_mode = true, -- Whether to enable Cursor Planning Mode. Default to false.
        enable_claude_text_editor_tool_mode = false, -- Whether to enable Claude Text Editor Tool Mode.
      },

      file_selector = {
        provider = "snacks",
        provider_opts = {},
      },

      mappings = {
        ask = prefix .. "<CR>",
        edit = prefix .. "e",
        refresh = prefix .. "r",
        focus = prefix .. "f",
        select_model = prefix .. "?",
        stop = prefix .. "S",
        select_history = prefix .. "h",
        submit = {
          insert = "<C-CR>",
        },
        toggle = {
          default = prefix .. "t",
          debug = prefix .. "d",
          hint = prefix .. "h",
          suggestion = prefix .. "s",
          repomap = prefix .. "R",
        },
        diff = {
          next = "]c",
          prev = "[c",
        },
        files = {
          add_current = prefix .. ".",
          add_all_buffers = prefix .. "B",
        },
      },
    },
    specs = { -- configure optional plugins
      { "AstroNvim/astroui", opts = { icons = { Avante = "" } } },
      {
        -- make sure `Avante` is added as a filetype
        "MeanderingProgrammer/render-markdown.nvim",
        optional = true,
        opts = function(_, opts)
          if not opts.file_types then opts.file_types = { "markdown" } end
          opts.file_types = require("astrocore").list_insert_unique(opts.file_types, { "Avante" })
        end,
      },
      {
        -- make sure `Avante` is added as a filetype
        "OXY2DEV/markview.nvim",
        optional = true,
        opts = function(_, opts)
          if not opts.filetypes then opts.filetypes = { "markdown", "quarto", "rmd" } end
          opts.filetypes = require("astrocore").list_insert_unique(opts.filetypes, { "Avante" })
        end,
      },
      {
        "nvim-neo-tree/neo-tree.nvim",
        optional = true,
        opts = {
          filesystem = {
            commands = {
              avante_add_files = function(state)
                local node = state.tree:get_node()
                local filepath = node:get_id()
                local relative_path = require("avante.utils").relative_path(filepath)

                local sidebar = require("avante").get()

                local open = sidebar:is_open()
                -- ensure avante sidebar is open
                if not open then
                  require("avante.api").ask()
                  sidebar = require("avante").get()
                end

                sidebar.file_selector:add_selected_file(relative_path)

                -- remove neo tree buffer
                if not open then sidebar.file_selector:remove_selected_file "neo-tree filesystem [1]" end
              end,
            },
          },
          window = {
            mappings = {
              ["oa"] = "avante_add_files",
            },
          },
        },
      },
    },

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim",
      { "AstroNvim/astrocore", opts = function(_, opts) opts.mappings.n[prefix] = { desc = " Avante" } end },
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "saghen/blink.cmp",
      "nvim-tree/nvim-web-devicons",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = false,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },

  {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy",
    opts = {
      keymaps = {
        accept_suggestion = "<C-l>",
        clear_suggestion = "<C-h>",
        accept_word = "<C-w>",
      },
      log_level = "warn",
      disable_inline_completion = false, -- disables inline completion for use with cmp
      disable_keymaps = false, -- disables built in keymaps for more manual control
    },
  },

  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "User AstroFile",
  --   opts = { -- Add the 'opts' table for configuration
  --     suggestion = {
  --       auto_trigger = true,
  --       debounce = 75,
  --       keymap = {
  --         accept = "<C-g>", -- Set Ctrl+G to accept suggestions
  --       },
  --     },
  --   },
  -- },

  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
    },
    -- comment the following line to ensure hub will be ready at the earliest
    cmd = "MCPHub", -- lazy load by default
    build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
    -- uncomment this if you don't want mcp-hub to be available globally or can't use -g
    -- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
    config = function()
      require("mcphub").setup {
        auto_approve = true,
      }
    end,
  },
}
