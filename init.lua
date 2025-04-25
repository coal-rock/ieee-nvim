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

---- Plugin Installation ----
require("lazy").setup({
    -- Gruvbox, sexy ass colorscheme
    "ellisonleao/gruvbox.nvim",

    -- Tokyonight, close second colorscheme
    "folke/tokyonight.nvim",

    -- Snacks, a collection of QoL plugins that add many features
    { "folke/snacks.nvim" },

    -- Fidget, gives us LSP status in bottm right corner
    "j-hui/fidget.nvim",

    -- ToggleTerm, nice quality of life wrapper for the default Neovim terminal
    { 'akinsho/toggleterm.nvim', opts = {} },

    -- Neo-tree, file explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        opts = {},
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
        }
    },

    -- Pretty icons
    "nvim-tree/nvim-web-devicons",

    -- Mason, used for LSP installation
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",

    -- Telescope, a "fuzzy finder" - does many things
    'nvim-telescope/telescope.nvim',

    -- Nvim-cmp, used for autocomplete
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",     -- LSP source
            "hrsh7th/cmp-buffer",       -- Buffer words

            "hrsh7th/cmp-path",         -- Filesystem paths
            "hrsh7th/cmp-cmdline",      -- Command line completion

            "saadparwaiz1/cmp_luasnip", -- Snippet integration
            "L3MON4D3/LuaSnip",         -- Snippet engine
        },
    },

    -- Lazydev, gives us auto-complete for the Neovim Lua API
    { 'folke/lazydev.nvim',            ft = "lua",                                opts = {} },

    -- Lualine, gives us a pretty status line
    { 'nvim-lualine/lualine.nvim',     opts = {} },

    -- Nvim-autopairs, automatically matches "{" with "}"
    { 'windwp/nvim-autopairs',         event = "InsertEnter",                     config = true },

    -- Telescope, gives us fast, comfy fuzzy finding (search through files, lsp suggestions, etc)
    { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },

    -- Treesitter, basically magic
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },

    -- Todo-comments, gives us:
    -- TODO: highlighting
    { "folke/todo-comments.nvim", opts = {} },

    -- Lsp-lines, gives us inline error lense
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
})


---- Plugin Setup ----

-- Configure dashbord
require("snacks").setup {
    dashboard = {
        formats = {
            header = {
                '░▒▓█▓▒░ ░▒▓████████▓▒░ ░▒▓████████▓▒░ ░▒▓████████▓▒░\n' ..
                '░▒▓█▓▒░ ░▒▓█▓▒░        ░▒▓█▓▒░        ░▒▓█▓▒░       \n' ..
                '░▒▓█▓▒░ ░▒▓█▓▒░        ░▒▓█▓▒░        ░▒▓█▓▒░       \n' ..
                '░▒▓█▓▒░ ░▒▓██████▓▒░   ░▒▓██████▓▒░   ░▒▓██████▓▒░  \n' ..
                '░▒▓█▓▒░ ░▒▓█▓▒░        ░▒▓█▓▒░        ░▒▓█▓▒░       \n' ..
                '░▒▓█▓▒░ ░▒▓█▓▒░        ░▒▓█▓▒░        ░▒▓█▓▒░       \n' ..
                '░▒▓█▓▒░ ░▒▓████████▓▒░ ░▒▓████████▓▒░ ░▒▓████████▓▒░',
                align = "center"
            }
        },
        sections = {
            { section = "header" },
            { icon = " ", title = "Actions", section = "keys", indent = 2, padding = 1 },
            { section = "startup" },
            {
                title = "“So, you can continue to use your arrow keys and mouse to navigate, but make no mistake...",
                align = "center",
                padding = { 0, 5 },
            },
            {
                title = "there is no faster way to edit text than through vi/vim”",
                align = "center",
                padding = { 1, 0 },

            },
            {
                title = "-Phipps",
                align = "center",

            },
        },
    },
}


-- Initialize Mason
require("mason").setup()
require("mason-lspconfig").setup()

-- Initialize Nvim-cmp
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup {}

-- Configure nvim-cmp, for autocomletion
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        -- Manually open completion menu with Ctrl+Space
        ['<C-Space>'] = cmp.mapping.complete {},

        -- Accept completion with Enter
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },

        -- Cycle through completions with Tab
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),

        -- Cycle through completions backwards with Shift+Tab
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },

    -- Specify where we want to pull sources for completion from
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = "lazydev" },
    },
}


