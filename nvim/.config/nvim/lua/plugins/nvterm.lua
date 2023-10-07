return {
	"NvChad/nvterm",
	priority = 10000,
	event = { "VeryLazy" },
	config = function()
		local nvterm = require("nvterm")
		nvterm.setup()
	end,
}
