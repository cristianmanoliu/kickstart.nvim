-- plugins/luasnip.lua
return {
	"L3MON4D3/LuaSnip",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	build = (function()
		-- Build step is optional now; retain for old environments.
		return "make install_jsregexp"
	end)(),
	config = function()
		local ls = require("luasnip")

		ls.config.set_config({
			history = true,
			updateevents = "TextChanged,TextChangedI",
			enable_autosnippets = true,
		})

		-- Load VSCode-style snippets lazily
		require("luasnip.loaders.from_vscode").lazy_load()
	end,
}
