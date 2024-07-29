return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    lazy = true,
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      -- Additional autocommand to switch back to 'blade' after LSP has attached
      vim.api.nvim_create_autocmd('LspAttach', {
        pattern = '*.blade.php',
        callback = function(args)
          vim.schedule(function()
            -- Check if the attached client is 'intelephense'
            for _, client in ipairs(vim.lsp.get_active_clients()) do
              if client.name == 'intelephense' and client.attached_buffers[args.buf] then
                vim.api.nvim_buf_set_option(args.buf, 'filetype', 'blade')
                -- update treesitter parser to blade
                vim.api.nvim_buf_set_option(args.buf, 'syntax', 'blade')
                break
              end
            end
          end)
        end,
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local NODE_VERSION = 'v21.7.0'

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              workspace = {
                checkThirdParty = false,
                library = {
                  '${3rd}/luv/library',
                  unpack(vim.api.nvim_get_runtime_file('', true)),
                },
              },
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },

        tsserver = {
          root_dir = require('lspconfig.util').root_pattern '.git',
          init_options = {
            maxTsServerMemory = 4096,
            tsserver = { logVerbosity = 'verbose', logDirectory = '/tmp/tsserver' },
            plugins = {
              {
                name = '@vue/typescript-plugin',
                location = os.getenv 'HOME' .. '/.local/share/fnm/node-versions/' .. NODE_VERSION .. '/installation/lib/node_modules/@vue/typescript-plugin',
                languages = { 'vue' },
              },
            },
          },
          -- filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
        },

        volar = {
          init_options = {
            vue = {
              hybridMode = false,
            },
          },
        },

        --[[    phpactor = {
          filetypes = { 'php', 'blade', 'blade.html.php' },
          init_options = {
            ['language_server_phpstan.enabled'] = false,
            ['language_server_psalm.enabled'] = false,
          },
        }, ]]

        intelephense = {
          settings = {
            intelephense = {
              filetypes = { 'php', 'blade' },
              files = {
                associations = { '*.php', '*.blade.php' }, -- Associating .blade.php files as well
                maxSize = 5000000,
              },
            },
          },
          filetypes = { 'php', 'blade' },
        },

        emmet_ls = {
          filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'blade', 'php' },
        },
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  {
    -- linting
    'mfussenegger/nvim-lint',
    event = {
      'BufReadPre',
      'BufNewFile',
    },
    lazy = true,
    config = function()
      local lint = require 'lint'

      local pint_severities = {
        ERROR = vim.diagnostic.severity.ERROR,
        WARNING = vim.diagnostic.severity.WARN,
      }

      local pint_bin = 'pint'

      lint.linters.pint = {
        cmd = function()
          local local_bin = vim.fn.fnamemodify('vendor/bin/' .. pint_bin, ':p')
          return vim.loop.fs_stat(local_bin) and local_bin or pint_bin
        end,
        stdin = false,
        args = {
          '-q',
          '--format=json',
          '--test',
        },
        ignore_exitcode = true,
        parser = function(output, _)
          if vim.trim(output) == '' or output == nil then
            return {}
          end

          if not vim.startswith(output, '{') then
            vim.notify(output)
            return {}
          end

          local decoded = vim.json.decode(output)
          local diagnostics = {}
          local messages = decoded['files']['STDIN']['messages']

          for _, msg in ipairs(messages or {}) do
            table.insert(diagnostics, {
              lnum = msg.line - 1,
              end_lnum = msg.line - 1,
              col = msg.column - 1,
              end_col = msg.column - 1,
              message = msg.message,
              code = msg.source,
              source = pint_bin,
              severity = assert(pint_severities[msg.type], 'missing mapping for severity ' .. msg.type),
            })
          end

          return diagnostics
        end,
      }

      lint.linters_by_ft = {
        javascript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        -- vue = { 'eslint_d' },
        vue = { 'eslint' },
        php = { 'pint' },
      }

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

      local lint_on = function()
        if vim.g.disable_lint then
          return
        end

        lint.try_lint(nil, { ignore_errors = true })
      end

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          lint_on()
        end,
      })

      vim.keymap.set('n', '<leader>l', function()
        vim.notify('Triggering linting for current file', vim.log.levels.INFO)
        lint_on()
      end, { desc = 'Trigger linting for current file' })
    end,
  },
}
