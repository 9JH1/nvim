# My NeoVim .files
these are my nvim otfiles, a perfect config and a even more perfect ide adds for a productive day. Enjoy.. or dont.
## Install (Unix):
```bash
mv $HOME/.config/nvim $HOME/.config/nvim_old
git clone https://github.com/9jh1/nvim
mv nvim $HOME/.config/nvim
npm install -g live-server
```
## Install (Windows)
to install my config on windows I will go through how to install neovim for windows too.
1. go to the [offical neovim github releases page](https://github.com/neovim/neovim/releases) and download the [nvim-win64.zip](https://github.com/neovim/neovim/releases/download/nightly/nvim-win64.zip) archive from the assets menu, next go to the [offical github download website](https://git-scm.com/downloads), click on windows and select 64-bit Git for Windows Portable.
2. make a new folder on your desktop or anywhere else and call it neovim, run the downloaded git portable installer and make it so it is installed to a folder called "git-portable" inside of the nvim folder on your desktop. next locate the downloaded nvim-win64.zip and extract it to the same folder on your desktop
3. go to `%APPDATA%/Local/` and make a new folder called `nvim`, now you can add your config, up the top of the page click on the "Code" dropdown then "Download ZIP", extract this file anywhere, look inside this zip until you find the folder `lua` from the directory outside of `lua` move the `lua` folder and everything inside it to the `%APPDATA%/Local/nvim` folder.
4. Finally go to `%APPDATA%/Local/nvim` and open `init.lua` for editing, add this to the very top `vim.env.PATH = "C:\\Users\\_3hy\\Downloads\\git-portable\\cmd;" .. vim.env.PATH` and save the file.
5. Go to your desktop and go into `nvim/bin` and there should be a `nvim.exe` file, run this and the lazy.nvim plugin will install the rest of the config :D.
## Features/Plugins:
1. Pressing **Control+G** will open up the telescope colorscheme previewer that lets you look though colorschemes and preview each. These dotfiles come with a few theme plugins, those being:<br>
    - [vim-neon-dark](https://github.com/nonetallt/vim-neon-dark) *(simple amoled pink theme)*
    - [neopywal](https://github.com/RedsXDD/neopywal.nvim) *(adapts to pywal color)*
    - [candyland](https://github.com/AmberLehmann/candyland.nvim) *(vibrant pink, blue and white theme)*
2. **EnableTransparencey** and **DisableTransparencey** commands, these custom commands let you toggle the background of vim to be semi-transparent, the background transparency often depends on the terminal emulator, but if configured with a composite manager you can see through vim to your desktop. 
3. [**ALE**](https://github.com/dense-analysis/ale), this plugin shows errors and warnings inside your code files, very useful in languages like C that you have to compile as the linter tells you issues beforehand.
4. [**last-color**](https://github.com/raddari/last-color.nvim), this plugin lets you save the last used colorscheme, this has allowed my config to re-enable the last used colorscheme.
5. [**LuaLine**](https://github.com/nvim-lualine/lualine.nvim), shows a neat bar at the bottom of vim which gives information about modes, file sizes and more, this plugin intergrates with **ALE** and will show you the amount of errors, warnings and other.
6. [**Barbar**](https://github.com/romgrk/barbar.nvim) adds fancey tab styles to the top of nvim.
7. [**Wilder**](https://github.com/gelguy/wilder.nvim) adds popup completion menus to most ui's.
8. [**Cellular Automaton**](https://github.com/eandrju/cellular-automaton.nvim) adds some crazy text animations for those times when youre bored.
9. [**Indent Blankline**](https://github.com/lukas-reineke/indent-blankline.nvim) adds some nice lines to indents.

