local slow_format_filetypes = {}

return {
  -- I commented line below because it mess up with my setup
  -- 'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  {
    'tpope/vim-sleuth',
    event = 'BufRead',
    lazy = true,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = 'BufReadPre',
    lazy = true,
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        if vim.g.disable_format or vim.b[bufnr].disable_autoformat then
          return
        end

        if slow_format_filetypes[vim.bo[bufnr].filetype] then
          return
        end

        local function on_format(err)
          if err and err:match 'timeout$' then
            slow_format_filetypes[vim.bo[bufnr].filetype] = true
          end
        end

        return { timeout_ms = 500, lsp_fallback = true }, on_format
      end,
      format_after_save = function(bufnr)
        if not slow_format_filetypes[vim.bo[bufnr].filetype] then
          return
        end
        return { lsp_fallback = true }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        vue = { 'eslint_d', 'rustywind' },
        typescript = { 'eslint_d' },
        javascript = { 'eslint_d' },
        blade = { 'blade-formatter', 'rustywind' },
      },
    },
  },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    event = 'BufReadPre',
    lazy = true,
    config = function()
      require('mini.ai').setup { n_lines = 500 }

      require('mini.surround').setup()

      require('mini.indentscope').setup {
        symbol = '│',
        options = { try_as_border = true },
      }

      local statusline = require 'mini.statusline'
      statusline.setup()

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return ''
      end
    end,
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'help',
          'dashboard',
          'NvimTree',
          'lazy',
          'mason',
          'notify',
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  {
    'windwp/nvim-ts-autotag',
    event = 'BufReadPre',
    lazy = true,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
      ---@diagnostic disable-next-line: inject-field
      parser_config.blade = {
        install_info = {
          url = 'https://github.com/EmranMR/tree-sitter-blade',
          files = { 'src/parser.c' },
          branch = 'main',
          generate_requires_npm = true,
          requires_generate_from_grammar = true,
        },
        filetype = 'blade',
      }
      --
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'php' },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        autotag = { enable = true },
      }
    end,
  },

  { 'github/copilot.vim', event = 'BufReadPre', lazy = true },

  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    },
  },
}
