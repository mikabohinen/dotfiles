local Binder = require("config.binder")

return {
	"lervag/vimtex",
	ft = { "tex", "bib" },
	config = function()
		vim.g.vimtex_quickfix_mode = 0
		vim.g.vimtex_compiler_method = "latexrun"
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_compiler_latexrun = {
			options = {
				"--shell-escape",
				"-interaction=nonstopmode",
				"-file-line-error",
				"-synctex=1",
				"-pdf",
			},
		}
	end,
}
