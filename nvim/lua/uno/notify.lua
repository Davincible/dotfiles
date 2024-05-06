require("notify").setup({
	-- Animation style (see below for details)
	stages = "fade_in_slide_out",
	-- Function called when a new window is opened, use for changing win settings/config
	on_open = nil,
	-- Function called when a window is closed
	on_close = nil,
	-- Render function for notifications. See notify-render()
	render = "default",
	-- Default timeout for notifications
	timeout = 5000,
	-- Max number of columns for messages
	max_width = nil,
	-- Max number of lines for a message
	max_height = nil,
	-- For stages that change opacity this is treated as the highlight behind the window
	-- Set this to either a highlight group, an RGB hex value e.g. "#000000" or a function returning an RGB code for dynamic values
	background_colour = "#121212",
	-- Minimum width for notification windows
	minimum_width = 50,
	-- Icons for the different levels
	icons = {
		ERROR = "",
		WARN = "",
		INFO = "",
		DEBUG = "",
		TRACE = "✎",
	},
})

local function starts_with(str, start)
	return str:sub(1, #start) == start
end

vim.notify = function(msg, level, opts)
	local d = debug.getinfo(2)

	vim.schedule(function()
		opts = opts or {}

		-- Don't overwrite title
		-- if opts["title"] == nil then
		-- 	-- Get caller info
		-- 	opts["title"] = "(Source) " .. d.source
		--
		-- 	-- Extract path
		-- 	local possible_matches = {
		-- 		{
		-- 			path = "@" .. vim.fn.expand("$HOME") .. "/.local/share/nvim/site/pack/packer/start/",
		-- 			prefix = "(Plugin) ",
		-- 		},
		-- 		{
		-- 			path = "@" .. vim.fn.expand("$HOME") .. "/.local/share/nvim/site/pack/packer/opt/",
		-- 			prefix = "(Plugin) ",
		-- 		},
		-- 		{
		-- 			path = "@" .. vim.fn.expand("$HOME") .. "/.config/nvim/lua/uno/",
		-- 			prefix = "(Config) ",
		-- 		},
		-- 		{
		-- 			path = "@" .. "/usr/share/nvim/runtime/lua/",
		-- 			prefix = "(Nvim) ",
		-- 		},
		-- 	}
		--
		-- 	-- Set title
		-- 	for _, m in pairs(possible_matches) do
		-- 		if starts_with(d.source, m.path) then
		-- 			opts["title"] = m.prefix .. d.source:sub(#m.path + 1)
		-- 		end
		-- 	end
		-- end

		require("notify")(msg, level, opts)
	end)
end
