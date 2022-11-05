-- Get Highlight Undeer Cursor:
-- execute 'hi' synIDattr(synID(line("."), col("."), 1), "name")

package.loaded["lush_theme.pywal"] = nil
require("lush")(require("themes.pywal"))
vim.cmd("colorscheme pywal")

-- Make sure to only update colors once theme has changed
local has_run = false

local reload = function()
	package.loaded["themes.pywal"] = nil
	require("lush")(require("themes.pywal"))
	vim.schedule(function()
		vim.cmd("colorscheme pywal")
	end)

	-- Reset the lock so we can update again
	vim.defer_fn(function()
		has_run = false
	end, 500)
end

-- Watch pywal cache file for color changes
local fwatch = require("fwatch")
fwatch.watch(vim.fn.expand("$HOME") .. "/.cache/wal/colors", {
	on_event = function()
		-- Only update if not updated in 500 millis
		if has_run then
			return
		end
		has_run = true

		-- Reapply colorscheme 200ms after file changed
		-- vim.defer_fn(reload, 100)
		vim.schedule(reload)
	end,
})
