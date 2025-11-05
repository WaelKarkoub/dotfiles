---@type LazySpec
return {
	"A7Lavinraj/fyler.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{
			"<Leader>e",
			function()
				local win_id = vim.fn.bufwinid("fyler")
				if win_id ~= -1 then
					vim.api.nvim_win_close(win_id, true)
				else
					require("fyler").open()
				end
			end,
			desc = "Toggle Fyler",
		},
	},
	opts = {
		git_status = {
			enabled = true,
		},
		icon = {
			directory_collapsed = "",
			directory_empty = "",
			directory_expanded = "",
		},
		indentscope = {
			enabled = true,
			marker = "│",
		},
		-- Fyler options are configured here
		-- For a full list of options, see: https://github.com/A7Lavinraj/fyler.nvim#configuration
		win = {
			kind = "split_left",
			border = "rounded",
			kind_presets = {
				split_left = {
					width = "30abs",
				},
			},
		},
		icon_provider = "nvim_web_devicons",
	},
}
