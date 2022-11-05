local M = {}

M.find_by_filetype = function(filetype)
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) then
			if vim.api.nvim_buf_get_option(buf, "ft") == filetype then
				return buf
			end
		end
	end
	return -1
end

-- Move a window with one filetype to another
-- @param source string "Outline"
-- @param target string "NvimTree"
M.move_outline = function(source, target, opts)
	-- Fetch buffers from file type
	local target_buf = M.find_by_filetype(target)
	local source_buf = M.find_by_filetype(source)

	-- If no buffers found, exit
	if target_buf == -1 or source_buf == -1 then
		return
	end

	-- Get windows
	local source_win = vim.fn.bufwinid(source_buf)
	local target_win = vim.fn.bufwinid(target_buf)

	-- Create new window below target window, with existing buffer
	local split_opts = { vertical = false, rightbelow = true }
	vim.fn.win_splitmove(source_win, target_win, split_opts)

	-- Resize new window
	local height, width = 30, 35
	if type(opts) == "table" and opts.height ~= nil then
		height = opts.height
	end
	if type(opts) == "table" and opts.height ~= nil then
		height = opts.width
	end

	local new_win = vim.fn.bufwinid(source_buf)
	vim.api.nvim_win_set_height(new_win, height)
	vim.api.nvim_win_set_width(new_win, width)
end

local au_group = "SidebarLayout"
vim.api.nvim_create_augroup("SidebarLayout", { clear = true })

M.create_au_cmd = function(source, target)
	-- Lua
	vim.api.nvim_create_autocmd("FileType", {
		pattern = source,
		callback = function()
			M.move_outline(source, target)
		end,
		group = au_group,
	})
end

-- M.create_au_cmd("Outline", "NvimTree")
-- M.create_au_cmd("aerial", "NvimTree")
-- M.create_au_cmd("neotest-summary", "Outline")

return M
