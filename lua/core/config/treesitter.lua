local function treesitter_try_attach(buf, language)

	if not vim.api.nvim_buf_is_valid(buf) then return end
	if not vim.treesitter.language.add(language) then return end

	vim.treesitter.start(buf, language)

	-- Check if treesitter indentation is available for this lang, if yes enable it
	-- In case there is no indent query, then indentexpr will fallback to vim's built in one
	local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil
	if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
end

local available_parsers = require('nvim-treesitter').get_available()
vim.api.nvim_create_autocmd('FileType', {
	callback = function(args)
		local buf, filetype = args.buf, args.match

		local language = vim.treesitter.language.get_lang(filetype)
		if not language then return end

		local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

		if vim.tbl_contains(installed_parsers, language) then
			-- Enable parser if installed
			treesitter_try_attach(buf, language)
		elseif vim.tbl_contains(available_parsers, language) then
			-- If `nvim-treesitter` has pareser, auto-install it and enable after install
			require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
		else
			-- Try to enable treesitter in case parser exists but not from `nvim-treesitter`
			treesitter_try_attach(buf, language)
		end
	end
})

