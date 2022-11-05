require("aerial").setup({
	attach_mode = "global",
	backends = { "lsp", "treesitter", "markdown" },
	layout = {
		placement = "edge",
		min_width = { 35, 0.2 },
	},
	filter_kind = false,
	highlight_on_hover = true,
	nerd_font = true,
	show_guides = true,
	-- guides = {
	-- 	mid_item = "├ ",
	-- 	last_item = "└ ",
	-- 	nested_top = "│ ",
	-- 	whitespace = "  ",
	-- },

	-- Customize the characters used when show_guides = true
	guides = {
		-- When the child item has a sibling below it
		mid_item = "├─",
		-- When the child item is the last in the list
		last_item = "└─",
		-- When there are nested child guides to the right
		nested_top = "│ ",
		-- Raw indentation
		whitespace = "  ",
	},
	-- on_attach = function(bufnr)
	-- 	local winnr = vim.fn.bufwinid(bufnr)
	-- end,

	-- on_attach = function(bufnr)
	-- 	-- Jump forwards/backwards with '[y' and ']y'
	-- 	vim.keymap.set("n", "[y", "<cmd>AerialPrev<cr>", { buffer = bufnr, desc = "Previous Aerial" })
	-- 	vim.keymap.set("n", "]y", "<cmd>AerialNext<cr>", { buffer = bufnr, desc = "Next Aerial" })
	-- 	-- Jump up the tree with '[Y' or ']Y'
	-- 	vim.keymap.set("n", "[Y", "<cmd>AerialPrevUp<cr>", { buffer = bufnr, desc = "Previous and Up in Aerial" })
	-- 	vim.keymap.set("n", "]Y", "<cmd>AerialNextUp<cr>", { buffer = bufnr, desc = "Next and Up in Aerial" })
	-- end,
})
