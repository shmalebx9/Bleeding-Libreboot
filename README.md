# Bleeding Libreboot Roms

This repo has a few of the bleeding edge roms I use for various Thinkpads. All the included roms are set to the usqwerty layout with the standard grub payload.

The roms are the latest builds compiled from the libreboot [git repo.](https://notabug.org/libreboot/lbmk)
The roms are additionally patched with the standard grub unicode font and the old libreboot background.
Essentially, these roms appear like the stable libreboot release from 2016 but with the new features added since then including:

+ Corebootfb graphics
+ Support for quad core cpus
+ [fixed reboot bug](https://notabug.org/libreboot/lbmk/issues/11)
+ Secondary SeaBios payload

I also added the customizations present in my personal build with a different background and font. To make your own, simply edit the files in the *custom* folder and run `./patch custom.`

| Examples |
|:---------:|
| Libreboot testing release |
| ![old](old.jpg) |
| "Stock" |

# Instructions

To replicate these builds:

+ Follow the [lbmk instructions](https://libreboot.org/docs/build/)
+ Move the desired rom to the root of this git repo
+ Run patch.sh *stable/custom*

Make sure you have cbfstool installed to run the patch script.
Cbfstool is included under the util directory in any libreboot release.
