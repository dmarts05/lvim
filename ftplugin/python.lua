------------------------
-- DAP
------------------------
lvim.builtin.dap.active = true
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
local dap_python = require("dap-python")
dap_python.setup(mason_path .. "packages/debugpy/venv/bin/python")

------------------------
-- LSP
------------------------
local lsp_manager = require("lvim.lsp.manager")
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

------------------------
-- Format
------------------------
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ command = "black", filetypes = { "python" } },
	{ command = "isort", filetypes = { "python" } },
})

------------------------
-- Test
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
	},
})
