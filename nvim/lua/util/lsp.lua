local M = {}

M.on_attach = function(client, bufnr)
	local opts = function(desc)
		return { noremap = true, silent = true, buffer = bufnr, desc = desc }
	end

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("Find references"))
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover documentation"))
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
	vim.keymap.set("n", "<leader>D", vim.diagnostic.open_float, opts("Line diagnostics"))
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts("Previous diagnostic"))
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts("Next diagnostic"))
	vim.keymap.set("n", "<leader>q", "<cmd>cclose<CR>", opts("Close quickfix"))

	if client.name == "pyright" then
		vim.keymap.set("n", "<leader>oi", "<cmd>PyrightOrganizeImports<CR>", opts("Organise imports"))
	end
end

M.typescript_organise_imports = {
	description = "Organise Imports",
	function()
		local params = {
			command = "_typescript.organizeImports",
			arguments = { vim.fn.expand("%:p") },
		}
		-- reorganise imports
		vim.lsp.buf.execute_command(params)
	end,
}

return M
