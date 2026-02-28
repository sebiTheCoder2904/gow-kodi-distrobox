#!/bin/bash -e

source /opt/gow/bash-lib/utils.sh

ARCH_CONTAINER="arch-wolf"

export DESKTOP_SESSION=sway
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_TYPE="wayland"
export XDG_DATA_HOME="$HOME/.local/share"
export _JAVA_AWT_WM_NONREPARENTING=1
export GDK_BACKEND=wayland
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_ENABLE_HIGHDPI_SCALING=1
export DISPLAY=:0
export $(dbus-launch)
export REAL_WAYLAND_DISPLAY=$WAYLAND_DISPLAY

sudo /opt/gow/startdbus.sh

if [ ! -d "$HOME/Downloads" ]; then
    # Create commun folders
    mkdir ~/Desktop ~/Documents ~/Downloads ~/Music ~/Pictures ~/Public ~/Templates ~/Videos
    chmod 755 ~/Desktop ~/Documents ~/Downloads ~/Music ~/Pictures ~/Public ~/Templates ~/Videos
  fi


if ! distrobox list | grep -q "$ARCH_CONTAINER"; then
    echo "Creating persistent Arch environment..."
    # --image: Use Arch Linux
    # --home: Ensure it uses the persistent home
    # --pull: Always get latest arch
    distrobox create --name "$ARCH_CONTAINER" \
                     --image archlinux:latest \
                     --home /home/retro \
                     --yes \
                     --absolutely-disable-root-password-i-am-really-positively-sure

    distrobox enter "$ARCH_CONTAINER" -- sudo pacman -Syu --noconfirm kodi kodi-addon-peripheral-joystick
  fi

source /opt/gow/distrobox-kodi-launcher.sh
launcher
