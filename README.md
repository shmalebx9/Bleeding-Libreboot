# Bleeding Libreboot Roms

This repo has a few of the bleeding edge roms I use for various Thinkpads. All the included roms are set to the usqwerty layout with the standard grub payload.

The roms are the latest builds compiled from the libreboot [git repo.](https://notabug.org/libreboot/lbmk)
The roms are additionally patched with the standard grub unicode font and the old libreboot background.
Essentially, these roms appear like the stable libreboot release from 2016 but with the new features added since then including:

+ Corebootfb graphics
+ Support for quad core cpus
+ [fixed reboot bug](https://notabug.org/libreboot/lbmk/issues/11)
+ Fixed intel speedstep bug (needed for quad-core mod)
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
| **"Stock"** |
| ![stock](stock.jpg) |
| **Custom** |
| ![custom](custom.jpg) |

# Instructions

You'll need to set iomem=relaxed to internally flash.
You can easily set kernel parameters from grub, which generally only requires a simple reboot. On some librebooted machines, the grub payload will launch your operating system without ever prompting you with a kernel menu (generally the case with trisquel). Sometimes, you can prompt a menu list by hitting the shift key over and over during boot. You can edit kernel parameters from the initial libreboot-grub menu but it is complex. I recommend preparing a bootable usb with your favourite linux distro and editing the menu from there if you can’t get to your grub menu by rebooting.

Note: if you do boot from a usb to flash, you’ll need to follow this guide within your live environment. If you don’t want to do the entire thing in one sitting then you should set up persistent storage on your usb device.

When you get to your grub menu, you can edit the default menu entry by pressing ‘e.’ Use the arrow keys to navigate down to the line starting with ‘linux’ and add ‘iomem=relaxed’ to the end of the line.

If you want to flash one of these roms from a machine already running coreboot/libreboot/osboot, then internal flashing is the easiest route.
To flash internally, follow these steps:

1. Install flashrom from your distro's repos
2. Set iomem=relaxed 
3. Read current rom with `flashrom -p internal -r current.rom`
4. Check the size of your eeprom based on the size of the flash with `du -h current.rom`
5. Flash the rom of the corresponding size with `flashrom -p internal -w example_rom.rom`

If you get a list of flash chips when you try to use flashrom then just try all of the ones listed until one works.
Make sure to NEVER interrupt flashrom while it is writing.

To replicate these builds:

+ Follow the [lbmk instructions](https://libreboot.org/docs/build/)
+ Move the desired rom to the rom directory of this git repo
+ Run patch.sh *stable/custom*

Make sure you have cbfstool installed to run the patch script.
Cbfstool is included under the util directory in any libreboot release.

# Explanation 

Libreboot is open source firmware for hardware initialization.
Libreboot will only initialize hardware and then pass to a payload.
The default payload for libreboot is GRUB.
Linux does not require an actual bios, which is why linux systems can be booted directly from GRUB in libreboot without a more complex payload.
GRUB can also chainload other payloads, such as seabios and tianocore which provide the ability to boot operating systems as a normal bios.

The modifications made in this repo mainly edit the grub configuration on libreboot rom images using cbfstool.
You can see exactly which files are included in your rom image using cbfstool.
For example, to see the contents of the default images created with lbmk:

```
 > cbfstool t400_8mb_usqwerty.rom print

FMAP REGION: COREBOOT
Name                           Offset     Type           Size   Comp
cbfs master header             0x0        cbfs header        32 none
fallback/romstage              0x80       (unknown)       58136 none
fallback/ramstage              0xe440     (unknown)      110231 LZMA (242648 decompressed)
config                         0x29340    raw               476 none
revision                       0x29540    raw               711 none
build_info                     0x29840    raw               100 none
fallback/dsdt.aml              0x29900    raw             15108 none
vbt.bin                        0x2d440    raw              1412 LZMA (3863 decompressed)
cmos.default                   0x2da00    cmos_default      256 none
cmos_layout.bin                0x2db40    cmos_layout      1840 none
fallback/postcar               0x2e2c0    (unknown)       20744 none
seabios.elf                    0x33440    simple elf      61348 none
etc/ps2-keyboard-spinup        0x42440    raw                 8 none
etc/pci-optionrom-exec         0x42480    raw                 8 none
etc/optionroms-checksum        0x424c0    raw                 8 none
etc/only-load-option-roms      0x42500    raw                 8 none
vgaroms/seavgabios.bin         0x42540    raw             25600 none
fallback/payload               0x48980    simple elf     626548 none
grub.cfg                       0xe1940    raw              6627 none
grubtest.cfg                   0xe3380    raw              6615 none
(empty)                        0xe4d80    null          7364452 none
bootblock                      0x7ead00   bootblock       20640 none
```

The seabios.elf file is what grub loads when pressing <kbd>B</kbd> at the main menu.
To see the nuts and bolts, we can extract the grub configuration file from the rom to inspect it further with `cbfstool t400_8mb_usqwerty.rom extract -n grub.cfg -f grub.cfg`.
You can see how grub chainloads seabios by inspecting the extracted config.

```
> grep -A2 'seabios' grub.cfg

if [ -f (cbfsdisk)/seabios.elf ]; then
menuentry 'Load SeaBIOS (payload) [b]' --hotkey='b' {
    set root='cbfsdisk'
    chainloader /seabios.elf
}
fi
```

## Applying the Fixes

If you inspect the `grub.cfg` file from above you'll notice that it does not load any fonts, themes, or background images.
Since the rom isn't loading a font that can display the border box around text, these characters appear as '?' in the 20210522 testing release.
This issue can be fixed by adding a font to the rom image and telling grub to load it.
GRUB's default font can be found on most linux systems under `/boot/grub/fonts/unicode.pf2`
Add this font to the rom:

`cbfstool t400_8mb_usqwerty.rom add -f unicode.pf2 -n unicode.pf2 -t raw`

Then place `loadfont (cbfsdisk)/unicode.pf2` near the top of the grub config.
You can then remove the old grub config and replace it with the new one.

```
> cbfstool t400_8mb_usqwerty.rom remove -n grub.cfg
> cbfstool t400_8mb_usqwerty.rom add -f grub.cfg -n grub.cfg -t raw
```

## Creating a Theme

Grub itself supports some pretty extensive theming.
To create a grub theme, simply create `theme.txt` file and source it in the grub config `set theme=(cbfsdisk)/theme.txt`.
After creating your theme, add the theme file, grub.cfg, and all fonts and backgrounds to the rom file with cbfstool.

The theme file can set all kinds of options such as the size and position of the boot menu, optional text, and background image.
To get an idea of how to write a theme file, see the theme.txt file in this repo under the `custom` directory.

## Credits

Thanks to (vinceliuice)[https://github.com/vinceliuice/grub2-themes] for border images in modern theme.
