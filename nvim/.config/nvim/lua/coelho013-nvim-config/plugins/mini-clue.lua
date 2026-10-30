return {
	'nvim-mini/mini.clue',
	event = "VeryLazy",
	config = function ()
		local miniclue = require("mini.clue")
		miniclue.setup({
			triggers = {
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },
        { mode = "n", keys = "g" },
        { mode = "n", keys = "[" },
        { mode = "n", keys = "]" },
        { mode = "n", keys = "z" },
        { mode = "n", keys = "<C-w>" },
      },
			clues = {
				{ mode = "n", keys = "<Leader>g", desc = "+git" },
        { mode = "n", keys = "<Leader>h", desc = "+hunks" },
        { mode = "n", keys = "<Leader>y", desc = "+yank" },
				{ mode = "n", keys = "<Leader>t", desc = "+test" },
				{ mode = "n", keys = "<Leader>s", desc = "+split" },
				{ mode = "n", keys = "<Leader>c", desc = "+copy" },
				{ mode = "n", keys = "<Leader>cf", desc = "+file" },
				{ mode = "n", keys = "<Leader>f", desc = "+find" },
				{ mode = "n", keys = "<Leader>b", desc = "+buffer" },
				{ mode = "n", keys = "<Leader>j", desc = "+java" },
				miniclue.gen_clues.g(),
        miniclue.gen_clues.z(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
			},
			window = {
				delay = 0,
			}
		})
	end,
}
