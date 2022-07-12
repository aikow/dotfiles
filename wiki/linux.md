# Linux

## Problems

### Invert Mouse and Trackpad Scroll Direction

Edit `/usr/share/X11/xorg.conf.d/40-libinput.conf` and set `Option "NaturalScrolling" "True"`

For the mouse
```sh
# Match on all types of devices but joysticks
Section "InputClass"
        Identifier "libinput pointer catchall"
        MatchIsPointer "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "NaturalScrolling" "True"
EndSection
```

For the touchpad
```sh
Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "NaturalScrolling" "True"
EndSection
```

