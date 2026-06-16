-- plugins
vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/projekt0n/github-nvim-theme",
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/folke/lazydev.nvim",
	"https://github.com/christoomey/vim-tmux-navigator",
})

require('lazydev').setup()

vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.signcolumn = "yes" -- prevent layout to shift while writing
vim.o.winborder = "rounded"
vim.cmd.colorscheme("github_dark_dimmed")
vim.cmd.hi("statusline guibg=NONE")
vim.g.mapleader = " "
vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.o.autocomplete = true

vim.lsp.config('arduino_language_server', {
	cmd = {
		"arduino-language-server",
		"-clangd", "/usr/bin/clangd",
		"-cli", "/usr/bin/arduino-cli",
		"-cli-config", "$HOME/.arduino15/arduino-cli.yaml",
		"-fqbn", "arduino:avr:uno"
	},
	filetypes = { "arduino" },
})

vim.lsp.enable({
	"lua_ls",
	"clangd",
	"arduino_language_server",
})

-- enable completion with lsp
-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	callback = function(ev)
-- 		local client = vim.lsp.get_client_by_id(ev.data.client_id)
-- 		if client:supports_method('textDocument/completion') then
-- 			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
-- 		end
-- 	end,
-- })
--
--

-- code from nvim documentation
vim.api.nvim_create_autocmd('LspAttach', {

	group = vim.api.nvim_create_augroup('my.lsp', {}),

	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

		if client:supports_method('textDocument/implementation') then
			-- Create a keymap for vim.lsp.buf.implementation ...
			-- TODO: udpate this so it works
			vim.keymap.set("i", "<C>i", vim.lsp.buf.implementation)
		end

		-- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			-- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			-- client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end

		-- Auto-format ("lint") on save.
		-- Usually not needed if server supports "textDocument/willSaveWaitUntil".
		-- if not client:supports_method('textDocument/willSaveWaitUntil')
		--     and client:supports_method('textDocument/formatting') then
		-- 	vim.api.nvim_create_autocmd('BufWritePre', {
		-- 		group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
		-- 		buffer = ev.buf,
		-- 		callback = function()
		-- 			vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
		-- 		end,
		-- 	})
		-- end
	end,

})

vim.opt.clipboard = "unnamedplus"

vim.keymap.set('n', "<leader>l", vim.lsp.buf.format)
vim.keymap.set('n', "<leader>en", function() vim.diagnostic.jump({ count = 1, float = true }) end)
vim.keymap.set('n', "<leader>ep", function() vim.diagnostic.jump({ count = -1, float = true }) end)
vim.keymap.set('n', "<leader>i", vim.lsp.buf.hover)
vim.keymap.set('n', "<leader>r", vim.lsp.buf.rename)
vim.keymap.set('n', "<leader>gd", vim.lsp.buf.definition)
vim.keymap.set('n', "<leader>ff", require("fzf-lua").files)
vim.keymap.set('n', "<leader>fg", require("fzf-lua").live_grep)
vim.keymap.set('n', "<leader>fr", require("fzf-lua").resume)
vim.keymap.set({ 'v', 'x' }, "<leader>y", '"+y', { noremap = true })
vim.keymap.set('x', "<leader>p", '"+P', { noremap = true })

