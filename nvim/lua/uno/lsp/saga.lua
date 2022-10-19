-- LSP Saga
require("lspsaga").init_lsp_saga({
	use_saga_diagnostic_sign = true,
	error_sign = "",
	warn_sign = "",
	hint_sign = "",
	infor_sign = "",
	diagnostic_header_icon = "   ",
	code_action_icon = " ",
	code_action_prompt = {
		enable = true,
		sign = true,
		sign_priority = 20,
		virtual_text = true,
	},
	finder_definition_icon = "  ",
	finder_reference_icon = "  ",
	max_preview_lines = 10, -- preview lines of lsp_finder and definition preview
	finder_action_keys = {
		open = "o",
		vsplit = "s",
		split = "i",
		quit = "q",
		scroll_down = "<C-f>",
		scroll_up = "<C-b>", -- quit can be a table
	},
	code_action_keys = {
		quit = "q",
		exec = "<CR>",
	},
	rename_action_keys = {
		quit = "<C-c>",
		exec = "<CR>", -- quit can be a table
	},
	definition_preview_icon = "  ",
	-- "single" "double" "round" "plus"
	border_style = "single",
	rename_prompt_prefix = "➤",
	-- if you don't use nvim-lspconfig you must pass your server name and
	-- the related filetypes into this table
	-- like server_filetype_map = {metals = {'sbt', 'scala'}}
	-- server_filetype_map = {}
})

-- replace the default lsp diagnostic letters with prettier symbols
vim.fn.sign_define("LspDiagnosticsSignError", { text = "", numhl = "LspDiagnosticsDefaultError" })
vim.fn.sign_define("LspDiagnosticsSignWarning", { text = "", numhl = "LspDiagnosticsDefaultWarning" })
vim.fn.sign_define("LspDiagnosticsSignInformation", { text = "", numhl = "LspDiagnosticsDefaultInformation" })
vim.fn.sign_define("LspDiagnosticsSignHint", { text = "", numhl = "LspDiagnosticsDefaultHint" })

-- Set keybindings
local snore = { noremap = true, silent = true }

vim.keymap.set("n", "gh", require("lspsaga.provider").lsp_finder, snore)
vim.keymap.set("n", "<Leader>ca", require("lspsaga.codeaction").code_action, snore)
-- old action ":<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>",
vim.keymap.set("v", "<Leader>ca", require("lspsaga.codeaction").range_code_action, snore)
vim.keymap.set("n", "H", require("lspsaga.hover").render_hover_doc, snore)
vim.keymap.set("n", "gs", require("lspsaga.signaturehelp").signature_help, snore)
vim.keymap.set("n", "K", require("lspsaga.provider").preview_definition, snore)
vim.keymap.set("n", "<Leader>cd", require("lspsaga.diagnostic").show_line_diagnostics, snore)
vim.keymap.set("n", "<C-f>", function()
	-- Scroll up
	require("lspsaga.action").smart_scroll_with_saga(1)
end, snore)
vim.keymap.set("n", "<C-b>", function()
	-- Scroll down
	require("lspsaga.action").smart_scroll_with_saga(-1)
end, snore)
