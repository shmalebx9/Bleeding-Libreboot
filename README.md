# Bleeding Libreboot Roms

This repo has a few of the bleeding edge roms I use for various Thinkpads. All the included roms are set to the usqwerty layout with the standard grub payload.

The roms are the latest builds compiled from the libreboot [git repo.](https://notabug.org/libreboot/lbmk)
The roms are additionally patched with the standard grub unicode font and the old libreboot background.
Essentially, these roms appear like the stable libreboot release from 2016 but with the new features added since then including:

+ Corebootfb graphics
+ Support for quad core cpus
+ [fixed reboot bug](https://notabug.org/libreboot/lbmk/issues/11)
+ Secondary SeaBios payload

To make your own, simply edit the files in the *custom* folder and run `./patch custom.`
By default the custom roms have:

+ Different font
+ Different background
+ Menu on the side
+ Ascii art
+ Beeps disabled

| **Examples** |
|:---------:|
| Libreboot testing release |
| ![old](old.jpg) |
| **"Stock"** |
| ![stock](stock.jpg) |
| **Custom** |
| ![custom](custom.jpg) |

# Instructions

To simply install, download one of the archives from the releases page.
Extract and flash the correct rom for your machine using flashrom.

If you have trouble with internal flashing add `iomem=relaxed` to your kernel's cmdline.

To replicate these builds:

+ Follow the [lbmk instructions](https://libreboot.org/docs/build/)
+ Move the desired rom to the rom directory of this git repo
+ Run patch.sh *stable/custom*

Make sure you have cbfstool installed to run the patch script.
Cbfstool is included under the util directory in any libreboot release.
