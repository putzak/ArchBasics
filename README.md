# ArchBasics
Some configuration files and the like that I tend to use

[Locale](#locale)  
[Video settings](#video-settings-xorg-and-lightdm)  
[Audio settings](#audio-settings)  
[Network settings](#network-settings)

# Locale

Fixes incorrect display of [ncspot](https://github.com/hrkfdn/ncspot).

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

Copy [displaysettings.sh](displaysettings.sh) to ```~/```

```/etc/lightdm/lightdm.conf```
Under header ```[Seat:*]``` search for:
```
#display-setup-script=
```
And change into:
```
display-setup-script=/home/USERNAME/displaysettings.sh
```

# Audio settings

Boost your audio quality with ```pulseaudio```
Edit ```/etc/pulse/daemon.conf```, search for:
```
; default-sample-rate = 4XXXX
```
And change it into
```
; default-sample-rate = 48000
```
Copy your modified ```/etc/pulse/daemon.conf``` into ```~/.config.pulse/```

# Network settings

When using ```iwd``` together with ```NetworkManager``` one has to configure ```/etc/NetworkManager/NetworkManager.conf```.
Add these lines:
```
[device]
wifi.backend=iwd
