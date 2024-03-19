------------------------
-- Imports
------------------------
require("user.keybindings")
require("user.ghcopilot")

------------------------
-- General
------------------------
-- Format on save
lvim.format_on_save = true
-- Wrap lines
vim.opt.wrap = true
-- Disable breadcrumbs
lvim.builtin.breadcrumbs.active = false
-- Disable next line comment when pressing Enter or o
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "r", "o" })
	end,
})
-- Skip configured servers
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "gopls" })

------------------------
-- Theming
------------------------
lvim.colorscheme = "catppuccin-mocha"
lvim.builtin.lualine.options.theme = "catppuccin"

------------------------
-- Plugins
------------------------
lvim.plugins = {
	-- Mason Tool Installer
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	-- Coloscheme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			flavour = "mocha",
		},
	},
	-- Surround
	{
		"tpope/vim-surround",
	},
	-- Testing
	"nvim-neotest/neotest",
	-- Golang
	"olexsmir/gopher.nvim",
	"leoluz/nvim-dap-go",
	"nvim-neotest/neotest-go",
	-- Python
	"mfussenegger/nvim-dap-python",
	"nvim-neotest/neotest-python",
}

------------------------
-- Mason Tool Installer
------------------------
local mason_tool_installer = require("mason-tool-installer")
mason_tool_installer.setup({
	ensure_installed = {
		"delve",
		"gofumpt",
		"goimports",
		"golangci-lint-langserver",
		"gomodifytags",
		"gopls",
		"gotests",
		"impl",
		"staticcheck",
		"stylua",
		"tsserver",
		"tailwindcss",
		"black",
		"isort",
		"pyright",
		"debugpy",
		"prettier",
		"jdtls",
		"google-java-format",
	},
	auto_update = true,
})

------------------------
-- Treesitter
------------------------
lvim.builtin.treesitter.ensure_installed = {
	"go",
	"gomod",
	"lua",
	"python",
	"typescript",
	"javascript",
	"json",
	"yaml",
	"html",
	"css",
	"tsx",
	"java",
}

------------------------
-- General Formatting
------------------------
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ name = "stylua", filetypes = { "lua" } },
	{ name = "prettier", filetypes = { "javascript", "typescript", "json", "yaml", "html", "css", "tsx" } },
	{ name = "google_java_format", filetypes = { "java" } },
})
