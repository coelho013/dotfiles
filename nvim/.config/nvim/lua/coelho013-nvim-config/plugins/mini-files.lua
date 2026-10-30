return {
  'nvim-mini/mini.files',
  version = '*',
  config = function()
    require('mini.files').setup({
      mappings = {
        go_in = '<Right>',
        go_out = '<Left>'
      }
		})
  end,
  keys = {
    {
      '<leader>e',
      function()
        require('mini.files').open()
      end,
      desc = 'Open Explorer'
    },
  },
}
