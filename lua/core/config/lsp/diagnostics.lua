-- config diagnostic
vim.diagnostic.config {
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = 'rounded',
		source = 'if_many'
	},
	underline = { severity = { min = vim.diagnostic.severity.WARN }},
	virtual_text = false,
	virtual_lines = false,

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


vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()

		-- Don't open if already shown
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_get_config(win).relative ~= "" then
				return
			end
		end
		vim.diagnostic.open_float(nil, {
			focusable = false,
			close_events = {
				"BufLeave",
				"CursorMoved",
				"InsertEnter",
				"FocusLost"
			},
			severity = { 
				vim.diagnostic.severity.WARN,
				vim.diagnostic.severity.ERROR
			},
			source = "always",
			prefix = " ",
			scope = "line"
		})
	end
})

-- vim.api.nvim_create_autocmd("CursorHold", {
-- 	callback = function()
-- 		local clients = vim.lsp.get_clients({
-- 			bufnr = 0,
-- 			method = "textDocument/signatureHelp"
-- 		})
-- 		if #clients == 0 then
-- 			-- returns if lsp not supports signature help
-- 			return 
-- 		end
-- 		vim.lsp.buf.signature_help({
-- 			focusable = false,
-- 			silent = true  -- Do not show "no signature help avail"
-- 		})
-- 	end
-- })

