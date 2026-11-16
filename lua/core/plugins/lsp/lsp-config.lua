return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"mason.nvim",
		"mason-org/mason-lspconfig.nvim"
	},
	opts_extend = { "servers.*.keys" },
	-- CONFIG overriten, only install is handled by lazy
	-- opts = function()
		-- local ret = {
		-- 	disagnostics = {
		-- 		underline = true,
		-- 		update_in_insert = false,
		-- 		virtual_text = {
		-- 			spacing = 4,
		-- 			source = "if_many",
		-- 			prefix = "●",
		-- 		},
		-- 		severity_sort = true,
		-- 		-- signs = {
		-- 		-- 	text = {
		-- 		-- 		[vim.diagnostic.severity.ERROR] = 
		-- 		-- 		[vim.diagnostic.severity.WARN] = 
		-- 		-- 		[vim.diagnostic.severity.HINT] = 
		-- 		-- 		[vim.diagnostic.severity.INFO] = 
		-- 		-- 	}
		-- 		-- }
		-- 	},
		-- 	inlay_hints = {
		-- 		enabled = true,
		-- 		exclude = { },
		-- 	},
		-- 	servers = {
		-- 		["*"] = {
		-- 			capabilities = {
		-- 				workspace = {
		-- 					fileOperations = {
		-- 						didRename = true, 
		-- 						willRename = true
		-- 					}
		-- 				}
		-- 			}
		-- 		},
		-- 	}
		--
		-- }
		-- return ret
	-- end,
	config = function(_, opts)
		-- local function configure(server)
		-- 	if server == "*" then
		-- 		return false
		-- 	end
		--
		-- 	local sopts = opts.servers[server]
		-- 	sopts = sopts == true and {} or (not sopts) and {enabled = false} or sopts
		-- 	if sopts.enabled == false then
		-- 		mason_exclude[#mason_exclude +1] = server
		-- 		return
		-- 	end
		--
		-- 	local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)
		-- 	local setup = opts.setup[server] or opts.setup["*"]
		-- 	if setup and setup(server, sopts) then
		-- 		mason_exclude[#mason_exclude + 1] = server
		-- 	else
		-- 		vim.lsp.config(server, sopts)
		-- 		if not use_mason then
		-- 			vim.lsp.enable(server)
		-- 		end
		-- 	end
		-- 	return use_mason
		-- end
		--
		-- local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))
		-- if have_mason then
		-- 	require("mason-lspconfig").setup({
		-- 		ensure_installed = vim.list_extended(install, LazyVim.opts("mason-lspconfig.nvim").ensure_installed or {}),
		-- 		automatic_enable = { exclude = mason_exclude}
		-- 	})
		-- end
	end
}
