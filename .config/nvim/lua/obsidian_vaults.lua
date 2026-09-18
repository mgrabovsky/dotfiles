---@class user.Workspace
---@field name string
---@field path string

---@type user.Workspace[]
local workspaces = {
	{ name = "personal", path = vim.fs.normalize("~/notes") },
	-- { name = "work", path = vim.fs.normalize "~/work" },
}

return {
	workspaces = workspaces,
	--- Resolved roots for path-membership tests. Symlinks are resolved here but
	--- not in `workspaces`, so the plugin still sees the paths as written.
	roots = vim.tbl_map(function(ws)
		return vim.uv.fs_realpath(ws.path) or ws.path
	end, workspaces),
}
