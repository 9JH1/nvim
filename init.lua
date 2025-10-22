require("config.lazy")

-- VARS AND CMDS
local vim = vim
local opt = vim.o
local map = vim.api.nvim_set_keymap
local oldmap = vim.keymap.set
local com = vim.api.nvim_create_user_command
local theme = require("last-color").recall() or "default"

require("scrollbar").setup({
    show = true,
		marks = {
			Cursor={
				text="",
			}
		}
	})

-- Show cursorcolumn only in the current (focused) window
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  pattern = "*",
  callback = function()
    vim.wo.cursorline = true
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  pattern = "*",
  callback = function()
    vim.wo.cursorline = false
  end,
})

-- local lsp = require("lsp-zero")
vim.cmd.colorscheme(theme)
vim.cmd('autocmd FileType c,cpp setlocal cinoptions+=L0')
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
opt.rnu = true
opt.mouse = "a"
opt.shell = "/bin/zsh"
opt.nu = true
opt.wrap = false
opt.numberwidth = 1
opt.tabstop = 2
opt.shiftwidth = 2
opt.swapfile = false
opt.autoread = true
opt.backup = true
opt.guicursor = 'n-v-c:block,i-ci-ve:block-blinkwait700-blinkoff400-blinkon250'
opt.backupdir = vim.fn.expand("~/.config/nvim/backups")
opt.undofile = true
vim.opt.foldtext = "v:lua.foldtext()"
opt.undodir = vim.fn.expand("~/.config/nvim/undo")
opt.cursorline = true
opt.cursorcolumn = false
opt.ruler = false
opt.shell = "bash"
opt.showtabline = 0
opt.cmdheight = 0

vim.api.nvim_create_autocmd({ "BufNewFile", "BufEnter" }, {
	pattern = "*", -- Apply to all files
	callback = function()
		local original_syntax = vim.bo.syntax
		local original_foldmethod = vim.opt_local.foldmethod:get()
		local original_foldlevel = vim.opt_local.foldlevel:get()

		vim.bo.syntax = vim.bo.filetype   -- Set syntax to match the detected filetype
		vim.opt_local.foldmethod = "syntax" -- Use syntax-based folding
		vim.opt_local.foldlevel = 99      -- Start with folds open
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
				vim.opt.signcolumn = "no"
			else
				vim.opt_local.foldcolumn = "2"
				opt.signcolumn = "yes"
			end
		end)
	end,
})

-- KEYBINDS & USER COMMANDS
map("n", "<C-O>", "<Esc>:Telescope find_files<CR>", {
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

map("n", "C-A", "<Esc>:BufferLineCyclePrev<CR>", {
	noremap = true,
	silent = true,
});

map("n", "C-D", "<Esc>:BufferLineCycleNext<CR>", {
	noremap = true,
	silent = true,
})

map("n", "<C-i>", "<Esc>:Telescope buffers<CR>", {
	noremap = true,
	silent = true
})

map("n", "<C-t>","<Esc>:Telescope diagnostics<CR>",{
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
vim.cmd("Neotree right")

local function get_wordcount()
  local word_count = 0

  if vim.fn.mode():find("[vV]") then
    word_count = vim.fn.wordcount().visual_words
  else
    word_count = vim.fn.wordcount().words
  end

  return word_count
end

local function wordcount()
  local label = "Word"
  local word_count = get_wordcount()

  if word_count > 1 then
    label = label .. "s"
  end

  return word_count .. " " .. label
end

local wpm = require("wpm");

require("colorizer").setup({ "*" })
require("lualine").setup({
	sections = {
		lualine_a = {},
		lualine_b = { "mode" },
		lualine_c = { "filename", "filesize",
		{
			wordcount, cond = is_prose
		},
		{
			wpm.wpm_component, cond = is_prose
		}
	},

		lualine_x = { "lsp_status", "diagnostics" },
		lualine_y = { "location", "progress", "searchcount" },
		lualine_z = {},
	},

	inactive_sections = { tabline },
	options = {
		theme = "auto",
		icons_enabled = true,
		section_separators = {
			left = "",
			right = "",
		},
		component_separators = {
			left = "|",
			right = "",
		},
		padding = 1,
	},
})



require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "html" },
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

require('bufferline').setup {
	options = {
		themable = true,
		color_icons = true,
		always_show_bufferline = false,
		buffer_close_icon = "",
		modified_icon = "[]",
		close_icon = "",
		color_icon = false,
		show_buffer_icons = false
	}
}

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		c = { "clang-format" },
		html = { "prettier" },
		css = { "prettier" },
	},
})


require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

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

local lsp = require("lsp-zero").preset({
	name = "minimal",
	set_lsp_keymaps = true,
	manage_nvim_cmp = true,
	suggest_lsp_servers = false,
})

lsp.setup()

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	update_in_insert = false,
	underline = true,
	severity_sort = false,
	float = true,
})

local cmp = require("cmp")
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{
			name = "cmdline",
			option = {
				ignore_cmds = { "Man", "!" },
			},
		},
	}),
})

require('nvim-devdocs').setup({
	ensure_installed = { "c" },
})

require('telescope').setup {
	defaults = {
		-- Customize the layout for all pickers
		layout_strategy = 'horizontal', -- or 'vertical'
		layout_config = { horizontal = { width = 0.9 } },
		-- Customize border for all pickers
		border = {},
		borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
		-- Other theme-related defaults can be set here
	},
	-- extensions = {
	--   themes = {
	--     layout_config = { ... },
	--   },
	-- },
}
