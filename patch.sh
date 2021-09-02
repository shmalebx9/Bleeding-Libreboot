#!/bin/bash

Cbchange(){
for rom in *.rom ; do
	echo "adding $1 to $rom"
	cbfstool $rom remove $1 -n $1 2> /dev/null
	cbfstool $rom add -f $1 -n $1 -t raw
done
}

dir=$PWD
type=$1
cd $type

Cbchange background.*
Cbchange grub.cfg
Cbchange theme.txt 2>/dev/null
Cbchange font.pf2 || ( echo -e "\nFAILED: Make sure cbfstool is in your \$PATH \nYou can find cbfstool in the latest libreboot release under the 'util' directory\nDownload libreboot at https://rsync.libreboot.org/stable/20160907/rom/grub/" ; exit 1 )

cd $dir
