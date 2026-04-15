-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- import/override with your plugins folder
  { import = "astrocommunity.pack.php" }, -- PHP LSP (Intelephense) + formatter
  {
    "AstroNvim/astrolsp",
    opts = {
      servers = {
        phpactor = { enabled = false }, -- disable phpactor
        intelephense = { -- enable intelephense
          enabled = true,
        },
      },
    },
  },
  -- Remove phpactor from Mason auto-install, add intelephense
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      -- filter out phpactor
      opts.ensure_installed = vim.tbl_filter(function(tool) return tool ~= "phpactor" end, opts.ensure_installed or {})

      -- add intelephense
      table.insert(opts.ensure_installed, "intelephense")
    end,
  },
  { import = "astrocommunity.pack.laravel", enabled = false }, -- Laravel-specific tools
  { import = "astrocommunity.pack.blade", cond = function() return vim.fn.glob "artisan" ~= "" end }, -- Blade template syntax + treesitter
  { import = "astrocommunity.pack.html-css" }, -- HTML/CSS LSP
  { import = "astrocommunity.pack.json" }, -- JSON support
  {
    import = "astrocommunity.pack.tailwindcss",
    cond = function()
      return vim.fn.filereadable "tailwind.config.js" == 1 or vim.fn.filereadable "tailwind.config.ts" == 1
    end,
  }, -- Tailwind CSS intellisense
  { import = "astrocommunity.pack.markdown" }, -- Markdown for docs

  { import = "astrocommunity.pack.astro", cond = function() return vim.fn.glob "astro.config.*" ~= "" end }, -- astro
  { import = "astrocommunity.pack.mdx", cond = function() return vim.fn.glob "astro.config.*" ~= "" end }, -- mdx, the only time I use is with astro.

  -- copilot stuff
  {
    import = "astrocommunity.completion.copilot-lua",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true, -- Automatically show suggestions
        keymap = {
          accept = "<M-l>", -- Alt + l to accept (change this to your liking)
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = true },
    },
  },
  { import = "astrocommunity.completion.blink-copilot" },
  { import = "astrocommunity.editing-support.copilotchat-nvim", enabled = false },
  { import = "astrocommunity.colorscheme.catppuccin" },
}
