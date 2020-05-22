#!/bin/sh -e

cd $(dirname $0)
GNOME_VERSION=$(gnome-shell --version | grep -o '[0-9]*\.[0-9]\+')

sassc -a gnome-shell.scss > gnome-shell.${GNOME_VERSION}.css

if [[ $1 == "-i" ]]; then
  sudo cp "gnome-shell.${GNOME_VERSION}.css" \
    "/opt/gdm-wallpaper/gnome-shell.${GNOME_VERSION}.css" && \
  sudo /opt/gdm-wallpaper/build_gresource.rb --replace-sys --hidpi 2
fi
