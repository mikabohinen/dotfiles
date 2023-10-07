local Binder = require("config.binder")

local current_nsid = vim.api.nvim_create_namespace("LuaSnipChoiceListSelections")
local current_win = nil

local function window_for_choiceNode(choiceNode)
	local buf = vim.api.nvim_create_buf(false, true)
	local buf_text = {}
	local row_selection = 0
	local row_offset = 0
	local text
	for _, node in ipairs(choiceNode.choices) do
		text = node:get_docstring()
		-- find one that is currently showing
		if node == choiceNode.active_choice then
			-- current line is starter from buffer list which is length usually
			row_selection = #buf_text
			-- finding how many lines total within a choice selection
			row_offset = #text
		end
		vim.list_extend(buf_text, text)
	end

	vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, buf_text)
	local w, h = vim.lsp.util._make_floating_popup_size(buf_text)

	-- adding highlight so we can see which one is been selected.
	local extmark = vim.api.nvim_buf_set_extmark(
		buf,
		current_nsid,
		row_selection,
		0,
		{ hl_group = "incsearch", end_line = row_selection + row_offset }
	)

	-- shows window at a beginning of choiceNode.
	local win = vim.api.nvim_open_win(buf, false, {
		relative = "win",
		width = w,
		height = h,
		bufpos = choiceNode.mark:pos_begin_end(),
		style = "minimal",
		border = "rounded",
	})

	-- return with 3 main important so we can use them again
	return { win_id = win, extmark = extmark, buf = buf }
end

function choice_popup(choiceNode)
	-- build stack for nested choiceNodes.
	if current_win then
		vim.api.nvim_win_close(current_win.win_id, true)
		vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
	end
	local create_win = window_for_choiceNode(choiceNode)
	current_win = {
		win_id = create_win.win_id,
		prev = current_win,
		node = choiceNode,
		extmark = create_win.extmark,
		buf = create_win.buf,
	}
end

function update_choice_popup(choiceNode)
	vim.api.nvim_win_close(current_win.win_id, true)
	vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
	local create_win = window_for_choiceNode(choiceNode)
	current_win.win_id = create_win.win_id
	current_win.extmark = create_win.extmark
	current_win.buf = create_win.buf
end

function choice_popup_close()
	vim.api.nvim_win_close(current_win.win_id, true)
	vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
	-- now we are checking if we still have previous choice we were in after exit nested choice
	current_win = current_win.prev
	if current_win then
		-- reopen window further down in the stack.
		local create_win = window_for_choiceNode(current_win.node)
		current_win.win_id = create_win.win_id
		current_win.extmark = create_win.extmark
		current_win.buf = create_win.buf
	end
end

vim.cmd([[
augroup choice_popup
au!
au User LuasnipChoiceNodeEnter lua choice_popup(require("luasnip").session.event_node)
au User LuasnipChoiceNodeLeave lua choice_popup_close()
au User LuasnipChangeChoice lua update_choice_popup(require("luasnip").session.event_node)
augroup END
]])

local icons = require("config.icons")

return {
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter" },
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			{
				"zbirenbaum/copilot-cmp",
				opts = {},
				config = function(_, opts)
					local copilot_cmp = require("copilot_cmp")
					copilot_cmp.setup(opts)
					require("util").on_attach(function(client)
						if client.name == "copilot" then
							copilot_cmp._on_insert_enter({})
						end
					end)
				end,
			},
			{ "jcdickinson/codeium.nvim", config = true },
			{
				"jcdickinson/http.nvim",
				build = "cargo build --workspace --release",
			},
		},
		opts = function()
			vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
			local cmp = require("cmp")
			local defaults = require("cmp.config.default")()
			return {
				completion = {
					completeopt = "menu,menuone,noinsert,noselect",
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = {
					["<c-m>"] = cmp.mapping(function()
						if not cmp.visible() then
							cmp.complete()
						else
							cmp.abort()
						end
					end, { "i", "s" }),
					["<c-y>"] = cmp.mapping(function(fallback)
						if not cmp.visible() then
							fallback()
						else
							cmp.scroll_docs(4)
						end
					end, { "i", "s" }),
					["<c-e>"] = cmp.mapping(function(fallback)
						if not cmp.visible() then
							fallback()
						else
							cmp.scroll_docs(-4)
						end
					end, { "i", "s" }),
					["<c-p>"] = cmp.mapping(function(fallback)
						if not cmp.visible() then
							fallback()
						else
							cmp.select_prev_item()
						end
					end, { "i", "s" }),
					["<c-n>"] = cmp.mapping(function(fallback)
						if not cmp.visible() then
							fallback()
						else
							cmp.select_next_item()
						end
					end, { "i", "s" }),
					["<cr>"] = cmp.mapping(function(fallback)
						if cmp.get_selected_entry() == nil then
							fallback()
						else
							cmp.confirm()
						end
					end, { "i", "s" }),
					["<s-tab>"] = cmp.mapping(function(fallback)
						if not require("luasnip").jumpable(-1) then
							fallback()
						else
							require("luasnip").jump(-1)
						end
					end, { "i", "s" }),
					["jk"] = cmp.mapping(function(fallback)
						if not require("luasnip").jumpable(1) then
							fallback()
						else
							require("luasnip").jump(1)
						end
					end, { "i", "s" }),
					["kj"] = cmp.mapping(function(fallback)
						if not require("luasnip").jumpable(1) then
							fallback()
						else
							require("luasnip").jump(1)
						end
					end, { "i", "s" }),
					["<c-f>"] = cmp.mapping(function(fallback)
						if require("luasnip").choice_active() then
							return require("luasnip").change_choice(1)
						else
							fallback()
						end
					end),
					["<c-b>"] = cmp.mapping(function(fallback)
						if require("luasnip").choice_active() then
							return require("luasnip").change_choice(-1)
						else
							fallback()
						end
					end),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "codeium" },
					-- { name = "copilot" },
				}),
				formatting = {
					format = function(_, item)
						local icons = require("config.icons").kinds
						if icons[item.kind] then
							item.kind = icons[item.kind] .. item.kind
						end
						return item
					end,
				},
				-- experimental = {
				--   ghost_text = {
				--     hl_group = "CmpGhostText",
				--   },
				-- },
				sorting = defaults.sorting,
			}
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		build = (not jit.os:find("Windows"))
				and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
			or nil,
		dependencies = {
			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
			{
				"honza/vim-snippets",
				config = function()
					require("luasnip.loaders.from_snipmate").lazy_load()

					require("luasnip").filetype_extend("all", { "_" })
				end,
			},
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
		config = function(_, opts)
			local luasnip = require("luasnip")

			luasnip.setup(opts)
			luasnip.config.set_config({
				enable_autosnippets = true,
				store_selection_keys = "<C-q>",
				updateevents = "TextChanged,TextChangedI",
			})

			local snippets_folder = vim.fn.stdpath("config") .. "/lua/plugins/completion/snippets/"
			require("luasnip.loaders.from_lua").lazy_load({ paths = snippets_folder })

			vim.api.nvim_create_user_command("LuaSnipEdit", function()
				require("luasnip.loaders.from_lua").edit_snippets_files()
			end, {})

			Binder.new({ "n" }):desc("Reload Luasnip"):bind(
				"<leader>L",
				"<cmd>lua require('luasnip.loaders.from_lua').load({paths = '~/.config/nvim/lua/plugins/completion/snippets/'})<CR>"
			)
		end,
	},
}
