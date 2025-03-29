# My NeoVim .files
these are my nvim dotfiles, a perfect config and a even more perfect ide adds for a productive day. Enjoy.. or dont.
## Install (Unix):
```bash
mv $HOME/.config/nvim $HOME/.config/nvim_old
git clone https://github.com/9jh1/nvim
mv nvim $HOME/.config/nvim
```
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

