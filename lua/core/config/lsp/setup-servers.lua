-- Documentation mainly from kickstart.nvim
--- @type table<string, vim.lsp.Config>
local servers = {
	lua_ls = {
		on_init = function(client)
			client.server_capabilities.documentFormattingProvider = false -- disable formatting
			
			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if path ~= vim.fn.stdpath "config" and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "./luarc.jsonc")) then return end
			end

			local current_settings = client.config.settings
			client.config.settings.Lua = vim.tbl_deep_extend("force", current_settings.Lua, {
				runtime = {
					version = "LuaJIT",
					path = { "lua/?.lua", "lua/?/init.lua" }
				},
				workspace = {
					checkThirdParty = false,
					library = vim.api.nvim_get_runtime_file("", true)
				}
			})
		end,
		--- @type lspconfig.settings.lua_ls
		settings = {
			Lua = {
				format = { enable = false }
			}
		}
	}
}

local ensure_installed = vim.tbl_keys(servers or {})

vim.list_extend(ensure_installed, {
	-- add other tools here to install with mason
})

require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

for name, server in pairs(servers) do
	vim.lsp.config(name,server)
	vim.lsp.enable(name)
end
