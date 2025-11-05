if true then
	return {}
end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
	"folke/sidekick.nvim",
	-- Set event to "VeryLazy" to defer loading until needed
	event = "VeryLazy",
	-- Configure the plugin's options
	opts = function()
		-- Since you use opencode, we can ensure its settings are here.
		-- Note: 'opencode' is already a default tool, so you don't *have* to add it,
		-- but this shows you where you could customize it if needed.
		return {
			cli = {
				-- Optional: if you use tmux or zellij and want persistent sessions
				-- mux = {
				--   backend = "zellij", -- or "tmux"
				--   enabled = true,
				-- },

				-- The 'tools' table is where AI CLIs are defined.
				tools = {
					-- 'opencode' is pre-configured by the plugin, but you can override it here.
					-- The HACK for the theme is already included by default.
					opencode = {
						cmd = { "opencode" },
						env = { OPENCODE_THEME = "system" },
						url = "https://github.com/sst/opencode",
					},
					-- You can add or modify other tools here as well
					-- e.g., gemini = { cmd = { "gemini" } },
				},
			},
		}
	end,
	-- Set up the recommended keymaps
	keys = {
		{
			"<leader>aa",
			function()
				require("sidekick.cli").toggle({ focus = true })
			end,
			desc = "Sidekick: Toggle AI CLI",
		},
		{
			"<leader>as",
			function()
				-- Select only from tools you have installed
				require("sidekick.cli").select({ filter = { installed = true } })
			end,
			desc = "Sidekick: Select AI CLI",
		},
		{
			"<leader>ap",
			function()
				require("sidekick.cli").prompt()
			end,
			mode = { "n", "x" },
			desc = "Sidekick: Select Prompt",
		},
		{
			"<leader>at",
			function()
				require("sidekick.cli").send({ msg = "{this}" })
			end,
			mode = { "n", "x" },
			desc = "Sidekick: Send 'this' to AI", -- 'this' is cursor position or selection
		},
		{
			"<leader>av",
			function()
				require("sidekick.cli").send({ msg = "{selection}" })
			end,
			mode = "x",
			desc = "Sidekick: Send Visual Selection to AI",
		},
		{
			"<c-.>",
			function()
				require("sidekick.cli").focus()
			end,
			mode = { "n", "x", "i", "t" },
			desc = "Sidekick: Switch Focus",
		},
		-- Example of a keybinding to open 'opencode' directly
		{
			"<leader>a<cr>",
			function()
				require("sidekick.cli").toggle({ name = "opencode", focus = true })
			end,
			desc = "Sidekick: Toggle Opencode CLI",
		},
	},
}
