-- Ignored directories and files
-- This file is used to specify directories and files that should be ignored by the plugin
-- It have to be listed in globals due to behaviour of `no-ignore` is not really to my liking.
return {
  -- List of directories to be ignored
  dirs = {
    'node_modules', -- JS Deps
    'vendor', -- PHP Deps
    '.expo',
    -- Group: [Nuxt]
    '.output',
    '.nuxt',
    '.nitro',
    '.cache',
    '.data',
    'logs',
  },

  -- List of files to be ignored
  files = {},
}
