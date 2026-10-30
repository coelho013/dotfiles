return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add          = { text = "┃" },
      change       = { text = "┃" },
      delete       = { text = "_" },
      topdelete    = { text = "‾" },
      changedelete = { text = "~" },
      untracked    = { text = "┆" },
    },
    signcolumn = true,
    current_line_blame = false, -- toggle with <leader>hb
    current_line_blame_opts = {
      delay = 500,
      virt_text_pos = "eol",
    },
    current_line_blame_formatter = "<author>, <author_time:%d/%m/%Y> - <summary>",
    preview_config = {
      border = "rounded",
    },
    on_attach = function(bufnr)
      local gs = require("gitsigns")

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- Navigation (respects diff mode)
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next hunk")

      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Previous hunk")

      -- Actions
      map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
      map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
      map("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage selected lines")
      map("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset selected lines")
      map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
      map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
      map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
      map("n", "<leader>hi", gs.preview_hunk_inline, "Preview hunk inline")
      map("n", "<leader>hB", function()
        gs.blame_line({ full = true })
      end, "Blame line (full)")
      map("n", "<leader>hd", gs.diffthis, "Diff against index")
      map("n", "<leader>hD", function()
        gs.diffthis("~")
      end, "Diff against last commit")

      -- Toggles
      map("n", "<leader>hb", gs.toggle_current_line_blame, "Toggle line blame")
      map("n", "<leader>hw", gs.toggle_word_diff, "Toggle word diff")

      -- Text object: select hunk with ih (e.g. dih, vih)
      map({ "o", "x" }, "ih", gs.select_hunk, "Select hunk")
    end,
  },
}
