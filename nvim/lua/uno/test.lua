-- bufexists({expr})
-- bufname(
-- bufnr(
-- bufwinid(

local M = {}

-- https://github.com/nvim-neo-tree/neo-tree.nvim/blob/e968cda658089b56ee1eaa1772a2a0e50113b902/lua/neo-tree/utils.lua#L157-L165
M.find_buffer_by_name = function(name)
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local buf_name = vim.api.nvim_buf_get_name(buf)
		if buf_name == name then
			return buf
		end
	end
	return -1
end

M.is_floating = function(win_id)
	win_id = win_id or vim.api.nvim_get_current_win()
	local cfg = vim.api.nvim_win_get_config(win_id)
	if cfg.relative > "" or cfg.external then
		return true
	end
	return false
end

M.list_names = function()
	local names = {}
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) then
			local buf_name = vim.api.nvim_buf_get_name(buf)
			names[buf_name] = { id = buf }
			names[buf_name].IS_HIDDEN = vim.fn.getbufinfo(buf)[1].hidden == 1
			names[buf_name].FILETYPE = vim.api.nvim_buf_get_option(buf, "ft")
		end
	end
	print(vim.inspect(names))
end

require("aerial.window").open_aerial_in_win(33, 1000, 1017)

return M

-- nvim_get_current_buf()
-- nvim_get_current_win()
-- nvim_list_bufs()
-- nvim_list_wins()
-- nvim_set_current_win({window})
-- nvim_subscribe({event})
-- nvim_buf_attach({buffer},
-- nvim_buf_get_name({buffer})
-- nvim_open_win({buffer},
-- nvim_win_set_config({window},
--
-- nvim_buf_get_option(id, 'ft') > NvimTree
