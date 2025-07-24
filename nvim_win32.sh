#!/bin/bash 

# run this inside of git bash

cd

# check that git and unzip are installed 
if [ ! -v "git" ];then
	echo "ERROR: missing git"
	exit 
fi 

if [ ! -v "unzip" ];then 
	echo "ERROR: missing unzip"
	exit 
fi 

if [ ! -v "mkdir" ];then 
	echo "ERROR: missing mkdir"
	exit 
fi 

if [ ! -v "touch" ];then 
	echo "ERROR: missing touch"
	exit
fi 

if [ ! -v "rm" ];then 
	echo "ERROR: missing rm"
	exit 
fi 


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
curl -Lo "nvim/nvim.zip" "https://github.com/neovim/neovim/releases/download/v0.11.1/nvim-win64.zip"
unzip -d "nvim nvim/nvim.zip"

rm -rf "AppData/Local/nvim"
mv * AppData/Local/
mkdir AppData/Local/wal
touch AppData/Local/wal/colors-wal.vim

# set a custom command :3
function nvim(){
  nvim_="~/nvim/nvim-win64/bin/nvim.exe"
	if [ ! -d "$nvim_" ];then 
		echo "ERROR: $nvim_ not found"
	else 
		"$nvim_" $@
	fi
}

function update_nvim(){
	cd
	git clone https://github.com/9jh1/nvim 
	cd nvim 
	source nvim_win32.sh
}

echo "Notes:"
echo "install a font from nerdfonts.com for icons to work correctly"
echo "all of the pywal themes will not work"

