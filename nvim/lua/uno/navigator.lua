require("navigator").setup({
	mason = true,
	default_mapping = false,
	lsp = {
		enable = true,
		disable_lsp = "all",
		format_on_save = { disable = { "lua" } },
		diagnostic_scrollbar_sign = false,
	},
	icons = {
		icons = true, -- set to false to use system default ( if you using a terminal does not have nerd/icon)
		-- Code action
		code_action_icon = "", -- "",
		-- code lens
		code_lens_action_icon = "",
		-- Diagnostics
		diagnostic_head = "",
		diagnostic_err = "",
		diagnostic_warn = "",
		diagnostic_info = [[]],
		diagnostic_hint = [[]],

		diagnostic_head_severity_1 = "",
		diagnostic_head_severity_2 = "",
		diagnostic_head_severity_3 = "",
		diagnostic_head_description = "",
		diagnostic_virtual_text = ">>",
		diagnostic_file = "",
		-- Values
		value_changed = "",
		value_definition = "", -- it is easier to see than 🦕
		side_panel = {
			section_separator = "",
			line_num_left = "",
			line_num_right = "",
			inner_node = "├○",
			outer_node = "╰○",
			bracket_left = "⟪",
			bracket_right = "⟫",
		},
		-- Treesitter
		match_kinds = {
			var = " ",
			method = "ƒ ",
			["function"] = " ",
			parameter = "  ",
			associated = "🤝",
			namespace = "ns:",
			type = " ",
			field = "  >",
			module = "📦",
			flag = "🎏",
		},
		treesitter_defult = "🌲",
		doc_symbols = "",
	},
})

vim.cmd("autocmd FileType guihua lua require('cmp').setup.buffer { enabled = false }")
vim.cmd("autocmd FileType guihua_rust lua require('cmp').setup.buffer { enabled = false }")

-- Deleted some keymaps I don't need
local key_maps = {
	{ key = "gr", func = require("navigator.reference").async_ref, desc = "async_ref" },
	{ key = "<Leader>gr", func = require("navigator.reference").reference, desc = "reference" }, -- reference deprecated
	{ mode = "i", key = "<M-k>", func = vim.lsp.signature_help, desc = "signature_help" },
	{ key = "<c-k>", func = vim.lsp.buf.signature_help, desc = "signature_help" },
	{ key = "g0", func = require("navigator.symbols").document_symbols, desc = "document_symbols" },
	{ key = "gW", func = require("navigator.workspace").workspace_symbol_live, desc = "workspace_symbol_live" },
	{ key = "<c-]>", func = require("navigator.definition").definition, desc = "definition" },
	{ key = "gd", func = require("navigator.definition").definition, desc = "definition" },
	{ key = "gD", func = vim.lsp.buf.declaration, desc = "declaration" },
	{ key = "gp", func = require("navigator.definition").definition_preview, desc = "definition_preview" },
	{ key = "<Leader>st", func = require("navigator.treesitter").buf_ts, desc = "buf_ts" },
	{ key = "<Leader>sT", func = require("navigator.treesitter").bufs_ts, desc = "bufs_ts" },
	{ key = "<Leader>ct", func = require("navigator.ctags").ctags, desc = "ctags" },
	{ key = "K", func = vim.lsp.buf.hover, desc = "hover" },
	{ mode = "n", key = "<Space>ca", func = require("navigator.codeAction").code_action, desc = "code_action" },
	{
		mode = "v",
		key = "<Space>ca",
		func = require("navigator.codeAction").range_code_action,
		desc = "range_code_action",
	},
	-- { key = '<Leader>re', func = 'rename()' },
	{ key = "<Space>rn", func = require("navigator.rename").rename, desc = "rename" },
	{ key = "<Leader>gi", func = vim.lsp.buf.incoming_calls, desc = "incoming_calls" },
	{ key = "<Leader>go", func = vim.lsp.buf.outgoing_calls, desc = "outgoing_calls" },
	{ key = "gi", func = vim.lsp.buf.implementation, desc = "implementation" },
	{ key = "<Space>D", func = vim.lsp.buf.type_definition, desc = "type_definition" },
	{ key = "gL", func = require("navigator.diagnostics").show_diagnostics, desc = "show_diagnostics" },
	{ key = "gG", func = require("navigator.diagnostics").show_buf_diagnostics, desc = "show_buf_diagnostics" },
	{ key = "<Leader>dt", func = require("navigator.diagnostics").toggle_diagnostics, desc = "toggle_diagnostics" },
	{ key = "]d", func = vim.diagnostic.goto_next, desc = "next diagnostics" },
	{ key = "[d", func = vim.diagnostic.goto_prev, desc = "prev diagnostics" },
	{ key = "]O", func = vim.diagnostic.set_loclist, desc = "diagnostics set loclist" },
	{ key = "]r", func = require("navigator.treesitter").goto_next_usage, desc = "goto_next_usage" },
	{ key = "[r", func = require("navigator.treesitter").goto_previous_usage, desc = "goto_previous_usage" },
	{ key = "<C-LeftMouse>", func = vim.lsp.buf.definition, desc = "definition" },
	{ key = "g<LeftMouse>", func = vim.lsp.buf.implementation, desc = "implementation" },
	{ key = "<Leader>k", func = require("navigator.dochighlight").hi_symbol, desc = "hi_symbol" },
	{ key = "<Space>wa", func = require("navigator.workspace").add_workspace_folder, desc = "add_workspace_folder" },
	{
		key = "<Space>wr",
		func = require("navigator.workspace").remove_workspace_folder,
		desc = "remove_workspace_folder",
	},
	{
		key = "<Space>gm",
		func = require("navigator.formatting").range_format,
		mode = "n",
		desc = "range format operator e.g gmip",
	},
	{
		key = "<Space>wl",
		func = require("navigator.workspace").list_workspace_folders,
		desc = "list_workspace_folders",
	},
	{ key = "<Space>la", mode = "n", func = require("navigator.codelens").run_action, desc = "run code lens action" },
}

-- Copied from plugin
local opts = { noremap = true, silent = true }
for _, value in pairs(key_maps) do
	if type(value.func) == "string" then -- deprecated will remove when 0.8 is out
		local f = "<Cmd>lua vim.lsp.buf." .. value.func .. "<CR>"
		if string.find(value.func, "require") or string.find(value.func, "vim.") then
			f = "<Cmd>lua " .. value.func .. "<CR>"
		elseif string.find(value.func, "diagnostic") then
			local diagnostic = "<Cmd>lua vim."
			diagnostic = "<Cmd>lua vim."
			f = diagnostic .. value.func .. "<CR>"
		end

		local k = value.key
		local m = value.mode or "n"
		vim.api.set_keymap(m, k, f, opts)
	end

	if type(value.func) == "function" then
		if value.desc then
			opts.desc = value.desc
		end
		vim.keymap.set(value.mode or "n", value.key, value.func, opts)
	end
end
