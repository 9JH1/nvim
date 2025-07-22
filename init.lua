require("config.lazy")
-- VARS AND CMDS
local vim = vim
local opt = vim.o
local map = vim.api.nvim_set_keymap
local oldmap = vim.keymap.set
local com = vim.api.nvim_create_user_command
local theme = require("last-color").recall() or "default"
-- local lsp = require("lsp-zero")
vim.cmd.colorscheme(theme)
-- FUNCTIONS
local function EnableTransparency()
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
	vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
end
foldtext = function()
	local title = table.concat(vim.fn.getbufline(vim.api.nvim_get_current_buf(), vim.v.foldstart))
	return "▼ " .. title
end

local function DisableTransparency()
	local last_colorscheme = require("last-color").recall() or "default"
	vim.cmd.colorscheme(last_colorscheme)
end

local function emmet_on_current_line()
	local user_input = vim.fn.input("Insert Emmet: ")
	vim.cmd(":Emmet " .. user_input)
	vim.cmd("startinsert")
end

local function move_to_buffer()
	local user_input = vim.fn.input("^W")
	vim.cmd("LualineBuffersJump " .. user_input)
end

-- SET VALUES
vim.notify = require("notify")
opt.laststatus = 3
vim.opt.fillchars = { fold = " " }
opt.background = "dark"
opt.termguicolors = true
opt.signcolumn = "yes"
opt.rnu = true
opt.mouse = "a"
opt.nu = true
opt.wrap = false
opt.numberwidth = 1
opt.tabstop = 2
opt.shiftwidth = 2
opt.swapfile = false
opt.autoread = true
opt.backup = true
opt.backupdir = vim.fn.expand("~/.config/nvim/backups")
opt.undofile = true
vim.opt.foldtext = "v:lua.foldtext()"
opt.undodir = vim.fn.expand("~/.config/nvim/undo")
opt.cursorline = false
opt.cursorcolumn = false
opt.ruler = false
opt.shell = "bash"
vim.g.ale_completion_enabled = 0

vim.api.nvim_create_autocmd({ "BufNewFile", "BufEnter" }, {
	pattern = "*", -- Apply to all files
	callback = function()
		local original_syntax = vim.bo.syntax
		local original_foldmethod = vim.opt_local.foldmethod:get()
		local original_foldlevel = vim.opt_local.foldlevel:get()

		vim.bo.syntax = vim.bo.filetype -- Set syntax to match the detected filetype
		vim.opt_local.foldmethod = "syntax" -- Use syntax-based folding
		vim.opt_local.foldlevel = 99 -- Start with folds open
		vim.schedule(function()
			local has_folds = false
			local max_lines = math.min(vim.fn.line("$"), 1000)
			for i = 1, max_lines do
				if vim.fn.foldlevel(i) > 0 then
					has_folds = true
					break
				end
			end

			if not has_folds then
				vim.bo.syntax = original_syntax
				vim.opt_local.foldmethod = original_foldmethod
				vim.opt_local.foldlevel = original_foldlevel
				vim.opt_local.foldcolumn = "0"
			else
				vim.opt_local.foldcolumn = "2"
			end
		end)
	end,
})

-- KEYBINDS & USER COMMANDS
map("n", "<C-O>", "<Esc>:Neotree float toggle<CR><Esc>:wincmd p<CR>", {
	noremap = true,

	silent = true,
})

map("n", "<C-g>", "<ESC>:Telescope colorscheme enable_preview=true<CR>", {
	noremap = true,
	silent = true,
})

map("i", "<C-E>", "<Esc>:EmmetPrompt<CR>", {
	noremap = true,
	silent = true,
})

map("n", "<C-W>", "<Esc>:MoveToBuffer<CR>", {
	noremap = true,
	silent = true,
})

oldmap("n", "<A-h>", require("smart-splits").resize_left)
oldmap("n", "<A-j>", require("smart-splits").resize_down)
oldmap("n", "<A-k>", require("smart-splits").resize_up)
oldmap("n", "<A-l>", require("smart-splits").resize_right)

-- moving between splits
oldmap("n", "<C-h>", require("smart-splits").move_cursor_left)
oldmap("n", "<C-j>", require("smart-splits").move_cursor_down)
oldmap("n", "<C-k>", require("smart-splits").move_cursor_up)
oldmap("n", "<C-l>", require("smart-splits").move_cursor_right)
oldmap("n", "<C-\\>", require("smart-splits").move_cursor_previous)

