-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '[w<Left>', ':vertical resize +5<CR>', { desc = 'Decrease the width of the window', silent = true })
vim.keymap.set('n', '[w<Right>', ':vertical resize -5<CR>', { desc = 'Increase the width of the window', silent = true })
vim.keymap.set('n', '[w+', ':resize +5<CR>', { desc = 'Increase the height of the window', silent = true })
vim.keymap.set('n', '[w->', ':resize -5<CR>', { desc = 'Decrease the height of the window', silent = true })

-- create terminal in split window (Horizontal) with CTRL+t
vim.keymap.set('n', '<C-t>', ':split | term <CR>', { desc = 'Create a terminal in split window', silent = true })

-- go back to previous opened file
vim.keymap.set('n', '<A-p>', '<C-^>', { desc = 'Jump to [p]revious [b]uffer', silent = true })

-- Keybinds to move line up and down easier than doing 'ddkP' or 'ddp'
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move the current line down', silent = true })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move the current line up', silent = true })

vim.keymap.set('n', '<C-n>', ':bn<CR>', { desc = 'Switch to [N]ext buffer', silent = true })
vim.keymap.set('n', '<C-p>', ':bp<CR>', { desc = 'Switch to [P]revious buffer', silent = true })

vim.keymap.set('n', '<C-e>', ':NvimTreeToggle<CR>', { desc = 'Toggle [E]xplorer', silent = true })

-- Keybinds to paste and copy to system
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Copy/[Y]ank selected to system clipboard', silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>yy', '"+yy', { desc = 'Copy/[Y]ank entire line to system clipboard', silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = '[P]aste from system clipboard', silent = true })

vim.keymap.set('n', '<leader>tc', ':bufdo bd<CR>', { desc = '[C]lose all [T]abs', silent = true })
