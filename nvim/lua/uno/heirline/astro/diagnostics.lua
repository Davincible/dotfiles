local signs = {
	{ name = "DiagnosticSignError", text = unoline.get_icon("DiagnosticError") },
	{ name = "DiagnosticSignWarn", text = unoline.get_icon("DiagnosticWarn") },
	{ name = "DiagnosticSignHint", text = unoline.get_icon("DiagnosticHint") },
	{ name = "DiagnosticSignInfo", text = unoline.get_icon("DiagnosticInfo") },
	{ name = "DiagnosticSignError", text = unoline.get_icon("DiagnosticError") },
	{ name = "DapStopped", text = unoline.get_icon("DapStopped"), texthl = "DiagnosticWarn" },
	{ name = "DapBreakpoint", text = unoline.get_icon("DapBreakpoint"), texthl = "DiagnosticInfo" },
	{ name = "DapBreakpointRejected", text = unoline.get_icon("DapBreakpointRejected"), texthl = "DiagnosticError" },
	{ name = "DapBreakpointCondition", text = unoline.get_icon("DapBreakpointCondition"), texthl = "DiagnosticInfo" },
	{ name = "DapLogPoint", text = unoline.get_icon("DapLogPoint"), texthl = "DiagnosticInfo" },
}

for _, sign in ipairs(signs) do
	if not sign.texthl then
		sign.texthl = sign.name
	end
	vim.fn.sign_define(sign.name, sign)
end

unoline.lsp.diagnostics = {
	off = {
		underline = false,
		virtual_text = false,
		signs = false,
		update_in_insert = false,
	},
	on = unoline.user_plugin_opts("diagnostics", {
		virtual_text = true,
		signs = { active = signs },
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focused = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}),
}

vim.diagnostic.config(unoline.lsp.diagnostics[vim.g.diagnostics_enabled and "on" or "off"])
