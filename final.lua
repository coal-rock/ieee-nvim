------- Lazy Bootstrap -------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
------------------------------


---- Plugin Installation ----
require("lazy").setup({
	-- Sexy ass theme 
	"ellisonleao/gruvbox.nvim",

	-- File explorer
	"nvim-tree/nvim-tree.lua",

	-- Mason, used for LSP installation
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",
})

---- Plugin Setup ----

-- Initialize Mason
require("mason").setup()
require("mason-lspconfig").setup()

-- Initialize nvim-tree
require("nvim-tree").setup()

---- Basic Configuration ----

-- Set colorscheme to the *best* (and only valid choice)
vim.cmd.colorscheme "gruvbox"

-- Enable sexy, 24-bit color
vim.o.termguicolors = true

-- Show current line number
vim.wo.number = true

-- Show relative line numbers
vim.wo.relativenumber = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Disable netrw (default nvim file explorer)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


---- Keybindings ----

-- Remap redo to something actually same
vim.keymap.set('n', 'U', vim.cmd.redo)

-- Stop highlighting search after pressing "escape"
vim.keymap.set('n', '<Esc>', function() vim.cmd 'noh' end)

-- Toggle nvim-tree with Space + f
vim.keymap.set('n', '<space>f', function() vim.cmd 'NvimTreeToggle' end)



