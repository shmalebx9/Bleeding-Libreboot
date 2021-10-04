#!/bin/bash

Cbchange(){
for rom in *.rom ; do
	echo "adding $1 to $rom"
	cbfstool $rom remove -n $1
 cbfstool $rom add -f $1 -n $1 -t raw || echo "error, could not add $1 to $rom"

done
}

dir=$PWD
type=$1
cp roms/* "$type"
cd "$type"

Cbchange background.*
Cbchange grub.cfg
Cbchange theme.txt
Cbchange font.pf2

if [ "$type" = "custom" ] ; then
 for rom in *.rom ; do
 echo "disabling beeps in $rom"
 nvramtool -C $rom -w power\_management\_beeps=Disable 
 nvramtool -C $rom -w low\_battery\_beep=Disable
done
fi

mv *.rom "$dir/bin"

cd "$dir"
