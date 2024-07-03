return {
  -- JSX & TSX comment plugin
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    event = 'BufRead',
    lazy = true,
    config = function()
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
        languages = {},
        config = {},
        commentary_integration = {},
      }
    end,
  },

  -- comment toggle
  {
    'numToStr/Comment.nvim',
    event = 'BufRead',
    lazy = true,
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
  },
}
