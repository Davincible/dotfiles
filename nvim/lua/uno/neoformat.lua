-- Load tilt file
local tg = vim.api.nvim_create_augroup("Tiltfile", { clear = true })
vim.api.nvim_create_autocmd("BufRead", {
	pattern = { "Tiltfile" },
	callback = function()
		vim.bo.filetype = "tiltfile"
		vim.bo.syntax = "python"
		--	vim.cmd([[vim.bo.syntax = "python"]])
	end,
	group = tg,
})

vim.g.neoformat_enabled_json = { "prettier" }
vim.g.neoformat_enabled_lua = { "stylua" }
vim.g.neoformat_enabled_sql = { "pg_format" }
vim.g.neoformat_enabled_json = { "prettier" }
vim.g.neoformat_enabled_python = { "black" }

local fg = vim.api.nvim_create_augroup("Neoformat", { clear = true })
-- General formater
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.sql", "*.lua", "*.json", "*.css", "Tiltfile", "*.js", "*.jsx", "*.proto", "*.py", "*.html" },
	command = "Neoformat",
	group = fg,
})

-- SQL tabs
local sg = vim.api.nvim_create_augroup("Sql", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sql" },
	callback = function()
		vim.bo.tabstop = 8
		vim.bo.softtabstop = 0
		vim.bo.shiftwidth = 4
		vim.bo.smartindent = true
		vim.bo.expandtab = true
	end,
	group = sg,
})

-- vim.api.nvim_exec([[ autocmd BufRead *.sql set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab ]], false)

vim.api.nvim_exec(
	[[ 
    aug i3config_ft_detection
  au!
  au BufNewFile,BufRead ~/.config/i3/config set filetype=i3config
aug end ]],
	false
)
