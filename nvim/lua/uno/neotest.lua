local neotest_ns = vim.api.nvim_create_namespace("neotest")
vim.diagnostic.config({
	virtual_text = {
		format = function(diagnostic)
			local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
			return message
		end,
	},
}, neotest_ns)

local neotest = require("neotest")

neotest.setup({
	diagnostic = {
		enabled = true,
	},
	status = {
		virtual_text = true,
		signs = true,
	},
	strategies = {
		integrated = {
			width = 180,
		},
	},
	icons = {
		running_animated = {
			"",
			"🞅",
			"🞈",
			"🞉",
			"",
			"",
			"🞉",
			"🞈",
			"🞅",
			"",
		},
	},
	adapters = {
		require("neotest-go")({
			args = { "-count=1", "-timeout=60s", "-race", "-cover" },
		}),
		require("neotest-python")({
			dap = { justMyCode = false, console = "integratedTerminal" },
		}),
	},
})

local lib = require("neotest.lib")
local get_env = function()
	local env = {}
	local file = ".env"
	if not lib.files.exists(file) then
		return {}
	end

	for _, line in ipairs(vim.fn.readfile(file)) do
		for name, value in string.gmatch(line, "(.+)=['\"]?(.*)['\"]?") do
			local str_end = string.sub(value, -1, -1)
			if str_end == "'" or str_end == '"' then
				value = string.sub(value, 1, -2)
			end

			env[name] = value
		end
	end
	return env
end

local mappings = {
	["<leader>nr"] = function()
		neotest.run.run(vim.fn.getcwd(), { suite = true, env = get_env() })
	end,
	["<leader>ns"] = function()
		for _, adapter_id in ipairs(neotest.run.adapters()) do
			neotest.run.run({ suite = true, adapter = adapter_id, env = get_env() })
		end
	end,
	["<leader>nw"] = function()
		neotest.watch.watch()
	end,
	["<leader>nx"] = function()
		neotest.run.stop()
	end,
	["<leader>nn"] = function()
		neotest.run.run({ env = get_env() })
	end,
	["<leader>nd"] = function()
		neotest.run.run({ strategy = "dap", env = get_env() })
	end,
	["<leader>nl"] = neotest.run.run_last,
	["<leader>nD"] = function()
		neotest.run.run_last({ strategy = "dap" })
	end,
	["<leader>na"] = neotest.run.attach,
	["<leader>no"] = function()
		neotest.output.open({ enter = true })
	end,
	["<leader>nO"] = function()
		neotest.output.open({ enter = true, short = true })
	end,
	["<leader>np"] = neotest.summary.toggle,
	["<leader>nm"] = neotest.summary.run_marked,
	["[n"] = function()
		neotest.jump.prev({ status = "failed" })
	end,
	["]n"] = function()
		neotest.jump.next({ status = "failed" })
	end,
}

for keys, mapping in pairs(mappings) do
	vim.api.nvim_set_keymap("n", keys, "", { callback = mapping, noremap = true })
end
