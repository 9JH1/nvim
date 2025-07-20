require("config.lazy")

-- VARS AND CMDS
local vim = vim
local opt = vim.o
local map = vim.api.nvim_set_keymap
local com = vim.api.nvim_create_user_command
local theme = require('last-color').recall() or 'default'
vim.cmd.colorscheme(theme)
vim.cmd("call wilder#setup({'modes': [':', '/', '?']})")

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
  local last_colorscheme = require('last-color').recall() or 'default'
  vim.cmd.colorscheme(last_colorscheme)
end

local function emmet_on_current_line()
  local user_input = vim.fn.input("Insert Emmet: ")
  vim.cmd(':Emmet ' .. user_input)
  vim.cmd('startinsert')
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
vim.opt.foldtext = 'v:lua.foldtext()'
opt.undodir = vim.fn.expand("~/.config/nvim/undo")
opt.cursorline = false
opt.cursorcolumn = false
opt.ruler = false

vim.api.nvim_create_autocmd({"BufNewFile","BufEnter"}, {
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
      local max_lines = math.min(vim.fn.line('$'), 1000)
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
        vim.notify("Syntax folding not available for this buffer", vim.log.levels.INFO)
			else
				vim.opt_local.foldcolumn = "2"
			end
    end)
  end,
})


-- KEYBINDS & USER COMMANDS
map('n', '<C-E>', '<Esc>:Neotree right toggle<CR><Esc>:wincmd p<CR>', { noremap = true, silent = true })
map('n', '<C-g>', '<ESC>:Telescope colorscheme enable_preview=true<CR>', {noremap=true, silent=true})
map('i', '<C-W>', '<Esc>:EmmetPrompt<CR>', { noremap = true, silent = true })
map("n", '<C-O>', '<Esc>:Neotree float<CR>', { noremap = true, silent = true })
com("EnableTransparency", EnableTransparency, {})
com("DisableTransparency", DisableTransparency, {})
com("EmmetPrompt", emmet_on_current_line, {})


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
    statusline = false
  }
})

require('colorizer').setup({'*'})
require('lualine').setup({
  tabline = {
    lualine_a = {'mode'},
    lualine_b = {'filetype'},
    lualine_c = {'filesize'},
    lualine_x = {'diagnostics'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },


	sections = {
		lualine_a = {
			{
				'buffers',
				show_filename_only = true,
				mode = 2,
				use_mode_colors = true,
			}
		},
		lualine_b = {},
    lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
  },

  inactive_sections = {},
  options = {
    theme = 'auto',
    icons_enabled = true,
    section_separators = {
      left = ' ',
      right = ''
    }
  }
})

require('nvim-treesitter.configs').setup {
  ensure_installed = { "c" },
  highlight = { enable = true },
  fold = { enable = true },
}

local wilder = require("wilder");
wilder.set_option('renderer', wilder.popupmenu_renderer(
  wilder.popupmenu_border_theme({
    highlights = { border = 'Normal', },
    border = 'rounded',
		left = {' ', wilder.popupmenu_devicons()},
  	right = {' ', wilder.popupmenu_scrollbar()},
  })
))

require("presence").setup({
    auto_update         = true,
    neovim_image_text   = "The One True Text Editor",
    main_image          = "neovim",
    client_id           = "793271441293967371",
    log_level           = nil,
    debounce_timeout    = 10,
    enable_line_number  = false,
    blacklist           = {},
    buttons             = true,
    file_assets         = {},
    show_time           = true,
    editing_text        = "Editing %s",
    file_explorer_text  = "Browsing %s",
    git_commit_text     = "Committing changes",
    plugin_manager_text = "Managing plugins",
    reading_text        = "Reading %s",
    workspace_text      = "Working on %s",
    line_number_text    = "Line %s out of %s",
})

require("notify").setup({
	render = "compact",
})

require("bufferline").setup{
	options = {
		themable=true,
		color_icons=true,
	}
}
