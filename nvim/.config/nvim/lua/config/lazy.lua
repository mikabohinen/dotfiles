local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ import = "plugins.extras.lang" },
		{ import = "plugins.extras.test" },
		{ import = "plugins.dap" },
	},
	defaults = {
		-- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
		-- If you know what you're doing, you can set this to 'true' to have all your custom plugins lazy-loaced by default.
		lazy = false,
		-- It's recommended to leave version=false for now, since a lot of the plugins that support versioning,
		-- have outdated releases, which may break your Neovim install.
		version = false,
		-- version = "*", -- try installing the latest stable version for plugins that support semver
	},
	install = { colorscheme = { "catppuccin", "habamax" } },
	checker = { enabled = true }, -- automatically check for plugin updates
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

local Binder = require("config.binder")
local lazy = require("lazy")

local binder = Binder.new({ "n" })
binder:clone():desc("Plugin Home"):bind("<leader>ph", lazy.home)
binder:clone():desc("Plugin Install"):bind("<leader>pi", lazy.install)
binder:clone():desc("Plugin Update"):bind("<leader>pu", lazy.update)
binder:clone():desc("Plugin Sync"):bind("<leader>ps", lazy.sync)
binder:clone():desc("Plugin Clean"):bind("<leader>px", lazy.clean)
binder:clone():desc("Plugin Check"):bind("<leader>pc", lazy.clean)
binder:clone():desc("Plugin Log"):bind("<leader>pl", lazy.log)
binder:clone():desc("Plugin Restore"):bind("<leader>pr", lazy.restore)
binder:clone():desc("Plugin Profile"):bind("<leader>pp", lazy.profile)
binder:clone():desc("Plugin Debug"):bind("<leader>pd", lazy.debug)
