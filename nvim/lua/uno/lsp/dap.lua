require("mason-nvim-dap").setup({
	ensure_installed = { "python" },
    -- Will automatically install masons tools based on selected adapters in `dap`.
	automatic_installation = true,
})
