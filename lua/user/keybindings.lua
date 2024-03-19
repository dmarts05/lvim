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
