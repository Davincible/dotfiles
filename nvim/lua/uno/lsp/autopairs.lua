---- Nvim-autopairs Setup
local npairs = require("nvim-autopairs")
npairs.setup({
	enable_check_bracket_line = false,
	ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
	check_ts = true,
	ts_config = {
		-- it will not add pair on that treesitter node
		lua = { "string" },
		javascript = { "template_string" },
		-- don't check treesitter on java
		java = false,
	},
})

local ts_conds = require("nvim-autopairs.ts-conds")

-- press % => %% is only inside comment or string
local Rule = require("nvim-autopairs.rule")
npairs.add_rules({
	Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
	--        Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({"function"})),
	--         try this but with ( instead of $, maybe the params are literal characters
	--         Rule("$", "$"):with_pair(ts_conds.is_not_ts_node({"import_statement", "import_specifier"}))
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
-- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({map_char = {tex = ""}}))

local ts_utils = require("nvim-treesitter.ts_utils")
cmp.event:on("confirm_done", function(evt)
	if ts_utils.get_node_at_cursor() then
		local name = ts_utils.get_node_at_cursor():type()
		-- and name ~= "argument_list"
		if name ~= "named_imports" and name ~= "argument_list" then
			cmp_autopairs.on_confirm_done({ map_char = { tex = "" } })(evt)
		end
	end
end)
