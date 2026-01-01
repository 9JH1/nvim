require("config.lazy")

-- Load the last colorscheme
local theme = require('last-color').recall() or 'default'
vim.cmd.colorscheme(theme)

-- VARS AND CMDS
local vim = vim
local opt = vim.o
local map = vim.api.nvim_set_keymap
local oldmap = vim.keymap.set
local com = vim.api.nvim_create_user_command

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

-- Restore cursor position when reopening files
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local row = mark[1]
		local col = mark[2]

		if row > 0 and row <= vim.api.nvim_buf_line_count(0) then
			-- Avoid jumping in special files (e.g. git commit messages)
			if vim.bo.filetype ~= "gitcommit" and vim.bo.filetype ~= "gitrebase" then
				vim.api.nvim_win_set_cursor(0, {row, col})
			end
		end
	end,
})


vim.cmd('autocmd FileType c,cpp setlocal cinoptions+=L0')

-- FUNCTIONS
local function EnableTransparency()
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
	vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
end

-- SET VALUES
opt.laststatus = 3
vim.opt.fillchars = { fold = " " }
opt.background = "dark"
opt.termguicolors = false
opt.rnu = true
opt.mouse = "a"
opt.nu = true
opt.wrap = true
opt.numberwidth = 1
opt.tabstop = 4
opt.shiftwidth = 4
opt.swapfile = false
opt.autoread = false
opt.backup = true
opt.backupdir = vim.fn.expand("~/.config/nvim/backups")
opt.undofile = true
opt.undodir = vim.fn.expand("~/.config/nvim/undo")
opt.cursorline = true
opt.cursorcolumn = false
opt.ruler = false
opt.shell = "bash"
opt.showtabline = 1
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

map("n", "<C-A>", "<Esc>:BufferLineCyclePrev<CR>", {
	noremap = true,
	silent = true,
});

map("n", "<C-D>", "<Esc>:BufferLineCycleNext<CR>", {
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

map("n", "gh", "<esc>:URLOpenUnderCursor<cr>", {
	noremap = true,
	silent = true
})

map("n", "<leader>ef","<Esc>:Yazi<CR>", {
	noremap = true,
	silent = true
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


require("lualine").setup({
	sections = {
		lualine_a = {},
		lualine_b = { "mode" },
		lualine_c = { "filename", "filesize",
			{
				wordcount, cond = is_prose
			},
		},

		lualine_x = { "lsp_status", "diagnostics" },
		lualine_y = { "location", "progress", "searchcount" },
		lualine_z = {}
	},

	tablime = {
		lualine_a = {"buffers"}
	},

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

local signs = {
  Error = "x",
  Warn = "!",
  Hint = "h",
  Info = "i"
}

vim.diagnostic.config({
	signs = {
    active = true,
		text = {
			[vim.diagnostic.severity.ERROR] = signs.Error,
			[vim.diagnostic.severity.WARN] = signs.Warn,
			[vim.diagnostic.severity.HINT] = signs.Hint,
			[vim.diagnostic.severity.INFO] = signs.Info
		}
  },
	upadte_in_insert = false,
	virtual_text = true,
	update_in_insert = false,
	underline = true,
	severity_sort = false,
	float = true,
})

require('telescope').setup {
	defaults = {
		layout_strategy = 'horizontal', -- or 'vertical'
		layout_config = { horizontal = { width = 0.9 } },
		border = {},
		borderchars = { '-', '|', '-', '|', '+', '+', '+', '+' },
	},
}

require("bufferline").setup({
	options = {
		mode = "buffers",
		style_preset = require("bufferline").style_preset.minimal,
		themeable = true,
		numbers = "ordinal",
		always_show_bufferline = false,

		indicator = {
			style = "none",
			diagnostics = "nvim_lsp",
		},

		tab_size = 0,

		show_buffer_icons = false,
		show_buffer_close_icons = false,
		show_close_icon = false,
		show_tab_indicators = false,
		seperator_style = "thin",
	}
})

local cmp = require("cmp")

vim.lsp.config('clangd', {
  cmd = {'clangd'},
  filetypes = {'c', 'h'},
  root_markers = {},
})

vim.lsp.enable('clangd')

cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
		{ name = "nvim_lsp" }
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	},
	{
		{
			name = "cmdline",
		},
	}),
})

