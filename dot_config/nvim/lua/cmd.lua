vim.api.nvim_create_user_command('Format', function(opts)
  local param = opts.args

  if param == 'disable' then
      vim.g.disable_format = true
      vim.notify('Autoformat disabled', 'info', { title = 'Autoformat' })

    return
  end

  if param == 'enable' then
    vim.b.disable_autoformat = false
    vim.g.disable_format = false
    vim.notify('Autoformat enabled', 'info', { title = 'Autoformat' })

    return
  end

  local range = nil
  if opts.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, opts.line2 - 1, opts.line2, true)[1]
    range = {
      start = { opts.line1, 0 },
      ['end'] = { opts.line2, end_line:len() },
    }
  end
  require('conform').format { async = true, lsp_fallback = true, range = range }
end, {
  range = true,
  nargs = '?',
  complete = function()
    return { 'disable', 'enable' }
  end,
})

vim.api.nvim_create_user_command('Lint', function(opts)
  local param = opts.args

  if param == 'disable' then
    vim.g.disable_lint = true
    vim.notify('Linting disabled', 'info', { title = 'Lint' })

    return
  end

  if param == 'enable' then
    vim.g.disable_lint = false
    vim.notify('Linting enabled', 'info', { title = 'Lint' })

    return
  end

  vim.notify('Invalid parameter', 'error', { title = 'Lint' })
end, {
  nargs = 1,
  complete = function()
    return { 'disable', 'enable' }
  end,
})
