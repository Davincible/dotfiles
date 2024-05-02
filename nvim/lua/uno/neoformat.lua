-- vim.g.neoformat_enabled_json = { "prettier" }
-- vim.g.neoformat_enabled_lua = { "stylua" }
-- -- vim.g.neoformat_enabled_sql = { "pg_format" }
vim.g.neoformat_enabled_json = { "prettier" }
vim.g.neoformat_enabled_javascript = { "prettier" }
-- vim.g.neoformat_enabled_python = { "black" }
--
-- local fg = vim.api.nvim_create_augroup("Neoformat", { clear = true })
-- -- General formater
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = { "*.sql", "*.lua", "*.json", "*.css", "Tiltfile", "*.js", "*.jsx", "*.proto", "*.py", "*.html" },
-- 	command = "Neoformat",
-- 	group = fg,
-- })

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
local config = {
	logging = true,
	log_level = vim.log.levels.WARN,
	filetype = vim.tbl_deep_extend("force", require("formatter.filetypes"), {
		lua = require("formatter.filetypes.lua").stylua,
		go = require("formatter.filetypes.go").goimports,
		sql = {
			function()
				local config = [[
          {
            "language": "postgresql",
            "tabWidth": 2,
            "keywordCase": "upper",
            "linesBetweenQueries": 2,
            "paramTypes": { "named": ["@", "sqlc.narg"] }
          }
				]]

				local file = string.format("<(echo '%s')", config)

				return {
					exe = "sql-formatter",
					args = {
						"--config",
						file,
					},
					stdin = true,
				}
			end,
		},
		-- 	Dockerfile = {
		-- 		function()
		-- 			return {
		-- 				exe = "dockfmt",
		-- 				args = {
		-- 					"fmt",
		-- 				},
		-- 				stdin = true,
		-- 			}
		-- 		end,
		-- 	},
	}),
}

require("formatter").setup(config)

local fg = vim.api.nvim_create_augroup("Neoformat", { clear = true })
-- General formater
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = { "*" },
	callback = function()
		if vim.bo.filetype == "sql" then
			return
		end

		if vim.bo.filetype == "go" then
			vim.cmd("Neoformat")
			vim.cmd("w")
			return
		end

		vim.cmd("FormatWrite")
	end,
	group = fg,
})

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

-- SQL tabs
local sg = vim.api.nvim_create_augroup("Sql", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sql" },
	callback = function()
		vim.bo.tabstop = 4
		vim.bo.softtabstop = 0
		vim.bo.shiftwidth = 2
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
