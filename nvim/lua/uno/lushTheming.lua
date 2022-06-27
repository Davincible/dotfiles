local lush = require("lush")

-- Get Highlight Undeer Cursor:
-- execute 'hi' synIDattr(synID(line("."), col("."), 1), "name")

lush(require("themes.pywal"))
vim.cmd("colorscheme pywal")

-- Watch pywal cache file for color changes
local fwatch = require("fwatch")
fwatch.watch(
    "/home/tyler/.cache/wal/colors",
    {
        on_event = function()
            -- Reapply colorscheme 200ms after file changed
            vim.defer_fn(
                function()
                    package.loaded["themes.pywal"] = nil
                    require("lush")(require("themes.pywal"))
                    vim.cmd("colorscheme pywal")
                end,
                200
            )
        end
    }
)
