-- vim.cmd("highlight default DimInactiveWindows guifg=#666666")
--
-- -- When leaving a window, set all ghighlit groups to a dimmed hl_group
--
-- vim.api.nvim_create_autocmd( "WinLeave", {
-- 	callback = function()
-- 		local highlights = {}
-- 		for hl, _ in pairs(vim.api.nvim_get_hl(0,{})) do
-- 			table.insert(highlights, hl .. ":DimInactiveWindows")
-- 		end
-- 		vim.wo.winhighlight = table.concat(highlights, ",")
-- 	end
-- })
--
-- -- When entering a window, restore all highlight groups to original
-- vim.api.nvim_create_autocmd("WinEnter", {
-- 	callback = function()
-- 		vim.wo.winhighlight = ""
-- 	end
-- })


-- Auto create directories if they do not exist
vim.api.nvim_create_autocmd( 'BufWritePre', {
	group = vim.api.nvim_create_augroup("neovium_auto_create_dir", { clear = true }),
	callback = function (event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end
})

-- resize splits if window gets modified
vim.api.nvim_create_autocmd( 'VimResized', {
	group = vim.api.nvim_create_augroup("neovium_resize_splits", { clear = true }),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd = ")
		vim.cmd("tabnext " .. current_tab)
	end
})
