require("go").setup({
	verbose = true,
	-- 	gopls_cmd = {
	-- 		"/usr/bin/gopls",
	-- 		"-remote=auto",
	-- 		"-listen.timeout=5m",
	-- --		"-logfile=" .. vim.fn.expand("~/.cache/nvim/gopls.log"),
	-- 	},
	log_path = vim.fn.expand("$HOME") .. "/.cache/nvim/gonvim.log",
	comment_placeholder = " ",
	gofmt = "gofmt", -- if set to gopls will use gopls format
	test_runner = "richgo",
	lsp_cfg = false,
	lsp_keymaps = false,
	icons = { breakpoint = "🔺", currentpos = "♥️" }, -- set to false to disable
	run_in_floaterm = false, -- set to true to run in float window.
	dap_debug = true,
	dap_debug_keymap = false,
	trouble = true,
	luasnip = true,
})

local gofmt = function()
	vim.notify("Running formatter")
	require("go.format").goimport(true)
end

local snore = { noremap = true, silent = true }
local _go = vim.api.nvim_create_augroup("GoSettings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function()
		vim.bo.expandtab = false
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2

		vim.keymap.set("n", "<Leader>gr", ":GoRun<CR>", snore)
		vim.keymap.set("n", "<Leader>gb", ":GoBuild<CR>", snore)
		vim.keymap.set("n", "<Leader>gl", ":GoLint<CR>", snore)
		vim.keymap.set("n", "<Leader>gt", ":GoTest -C coverage.out<CR>", snore)
		vim.keymap.set("n", "<Leader>gc", require("go.comment").gen, snore)
		vim.keymap.set("n", "<Leader>gs", ":GoFillStruct<CR>", snore)
		vim.keymap.set("n", "<Leader>gdb", ":GoDebug<CR>", snore)
		vim.keymap.set("n", "<Leader>gdt", ":GoBreakToggle<CR>", snore)

		vim.api.nvim_create_user_command("GoFmt", gofmt, { force = true })
		vim.api.nvim_create_user_command("Gtn", "TestNearest -v -tags=integration", { force = true })
		vim.api.nvim_create_user_command("Gts", "TestSuite -v -tags=integration", { force = true })
	end,
	group = _go,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	command = "GoImport",
	group = _go,
})
