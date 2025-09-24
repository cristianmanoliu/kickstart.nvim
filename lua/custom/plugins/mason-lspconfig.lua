-- plugins/mason-lspconfig.lua
return {
	"mason-org/mason-lspconfig.nvim",
	dependencies = {
		"mason-org/mason.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function()
		local servers = {
			-- General purpose
			"bashls",
			"jsonls",
			"yamlls",
			"marksman",

			-- Web
			"html",
			"cssls",
			"ts_ls", -- (new name for tsserver)
			"emmet_ls",

			-- Python / Go / Rust
			"pyright",
			"gopls",
			"rust_analyzer",

			-- Lua (Neovim)
			"lua_ls",

			-- Java (baseline)
			"jdtls",
		}

		require("mason-lspconfig").setup({
			ensure_installed = servers,
			automatic_installation = true,
		})
	end,
}
