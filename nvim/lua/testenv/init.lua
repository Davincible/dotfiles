local id = 0
local name = "MyHi_"
while true do
	vim.cmd("hi " .. name .. id .. " guifg=#fff guibg=#ff0000")
	id = id + 1
end
