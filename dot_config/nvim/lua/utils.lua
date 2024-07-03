local utils = {}

function utils.telescope_find_files()
  if not package.loaded['telescope.builtin'] then
    return
  end

  local builtin = require 'telescope.builtin'

  local ignored_list = require 'ignore'

  local exclusions = {
    'rg',
    '--hidden',
    '--files',
    '--no-ignore',
    '-g',
    '!**/.git/*',
  }

  for _, dir in ipairs(ignored_list.dirs) do
    table.insert(exclusions, '-g')
    table.insert(exclusions, '!**/' .. dir .. '/*')
  end

  for _, files in ipairs(ignored_list.files) do
    table.insert(exclusions, '-g')
    table.insert(exclusions, files)
  end

  return builtin.find_files {
    find_command = exclusions,
  }
end

return utils
