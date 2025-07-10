require("config.lazy")

-- VARS AND CMDS
local theme = require('last-color').recall() or 'default'
vim.cmd.colorscheme(theme)
vim.cmd("call wilder#setup({'modes': [':', '/', '?']})")

-- SET VALUES
vim.o.laststatus = 0
vim.o.background = "dark"
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.rnu = true
vim.opt.mouse = "a"
vim.opt.nu = true
vim.opt.wrap = false
vim.opt.numberwidth = 1
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.swapfile = true
vim.opt.shortmess:append("I")
vim.opt.autoread = true
vim.opt.backup = true
vim.opt.backupdir = vim.fn.expand("~/.config/nvim/backups")
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undo")
vim.opt.cursorline = false
vim.opt.cursorcolumn = false
vim.o.foldenable = true
vim.o.foldlevel = 999
vim.o.foldmethod = "manual"  -- Safer global default
vim.o.ruler = false

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    pattern = "*", -- Apply to all files
    callback = function()
        -- Store original settings
        local original_syntax = vim.bo.syntax
        local original_foldmethod = vim.opt_local.foldmethod:get()
        local original_foldlevel = vim.opt_local.foldlevel:get()

        -- Apply desired folding settings
        vim.bo.syntax = vim.bo.filetype -- Set syntax to match the detected filetype
        vim.opt_local.foldmethod = "syntax" -- Use syntax-based folding
        vim.opt_local.foldlevel = 99 -- Start with folds open
        -- Check if folding is actually supported
        vim.schedule(function()
            local has_folds = false
            -- Scan up to 1000 lines or the entire buffer, whichever is smaller
            local max_lines = math.min(vim.fn.line('$'), 1000)
            for i = 1, max_lines do
                if vim.fn.foldlevel(i) > 0 then
                    has_folds = true
                    break
                end
            end

            if not has_folds then
                -- No folds detected, revert settings
                vim.bo.syntax = original_syntax
                vim.opt_local.foldmethod = original_foldmethod
                vim.opt_local.foldlevel = original_foldlevel
                -- Notify user
                vim.notify("Syntax folding not available for this buffer", vim.log.levels.INFO)
							else 
								vim.opt_local.foldcolumn = "2"
							end
        end)
    end,
})

-- FUNCTIONS
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

function emmet_on_current_line()
  local user_input = vim.fn.input("Insert Emmet: ")
  vim.cmd(':Emmet ' .. user_input)
  vim.cmd('startinsert')
end

-- KEYBINDS & USER COMMANDS
vim.keymap.set('n', '<C-E>', '<Esc>:Neotree right toggle<CR><Esc>:wincmd p<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-g>', '<ESC>:Telescope colorscheme enable_preview=true<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('i', '<C-W>', '<Esc>:EmmetPrompt<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", '<C-O>', '<Esc>:Neotree float<CR>', { noremap = true, silent = true })

vim.api.nvim_create_user_command("EnableTransparency", EnableTransparency, {})
vim.api.nvim_create_user_command("DisableTransparency", DisableTransparency, {})
vim.api.nvim_create_user_command("EmmetPrompt", emmet_on_current_line, {})

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
    lualine_b = {'filename'},
    lualine_c = {'filetype'},
    lualine_x = {'diagnostics'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  sections = {},
  inactive_sections = {},
  options = {
    theme = 'auto',
    icons_enabled = true,
    section_separators = {
      left = '',
      right = ''
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
    highlights = {
      border = 'Normal',
    },
    border = 'rounded',
		left = {' ', wilder.popupmenu_devicons()},
  	right = {' ', wilder.popupmenu_scrollbar()},
  })
))


require("presence").setup({
    -- General options
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

    -- Rich Presence text options
    editing_text        = "Editing %s",
    file_explorer_text  = "Browsing %s",
    git_commit_text     = "Committing changes",
    plugin_manager_text = "Managing plugins",
    reading_text        = "Reading %s",
    workspace_text      = "Working on %s",
    line_number_text    = "Line %s out of %s",
})
