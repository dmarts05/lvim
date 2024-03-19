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
			})
			require("copilot_cmp").setup()
		end, 100)
	end,
})
