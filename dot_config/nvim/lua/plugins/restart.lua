return {
  'MaximilianLloyd/lazy-reload.nvim',
  opts = true,
  lazy = true,
  keys = {
    { '<leader>rl', "<cmd>lua require('lazy-reload').feed()<cr>", desc = 'Reload a plugin' },
  },
}
