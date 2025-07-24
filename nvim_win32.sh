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

rm -rf "~/AppData/Local/nvim"
mkdir "~/AppData/Local/nvim/"

mv * ~/AppData/Local/nvim
mkdir ~/AppData/Local/wal
touch ~/AppData/Local/wal/colors-wal.vim

# set a custom command :3
function nvim(){
  nvim_="~/AppData/Local/nvim/nvim-win64/bin/nvim.exe"
	if [ ! -d "$nvim_" ];then 
		echo "ERROR: $nvim_ not found"
	else 
		"$nvim_" $@
	fi
}

echo "Notes:"
echo "install a font from nerdfonts.com for icons to work correctly"
echo "all of the pywal themes will not work"
