---@param path string
---@return string
local get_module = function (path)
	local module_path = vim.split(path, "lua/")[2]
	return string.sub(module_path, 0,  -5)
end
---@param server_table LspConfig
---@return string | nil, table | nil
local get_optional_arg = function (server_table)
	for k, v in pairs(server_table) do
		if type(k) == "string" and type(v) == "table" then
			return k,v
		end
	end
	return nil
end

-- Get all language servers from lua/language_servers
local lang_path = "language_servers"
local servers = {}
local lsp_files = vim.api.nvim_get_runtime_file("lua/" .. lang_path .. "/*.{lua}", true)


for _, file in ipairs(lsp_files) do
	local module_name = get_module(file)

	---@type LspConfig
	local result = require(module_name)
	if result.enabled then
		local lsp_name, lsp_config = get_optional_arg(result)
		if lsp_name ~= nil then
			servers[lsp_name] = lsp_config
		else
			vim.notify("lsp enabled in module " .. module_name .. " but no valid lsp entry", "error")
		end
	end
end


local ensure_installed = vim.tbl_keys(servers or {})

vim.list_extend(ensure_installed, {
	-- add other tools here to install with mason
})

require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

for name, server in pairs(servers) do
	vim.lsp.config(name,server)
	vim.lsp.enable(name)
end
