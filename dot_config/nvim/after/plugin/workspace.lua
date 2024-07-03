-- get the current working directory
local cwd = vim.fn.getcwd()

-- if cwd equals Work, disable formatting and linting
if string.match(cwd, 'Work/') then
  vim.g.disable_format = true
  vim.g.disable_lint = true
end
