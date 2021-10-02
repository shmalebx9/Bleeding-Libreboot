#!/bin/bash

Cbchange(){
for rom in bin/*.rom ; do
	echo "adding $1 to $rom"
	cbfstool $rom remove $1 -n $1 2> /dev/null
	cbfstool $rom add -f $1 -n $1 -t raw

done
}

dir=$PWD
type=$1
cp roms/*.rom bin/

for file in "$type/"* ; do
 Cbchange $file 
done
