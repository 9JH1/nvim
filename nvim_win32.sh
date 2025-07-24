#!/bin/bash 

# run this inside of git bash

# remove old dir ( if exists )
if [  -d "nvim" ];then 
	rm -rf nvim
fi

# create temp dir 
mkdir nvim 

if [ ! -d "nvim" ];then 
	echo "couldent create folder, check permissions"
	exit 
fi 

# download nvim.zip 
curl -Lo "n.zip" "https://github.com/neovim/neovim/releases/download/v0.11.1/nvim-win64.zip"
unzip n.zip

if [ -d ~/AppData/Local/nvim ];then 
	rm -rf ~/AppData/Local/nvim 
fi 

mkdir ~/AppData/Local/nvim 
mv * ~/AppData/Local/nvim

if [ ! -d ~/AppData/Local/nvim ];then 
	mkdir ~/AppData/Local/wal
	touch ~/AppData/Local/wal/colors-wal.vim
fi 

# set a custom command :3
function nvim(){
  nvim="$HOME/AppData/Local/nvim/nvim-win64/bin/nvim.exe"
	if [ ! -e "$nvim" ];then 
		echo "ERROR: $nvim not found"
	else 
		"$nvim" $@
	fi
}

echo "Notes:"
echo "install a font from nerdfonts.com for icons to work correctly"
echo "all of the pywal themes will not work"
