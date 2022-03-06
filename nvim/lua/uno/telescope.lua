local telescope = require("telescope")
local actions = require("telescope.actions")

require("trouble").setup()
local trouble = require("trouble.providers.telescope")

local M = {}

telescope.setup {
    defaults = {
        -- find_command = {'rg', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--max-depth 5'},
        prompt_prefix = " ",
        -- prompt_prefix = " ",
        selection_caret = " ",
        entry_prefix = "  ",
        initial_mode = "insert",
        -- initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        layout_config = {
            prompt_position = "bottom",
            preview_cutoff = 120,
            horizontal = {width = 0.75, mirror = false},
            vertical = {mirror = false}
        },
        file_sorter = require "telescope.sorters".get_fzy_sorter,
        file_ignore_patterns = {
            "node_modules/",
            "vendor/",
            ".git/"
        },
        generic_sorter = require "telescope.sorters".get_generic_fuzzy_sorter,
        path_display = {"shorten"},
        winblend = 0,
        border = {},
        borderchars = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
        color_devicons = true,
        use_less = true,
        set_env = {["COLORTERM"] = "truecolor"}, -- default = nil,
        file_previewer = require "telescope.previewers".vim_buffer_cat.new,
        grep_previewer = require "telescope.previewers".vim_buffer_vimgrep.new,
        qflist_previewer = require "telescope.previewers".vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require "telescope.previewers".buffer_previewer_maker,
        mappings = {
            i = {
                ["<C-c>"] = actions.close,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<c-t>"] = trouble.open_with_trouble,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                -- To disable a keymap, put [map] = false
                -- So, to not map "<C-n>", just put
                -- ["<c-x>"] = false,
                -- ["<esc>"] = actions.close,

                -- Otherwise, just set the mapping to the function that you want it to be.
                -- ["<C-i>"] = actions.select_horizontal,

                -- Add up multiple actions
                ["<CR>"] = actions.select_default + actions.center

                -- You can perform as many actions in a row as you like
                -- ["<CR>"] = actions.select_default + actions.center + my_cool_custom_action,
            },
            n = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<c-t>"] = trouble.open_with_trouble,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist
                -- ["<C-i>"] = my_cool_custom_action,
            }
        }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true
        },
        media_files = {
            -- filetypes whitelist
            -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
            filetypes = {"png", "webp", "jpg", "jpeg", "pdf", "webm", "mp4"},
            find_cmd = "rg" -- find command (defaults to `fd`)
        },
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
        }
    }
}

require "telescope".load_extension("project")
require("telescope").load_extension("media_files")
require("telescope").load_extension("ui-select")
require("telescope").load_extension("tmuxinator")
require("telescope").load_extension("notify")
require("telescope").load_extension("file_browser")

M.find_files = function()
    require("telescope.builtin").find_files {
        find_command = {"fd", "--max-depth", "5", "--hidden", "--follow", "--type", "f"}
    }
end

vim.api.nvim_set_keymap("n", "<leader>ff", ':lua require("uno.telescope").find_files()<CR>', {silent = true})
vim.api.nvim_set_keymap("n", "<leader>fg", ':lua require("telescope.builtin").live_grep()<CR>', {silent = true})
vim.api.nvim_set_keymap("n", "<leader>fb", ':lua require("telescope.builtin").buffers()<CR>', {silent = true})
vim.api.nvim_set_keymap("n", "<leader>ft", ":Telescope file_browser<CR>", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>fh", ':lua require("telescope.builtin").help_tags()<CR>', {silent = true})
vim.api.nvim_set_keymap("n", "<leader>fr", ':lua require("telescope.builtin").lsp_references()<CR>', {silent = true})
vim.api.nvim_set_keymap("n", "<leader>fd", ':lua require("telescope.builtin").lsp_definitions()<CR>', {silent = true})
vim.api.nvim_set_keymap("n", "<leader>fm", ":Telescope media_files<CR>", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>fn", ":Telescope notify<CR>", {silent = true})
vim.api.nvim_set_keymap("n", "<C-p>", ':lua require("telescope.builtin").git_status()<CR>', {silent = true})

return M
