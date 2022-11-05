require("sessions").setup({
    events = { "WinEnter" },
    session_filepath = ".nvim/session",
})

require("workspaces").setup({
    hooks = {
        open = {
				function()
					require("sessions").load(nil, { silent = true })
				end,
				"NvimTreeOpen",
			},
    }
})
