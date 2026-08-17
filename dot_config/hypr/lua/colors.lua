-- Noctalia color palette
-- Migrated from noctalia/noctalia-colors.conf
-- rgb(...) converted to rgba(...ff) for Lua API

local M = {}

M.colors = {
  primary        = "rgba(7f67e4ff)",
  surface        = "rgba(181429ff)",
  secondary      = "rgba(b05cd6ff)",
  error          = "rgba(d77a8aff)",
  tertiary       = "rgba(cc66b8ff)",
  surface_lowest = "rgba(0c0a14ff)",
}

-- Config fragments for merging into hl.config() calls
M.general_col = {
  active_border   = M.colors.primary,
  inactive_border = M.colors.surface,
}

M.group_col = {
  border_active          = M.colors.secondary,
  border_inactive        = M.colors.surface,
  border_locked_active   = M.colors.error,
  border_locked_inactive = M.colors.surface,
}

M.groupbar_col = {
  active          = M.colors.secondary,
  inactive        = M.colors.surface,
  locked_active   = M.colors.error,
  locked_inactive = M.colors.surface,
}

return M
