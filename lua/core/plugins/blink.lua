-- Provides AUTOCOMPLETE

-- required to install the rust port instead of lua, cargo is dependencf
local blink_v2 = vim.fn.executable("cargo") == 1

return {
	"saghen/blink.cmp",
	version = not blink_v2 and "*",
	build = function ()
		-- if blink_v2 then
			require("blink.cmp").build():pwait()
		-- end
		-- vim.g.lazyvim_blink_main and "cargo build --release",
	end,
	opts_extend = {
		"sources.completion.enabled_providers",
		"sources.compat",
		"sources.default"
	},
	dependencies = {
		"saghen/blink.lib",
		"rafamadriz/friendly-snippets",
		{
			"saghen/blink.compat",
			optional = true,
			opts = {},
			version = not blink_v2 and "*",
		},
	},
	event = { "InsertEnter", "CmdlineEnter" },
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		snippets = {
			preset = "default"
		},
		appearance = {
			use_nvim_cmp_as_default = true,
			-- nerd font can be either mono or normal
			nerd_font_variant = "mono"
		},
		completion = {
			accept = {
				-- exptermental auto bracket support
				auto_brackets = {
					enabled = false
				}
			},
			menu = {
				draw = {
					treesitter = { "lsp" },
				}
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
			ghost_text = {
				enabled = vim.g.ai_cmp
			},
		},

		-- Expermental signature help support
		-- signature = { enabled = true },

		sources = {
			-- adding any nvim-cmp sources here will enable them
			-- with blink.compat
			compat = {},
			default = { "lsp", "path", "snippets", "buffer" },
		},

		-- suggestions in comand line
		cmdline = {
			enabled = true,
			keymap = {
				preset = "cmdline",
				["<Right>"] = false,
				["<Left>"] = false,
			},
			completion = {
				list = {
					selection = { preselect = false }
				},
				menu = {
					auto_show = function(ctx)
						return vim.fn.getcmdtype() == ":"
					end,
				},
				ghost_text = { enabled = true },
			}
		},

		keymap = {
			preset = "enter",
			["<C-y>"] = { "select_and_accept" }
		}
	},

	---@param opts blink.cmp.config | { sources: { compat: string[] } }
	config = function(_, opts)
		-- if opts.snippets and opts.snippets.preset == "default" then
		-- 	opts.snippets.expand = LazyVim.cmp.expand
		-- end

		-- setup compat sources
		local enabled = opts.sources.default
		for _, source in ipairs(opts.sources.compat or {}) do
			opts.sources.providers[source] = vim.tbl_deep_extend( "force",
				{ name = source, module = "blink.compat.source" },
				opts.sources.providers[source] or {})
			if type(enabled) == "table" and not vim.tbl_contains(enabled, srouce) then
				table.insert(enabled, source)
			end
		end

		-- add ai_accept to <Tab> key

		opts.sources.compat = nil

		for _, provider in pairs(opts.sources.providers or {}) do
			---@cast provider blink.cmp.SourceProviderConfig |{kind?:string}
			if provider.kind then
				local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
				local kind_idx = #CompletionItemKind + 1

				CompletionItemKind[kind_idx] = provider.kind
				---@diagnostic disable-next-line: no-unknown
				CompletionItemKind[provider.kind] = kind_idx

				---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
				local transform_items = provider.transform_items
				---@param ctx blink.cmp.Context
				---@param items blink.cmp.CompletionItem[]
				provider.transform_items = function(ctx, items)
					items = tranfrom_items and transform_items(ctx, items) or items
					for _,item in ipairs(items) do
						item.kind = kind_idx or item.kind
						item.kind_icon = item.kind_icon or nil
					end
					return items
				end
				-- Unset custom prop to pass blink.cmp validation
				provider.kind = nil
			end
		end
		require("blink.cmp").setup(opts)

	end
}
