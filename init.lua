
-- =======================
-- Set nvim settings here 
-- =======================

do
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "
	vim.g.have_nerd_font = true

	-- line numbers
	vim.o.number = true
	vim.o.relativenumber = true

	-- Instert/Visual
	-- vim.o.showmode = false

	-- Sync clipboards
	vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

	vim.o.breakindent = true
	vim.o.undofile = true

	vim.o.ignorecase = true
	vim.o.smartcase = true

	-- Keep signcolumn 
	-- vim.o.signcolumn = 'yes'

	vim.o.updatetime = 250 -- Decrease update time
	vim.o.timeoutlen = 300 -- Decrease mapped sequence wait time

	-- New split location
	vim.o.splitright = true
	vim.o.splitbelow = true

	vim.o.list = true
	vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

	vim.o.inccommand = 'split'
	vim.o.cursorline = true
	vim.o.scrolloff = 10

	vim.o.confirm = true
end

do
	-- escape search highlights
	vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

	-- config diagnostic
	vim.diagnostic.config {
		update_in_insert = false,
		severity_sort = true,
		float = {
			border = 'rounded',
			source = 'if_many'
		},
		underline = { severity = { min = vim.diagnostic.severity.WARN }},

		-- Can switch between
		-- virtual_text = true, -- text at end of lines
		virtual_lines = true,

		-- Auto open float 
		jump = {
			on_jump = function(_, bufnr)
				vim.diagnostic.open_float {
					bufnr = bufnr,
					scope = 'cursor',
					focus = false,
				}
			end,
		},
	}

	vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { 
		desc = 'Open diagnostic [Q]uickfix list' })

	vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

	-- No more shift for moving between window
	vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
	vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
	vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
	vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

	-- highlight copy
	vim.api.nvim_create_autocmd('TextYankPost', {
		desc = 'Highlight when yanking text',
		group = vim.api.nvim_create_augroup(
			'kickstart-highlight-yank', {clear = true}),
			callback = function() vim.hl.on_yank() end,
		})
end

require("core.lazy")
require("kanagawa").load("wave")
