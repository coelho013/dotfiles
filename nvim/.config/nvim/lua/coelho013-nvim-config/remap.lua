vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split buffer vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split buffer horizontally" })
vim.keymap.set('n', '<Esc>', '<cmd>noh<CR>', { silent = true }, { desc = "Clean search" })
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>', { silent = true }, { desc = "Increase buffer size Up" })
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>', { silent = true }, { desc = "Increase buffer size Down" })
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { silent = true }, { desc = "Increase buffer size Left" })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { silent = true }, { desc = "Increase buffer size Right" })
vim.keymap.set('n', '<leader>cfn', ':let @+ = expand("%:t")<CR>', { desc = 'Copy file name' })
vim.keymap.set('n', '<leader>yh', ':registers<CR>', { desc = 'Yank History'})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlights text when yanking",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