-- Configure treesitter
require('nvim-treesitter.configs').setup {
    -- Allow async installation
    sync_install = false,

    -- Automatically install treesitter grammar for whatever language we're working with
    auto_install = true,

    -- We leave these blank, as we don't want to configure them at the moment
    ensure_installed = {},
    ignore_install = {},
    modules = {},

    highlight = {
        -- Enable syntax-aware highlighting
        enable = true,
        -- Remove old, dumb highlighting
        additional_vim_regex_highlighting = false,
    },
}

-- We plug nvim-cmp into each language server here for autocompletion support
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

require("mason-lspconfig").setup_handlers {
    -- Automatically configure LSPs
    function(server_name)
        require("lspconfig")[server_name].setup {
            capabilities = capabilities,
        }
    end
}

-- Configure telescope
require('telescope').setup {
    defaults = {
        -- We shouldn't be searching here, this can slow down performance and bloat results
        file_ignore_patterns = { "node_modules", "target/" },
        -- Keybindings!
        mappings = {
            i = {
                ['<Esc>'] = 'close',
                ['<C-u>'] = false,
                ['<C-d>'] = false,
                ['<Tab>'] = require('telescope.actions').move_selection_next,
                ['<S-Tab>'] = require('telescope.actions').move_selection_previous,
            },
        },
    },
}


---- Basic Configuration ----

-- Enable lazydev
vim.g.lazydev_enabled = true

-- Set colorscheme to the *best* (and only valid choice)
vim.cmd.colorscheme "gruvbox"

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Enable sexy, 24-bit color
vim.o.termguicolors = true

-- Always show sign column, we get layout shifts without this
vim.o.signcolumn = "yes"

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Sync yank with system clipboard
vim.o.clipboard = 'unnamed,unnamedplus'

-- Show current line number
vim.wo.number = true

-- Show relative line numbers
vim.wo.relativenumber = true

-- Tabs should be 4 spaces
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0

-- Disable virtual_text, this is replaced with Lsp-lines
vim.diagnostic.config({ virtual_text = false })

-- Disabe line-wrapping
vim.cmd.set 'nowrap'

-- Make scrolloff behavior mimic Helix
vim.o.scrolloff = 5

---- Keybindings ----

-- Remap redo to something actually same
vim.keymap.set('n', 'U', vim.cmd.redo)

-- Stop highlighting search after pressing "escape"
vim.keymap.set('n', '<Esc>', function() vim.cmd 'noh' end)

-- Toggle nvim-tree with Space + f
vim.keymap.set('n', '<space>f', function() vim.cmd "Neotree toggle" end)

-- Toggle terminal with Space + y
vim.keymap.set('n', '<space>t', function() vim.cmd "ToggleTerm" end)

-- Peek definition with Shift+K
vim.keymap.set('n', 'K', vim.lsp.buf.hover)

-- Peek error/warning with Shift+J
vim.keymap.set('n', 'J', vim.diagnostic.open_float)

-- Toggle lsp_lines
vim.keymap.set('n', 'L', require("lsp_lines").toggle)

-- Go to definition
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)

-- Go to references
vim.keymap.set('n', 'gr', require("telescope.builtin").lsp_references)

-- LSP-aware rename
vim.keymap.set('n', '<space>cr', vim.lsp.buf.rename)

-- Open LSP actions
vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action)

-- Search document symbols
vim.keymap.set('n', '<space>ss', require("telescope.builtin").lsp_document_symbols)

-- Search workspace symbols
vim.keymap.set('n', '<space>sS', require("telescope.builtin").lsp_dynamic_workspace_symbols)

-- Search workspace diagnostics
vim.keymap.set('n', '<leader>sD', require('telescope.builtin').diagnostics)

-- Search workspace via grep
vim.keymap.set('n', '<space>sg', require("telescope.builtin").live_grep)

-- Search workspace files
vim.keymap.set('n', '<space>sf', require('telescope.builtin').find_files)

-- Search installed color schemes
vim.keymap.set('n', '<space>sc', function()
    require("telescope.builtin").colorscheme({
        enable_preview = true,
    })
end)

-- Maps <Esc> to normal mode from the terminal
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

---- Custom Commands ----

-- Creates the ":Format" command, that automatically formats the current buffer
vim.api.nvim_create_user_command("Format", function()
    vim.lsp.buf.format()
end, {})


---- Format on write ----
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

---- LSP-Specific Configuration ----
