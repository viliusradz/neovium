return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts_extend = { "spec" },
	opts = {
		preset = "modern",
		defaults = {},
		delay = 0,
		icons = { mappings = vim.g.have_nerd_font },
		spec = {
			-- {
				-- mode = { "n", "x" },
				-- { "<leader><tab>", group = "tabs" },
				-- { "<leader>c", group = "code" },
				-- { "<leader>d", group = "debug"}
			-- }
		}
	},
	keys = {
		-- {
		-- }
	},
}
