------------------------
-- General
------------------------
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

-- Enable DAP
lvim.builtin.dap.active = true

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

		-- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
		-- setup = function()
		--  vim.o.timeoutlen = 500
		-- end
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
	},
	auto_update = false,
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
}

------------------------
-- Formatting
------------------------
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ name = "stylua", filetypes = { "lua" } },
	{ command = "goimports", filetypes = { "go" } },
	{ command = "gofumpt", filetypes = { "go" } },
	{ command = "black", filetypes = { "python" } },
	{ command = "isort", filetypes = { "python" } },
	{ name = "prettier", filetypes = { "javascript", "typescript", "json", "yaml", "html", "css", "tsx" } },
})

lvim.format_on_save = true

------------------------
-- Linters
------------------------
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{ command = "staticcheck", filetypes = { "go" } },
})

------------------------
-- DAP
------------------------
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")

local dapgo = require("dap-go")
dapgo.setup()

local dap_python = require("dap-python")
dap_python.setup(mason_path .. "packages/debugpy/venv/bin/python")

------------------------
-- LSP
------------------------
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "gopls" })

local lsp_manager = require("lvim.lsp.manager")

lsp_manager.setup("gopls", {
	on_attach = function(client, bufnr)
		require("lvim.lsp").common_on_attach(client, bufnr)
		local _, _ = pcall(vim.lsp.codelens.refresh)
		local map = function(mode, lhs, rhs, desc)
			if desc then
				desc = desc
			end

			vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
		end
		map("n", "<leader>Gi", "<cmd>GoInstallDeps<Cr>", "Install Go Dependencies")
		map("n", "<leader>Gt", "<cmd>GoMod tidy<cr>", "Tidy")
		map("n", "<leader>Ga", "<cmd>GoTestAdd<Cr>", "Add Test")
		map("n", "<leader>GA", "<cmd>GoTestsAll<Cr>", "Add All Tests")
		map("n", "<leader>Ge", "<cmd>GoTestsExp<Cr>", "Add Exported Tests")
		map("n", "<leader>Gg", "<cmd>GoGenerate<Cr>", "Go Generate")
		map("n", "<leader>Gf", "<cmd>GoGenerate %<Cr>", "Go Generate File")
		map("n", "<leader>Gc", "<cmd>GoCmt<Cr>", "Generate Comment")
		map("n", "<leader>GT", "<cmd>lua require('dap-go').debug_test()<cr>", "Debug Test")
	end,
	on_init = require("lvim.lsp").common_on_init,
	capabilities = require("lvim.lsp").common_capabilities(),
	settings = {
		gopls = {
			usePlaceholders = true,
			gofumpt = true,
			codelenses = {
				generate = false,
				gc_details = true,
				test = true,
				tidy = true,
			},
		},
	},
})

lsp_manager.setup("pyright", {
	on_attach = require("lvim.lsp").common_on_attach,
	on_init = require("lvim.lsp").common_on_init,
	capabilities = require("lvim.lsp").common_capabilities(),
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "strict",
			},
		},
	},
})

local status_ok, gopher = pcall(require, "gopher")
if not status_ok then
	return
end

gopher.setup({
	commands = {
		go = "go",
		gomodifytags = "gomodifytags",
		gotests = "gotests",
		impl = "impl",
		iferr = "iferr",
	},
})

------------------------
-- NeoTest
------------------------
local neotest = require("neotest")
neotest.setup({
	adapters = {
		require("neotest-python")({
			dap = {
				justMyCode = false,
				console = "integratedTerminal",
			},
			args = { "--log-level", "DEBUG", "--quiet" },
			runner = "pytest",
		}),
		require("neotest-go"),
	},
})

------------------------
-- Copilot
------------------------
table.insert(lvim.plugins, {
	"zbirenbaum/copilot-cmp",
	event = "InsertEnter",
	dependencies = { "zbirenbaum/copilot.lua" },
	config = function()
		vim.defer_fn(function()
			require("copilot").setup({
				suggestion = {
					auto_trigger = true,
					keymap = {
						accept = "<C-l>",
						accept_word = "<C-S-l>",
						next = "<C-j>",
						prev = "<C-k>",
						dismiss = "<C-h>",
					},
				},
			}) -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
			require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
		end, 100)
	end,
})

------------------------
-- Custom Keybindings
------------------------

-- Split buffers
lvim.keys.normal_mode["|"] = ":vsplit<CR>"
lvim.keys.normal_mode["-"] = ":split<CR>"

-- Resize with arrows
lvim.keys.normal_mode["<C-S-K>"] = ":resize -2<CR>"
lvim.keys.normal_mode["<C-S-J>"] = ":resize +2<CR>"
lvim.keys.normal_mode["<C-S-L>"] = ":vertical resize -2<CR>"
lvim.keys.normal_mode["<C-S-H>"] = ":vertical resize +2<CR>"

-- Update file with Ctrl + S
lvim.keys.normal_mode["<C-s>"] = ":update<CR>"

-- gj and gk instead of j and k
lvim.keys.normal_mode["j"] = "gj"
lvim.keys.normal_mode["k"] = "gk"

-- NeoTest
lvim.builtin.which_key.mappings["t"] = {
	name = "Test",
	m = { "<cmd>lua require('neotest').run.run()<cr>", "Test Method" },
	M = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Test Method DAP" },
	f = { "<cmd>lua require('neotest').run.run({vim.fn.expand('%')})<cr>", "Test File" },
	F = { "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", "Test File DAP" },
	S = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Test Summary" },
}
