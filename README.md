# ArchBasics
Some configuration files and the like that I tend to use

[Locale](#locale)  
[Video settings](#video-settings-xorg-and-lightdm)

# Locale

Fixes incorrect display of ncspot.

Edit ```/etc/locale.gen``` and uncomment ```en_US-8``` (and other needed locales).
Generate locales by running:
```
# Locale-gen
```
Create locale.conf and set language

```/etc/locale.conf ```
```
LANG=en_US.UTF-8
```
# Video settings Xorg and Lightdm

Xorg sees VR-headset as second monitor, making certain windows out of focus. Xmonad will not work.

Copy [displaysettings.sh](settings/displaysettings.sh) to ```~/```

```/etc/lightdm/lightdm.conf```
Under header ```[Seat:*]``` search for:
```
#display-setup-script=
```
And change into:
```
display-setup-script=/home/USERNAME/displaysettings.sh
```
