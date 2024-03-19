------------------------
-- Gopher
------------------------
local gopher = require("gopher")
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
-- DAP
------------------------
lvim.builtin.dap.active = true
local dapgo = require("dap-go")
dapgo.setup()

------------------------
-- LSP
------------------------
local lsp_manager = require("lvim.lsp.manager")
lsp_manager.setup("gopls", {
	on_attach = function(client, bufnr)
		require("lvim.lsp").common_on_attach(client, bufnr)
		local _, _ = pcall(vim.lsp.codelens.refresh)
		local which_key = require("which-key")
		local keymap = {
			["<leader>"] = {
				G = {
					name = "Go",
					i = { "<cmd>GoInstallDeps<cr>", "Install Dependencies" },
					t = { "<cmd>GoMod tidy<cr>", "Tidy" },
					a = { "<cmd>GoTestAdd<cr>", "Add Test" },
					A = { "<cmd>GoTestsAll<cr>", "Add All Tests" },
					e = { "<cmd>GoTestsExp<cr>", "Add Exported Tests" },
					g = { "<cmd>GoGenerate<cr>", "Generate" },
					f = { "<cmd>GoGenerate %<cr>", "Generate File" },
					c = { "<cmd>GoCmt<cr>", "Generate Comment" },
					T = { "<cmd>lua require('dap-go').debug_test()<cr>", "Debug Test" },
				},
			},
		}

		which_key.register(keymap)
	end,
	on_init = require("lvim.lsp").common_on_init,
	capabilities = require("lvim.lsp").common_capabilities(),
	settings = {
		gopls = {
			gofumpt = true, -- A stricter gofmt
			codelenses = {
				gc_details = true, -- Toggle the calculation of gc annotations
				generate = true, -- Runs go generate for a given directory
				regenerate_cgo = true, -- Regenerates cgo definitions
				test = true,
				tidy = true, -- Runs go mod tidy for a module
				upgrade_dependency = true, -- Upgrades a dependency in the go.mod file for a module
				vendor = true, -- Runs go mod vendor for a module
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			diagnosticsDelay = "300ms",
			symbolMatcher = "fuzzy",
			completeUnimported = true,
			staticcheck = true,
			matcher = "Fuzzy",
			usePlaceholders = true, -- enables placeholders for function parameters or struct fields in completion responses
			analyses = {
				fieldalignment = true, -- find structs that would use less memory if their fields were sorted
				nilness = true, -- check for redundant or impossible nil comparisons
				shadow = true, -- check for possible unintended shadowing of variables
				unusedparams = true, -- check for unused parameters of functions
				unusedwrite = true, -- checks for unused writes, an instances of writes to struct fields and arrays that are never read
			},
		},
	},
})

------------------------
-- Format
------------------------
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ command = "goimports", filetypes = { "go" } },
	{ command = "gofumpt", filetypes = { "go" } },
})

------------------------
-- Test
------------------------
local neotest = require("neotest")
neotest.setup({
	adapters = {
		require("neotest-go"),
	},
})
