
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
vim.api.nvim_set_keymap('i', '<C-a>', ':tabprev<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-d>', ':tabnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-w>', ':tabclose<CR>', { noremap = true, silent = true })
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
require("presence").setup({
    -- General options
    auto_update         = true,                       -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
    neovim_image_text   = "The One True Text Editor", -- Text displayed when hovered over the Neovim image
    main_image          = "neovim",                   -- Main image display (either "neovim" or "file")
    client_id           = "793271441293967371",       -- Use your own Discord application client id (not recommended)
    log_level           = nil,                        -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
    debounce_timeout    = 10,                         -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
    enable_line_number  = false,                      -- Displays the current line number instead of the current project
    blacklist           = {},                         -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
    buttons             = true,                       -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
    file_assets         = {},                         -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
    show_time           = true,                       -- Show the timer

    -- Rich Presence text options
    editing_text        = "Editing %s",               -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
    file_explorer_text  = "Browsing %s",              -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
    git_commit_text     = "Committing changes",       -- Format string rendered when committing changes in git (either string or function(filename: string): string)
    plugin_manager_text = "Managing plugins",         -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
    reading_text        = "Reading %s",               -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
    workspace_text      = "Working on %s",            -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
    line_number_text    = "Line %s out of %s",        -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
})
vim.api.nvim_set_keymap("i", '<C-O>','<Esc>:Neotree<CR>', { noremap = true, silent = true })
