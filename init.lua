
-- setup plugins
require("config.lazy")
local theme = require('last-color').recall() or 'default'
vim.cmd.colorscheme(theme)
require('lualine').setup{
	options = {
			theme = "auto"
	}	
}
wilder = require("wilder")
 wilder.set_option('renderer', wilder.popupmenu_renderer({
  pumblend = 20,
}))
-- set defaults
vim.cmd("call wilder#setup({'modes': [':', '/', '?']})")
-- set vim config
vim.o.background = "dark" -- or "light" for light mode
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.guicursor= "n-v-c-i:block"
vim.opt.syntax = "on"
vim.opt.rnu = true
vim.opt.mouse = "a"
vim.opt.nu = true
vim.opt.wrap = false
vim.opt.numberwidth = 1
vim.opt.foldmethod = "syntax"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.swapfile = false
vim.opt.shortmess:append("I")
vim.opt.autoread = true
vim.opt.foldlevel = 999

vim.opt.backup = true
vim.opt.backupdir = vim.fn.expand("~/.config/nvim/backups")
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undo")
-- Key mappings
vim.api.nvim_set_keymap('i', '<C-f>', '<C-O>:normal! za<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-f>', ':normal! za<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<Esc>[Z', '<Esc>:normal! gT<CR>i', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Esc>[Z', ':normal! gT<CR>', { noremap = true, silent = true })

-- Enable filetype detection and plugins
vim.cmd([[
  filetype plugin on
  filetype indent on
]])

-- Custom fold text function
function MyFoldText()
	local fold_start = vim.v.foldstart
    local fold_end = vim.v.foldend
    local fold_line_count = fold_end - fold_start + 1
    local first_line = "+< " .. vim.fn.getline(vim.v.foldstart) .. " "
		local last_line = " [ " .. fold_line_count .. " Lines ] "
    local spaces = string.rep(' ', vim.o.columns - string.len(first_line)-7-string.len(last_line))
    return first_line .. ' ' .. spaces .. last_line
end

-- set fold 
vim.opt.foldtext = "v:lua.MyFoldText()"
vim.cmd("TSToggle highlight")

-- vim.keymap.del('i', '<C-r>')
vim.api.nvim_set_keymap('n', '<C-a>', ':tabprev<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-d>', ':tabnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-w>', ':tabclose<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-S-c>', ':tabnew | :tabprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-g>',':Telescope colorscheme enable_preview=true<CR>',{noremap=true,silent=true})


vim.cmd([[
  augroup TabHistory
    autocmd!
    autocmd BufDelete * if tabpagenr('$') > 1 | tabnew | endif
  augroup END
]])

-- activate the cursor option
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
require('colorizer').setup({'*'})

function EnableTransparency()
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
	vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
end

function DisableTransparency()
	local last_colorscheme = require('last-color').recall() or 'default'
  vim.cmd.colorscheme(last_colorscheme)
end

vim.api.nvim_create_user_command("EnableTransparency", EnableTransparency, {})
vim.api.nvim_create_user_command("DisableTransparency",DisableTransparency,{})

function emmet_on_current_line()
  -- Ask for Emmet abbreviation input
  local user_input = vim.fn.input("Insert Emmet: ")

  -- Run Emmet on the current line (without selecting visually)
  vim.cmd(':Emmet ' .. user_input)
  vim.cmd('startinsert')  -- Return to insert mode safely
end

-- Create the user command for Emmet
vim.api.nvim_create_user_command("EmmetPrompt", emmet_on_current_line, {})
-- Bind Ctrl+E in insert mode to trigger the EmmetPrompt function
vim.api.nvim_set_keymap('i', '<C-E>', '<Esc>:EmmetPrompt<CR>', { noremap = true, silent = true })
require("neo-tree").setup({
window = {
		position = "float"
  }
})

vim.api.nvim_set_keymap("i", '<C-O>','<Esc>:Neotree<CR>', { noremap = true, silent = true })