-- swapping buffers between windows
oldmap("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
oldmap("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
oldmap("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
oldmap("n", "<leader><leader>l", require("smart-splits").swap_buf_right)

-- not cursor movement events.
oldmap("i", "<C-h>", "<Left>", { noremap = true, silent = true })
oldmap("i", "<C-j>", "<Down>", { noremap = true, silent = true })
oldmap("i", "<C-k>", "<Up>", { noremap = true, silent = true })
oldmap("i", "<C-l>", "<Right>", { noremap = true, silent = true })

com("EnableTransparency", EnableTransparency, {})
com("DisableTransparency", DisableTransparency, {})
com("EmmetPrompt", emmet_on_current_line, {})
com("MoveToBuffer", move_to_buffer, {})

-- SETUP PLUGINS
require("neo-tree").setup({
	window = {
		position = "left",
		auto_expand_width = true,
		width = 0,
		max_width = 40,
	},
	source_selector = {
		winbar = false,
		statusline = false,
	},
})

require("colorizer").setup({ "*" })
require("lualine").setup({
	tabline = {
		lualine_a = { "mode" },
		lualine_b = { "filetype" },
		lualine_c = { "filesize" },
		lualine_x = { "diagnostics" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},

	sections = {
		lualine_a = {
			{
				"buffers",
				show_filename_only = true,
				mode = 2,
				use_mode_colors = true,
			},
		},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "selectioncount", "searchcount" },
	},

	inactive_sections = {},
	options = {
		theme = "auto",
		icons_enabled = true,
		section_separators = {
			left = " ",
			right = "",
		},
	},
})

require("nvim-treesitter.configs").setup({
	ensure_installed = { "c" },
	highlight = { enable = true },
	fold = { enable = true },
})

require("presence").setup({
	auto_update = true,
	neovim_image_text = "The One True Text Editor",
	main_image = "neovim",
	client_id = "793271441293967371",
	log_level = nil,
	debounce_timeout = 10,
	enable_line_number = true,
	blacklist = {},
	buttons = true,
	file_assets = {},
	show_time = true,
	editing_text = "Editing %s",
	file_explorer_text = "Browsing %s",
	git_commit_text = "Committing changes",
	plugin_manager_text = "Managing plugins",
	reading_text = "Reading %s",
	workspace_text = "Working on %s",
	line_number_text = "Line %s out of %s",
})

require("notify").setup({
	render = "compact",
})

require("bufferline").setup({
	options = {
		themable = true,
		color_icons = true,
	},
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		c = { "clang-format" },
		html = { "prettier" },
		css = { "prettier" },
	},
})

require("conform").setup({
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 2000,
		lsp_format = "prettier",
	},
})

--require("mason").setup({
--	ui = {
--		icons = {
--			package_installed = "✓",
--			package_pending = "➜",
--			package_uninstalled = "✗",
--		},
--	},
--})

require("livepreview.config").set()

require("smart-splits").setup({
	ignored_buftypes = {
		"nofile",
		"quickfix",
		"prompt",
	},
	ignored_filetypes = { "NvimTree" },
	default_amount = 3,
	at_edge = "wrap",
	float_win_behavior = "previous",
	move_cursor_same_row = false,
	cursor_follows_swapped_bufs = false,
	ignored_events = {
		"BufEnter",
		"WinEnter",
	},
	multiplexer_integration = nil,
	disable_multiplexer_nav_when_zoomed = true,
	kitty_password = nil,
	zellij_move_focus_or_tab = false,
	log_level = "info",
})

-- Enable signs in the gutter for diagnostics
vim.fn.sign_define("DiagnosticSignError", { text = "❌", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "⚠️", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "ℹ️", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "💡", texthl = "DiagnosticSignHint" })

-- Configure diagnostics to show virtual text only on lines that have errors
vim.diagnostic.config({
	virtual_text = {
		prefix = "●", -- Could be any symbol you like
		spacing = 2,
		-- Show virtual text only for errors and warnings
		severity = { min = vim.diagnostic.severity.WARN },
	},
	signs = true, -- Show signs in the gutter
	update_in_insert = false, -- Update diagnostics only when leaving insert mode
	underline = true, -- Underline errors in text
	severity_sort = true, -- Sort diagnostics by severity
})

-- Optional: keymaps to navigate diagnostics
vim.api.nvim_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = true })

local lsp = require("lsp-zero")
lsp.preset("recommended")
lsp.nvim_workspace()
lsp.setup()
