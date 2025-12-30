---@type LazySpec
return {
	"A7Lavinraj/fyler.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{
			"<Leader>e",
			function()
				require("fyler").toggle()
			end,
			desc = "Toggle Fyler",
		},
	},
	opts = {
		integrations = {
			icon = "nvim_web_devicons",
		},
		views = {
			finder = {
				default_explorer = true,
				delete_to_trash = true,
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
				watcher = {
					enabled = true,
				},
				win = {
					kind = "split_left_most",
					border = "rounded",
					kinds = {
						split_left_most = {
							width = 30,
						},
					},
				},
			},
		},
	},
}
