#!/bin/bash

./cbchange background.jpg
./cbchange grub.cfg
./cbchange unicode.pf2 || ( echo -e "\nFAILED: Make sure cbfstool is in your \$PATH \nYou can find cbfstool in the latest libreboot release under the 'util' directory\nDownload libreboot at https://rsync.libreboot.org/stable/20160907/rom/grub/" ; exit 1 )
