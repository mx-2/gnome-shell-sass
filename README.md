# Good-Old-Shell

A Gnome shell theme which aims to bring back the look of the old
transparent-black and colorful icons default shell from earlier Gnome versions
to Gnome 3.36.

Note: To get colorful icons you have to install an icon theme which provides
full color shell icons as well.

## Installation
Place the generated gnome-shell.3.36.css to
~/.themes/good-old-shell/gnome-shell/gnome-shell.css

Then open gnome-tweaks, enable the user-themes extension and select
Good-Old-shell as shell theme.

## GDM (advanced users)

You can embed Good-OlsShell together with a custom wallpaper into the GDM login
screen with the script embed\_gdm\_wp. This script will take the
gnome-shell-theme.gresource from the system and embeds Good-Old-Shell and your
wallpaper (default name gdm-wallpaper.svg.png) in it.
To install the result, replace your system wide default gnome-shell theme
with the generated gresource file (make sure you have a backup first!).

Usually the system theme should be at
/usr/share/gnome-shell/gnome-shell-theme.gresource.

Currently this does not to work on Ubuntu 20.04.

---
Original README below
---

# GNOME Shell Sass
GNOME Shell Sass is a project intended to allow the sharing of the
theme sources in sass between gnome-shell and other projects like
gnome-shell-extensions.

Any changes should be done in the [GNOME Shell subtree][shell-subtree]
and not the stand-alone [gnome-shell-sass repository][sass-repo]. They
will then be synchronized periodically before releases.

## License
GNOME Shell Sass is distributed under the terms of the GNU General Public
License, version 2 or later. See the [COPYING][license] file for details.

[shell-subtree]: https://gitlab.gnome.org/GNOME/gnome-shell/tree/master/data/theme/gnome-shell-sass
[sass-repo]: https://gitlab.gnome.org/GNOME/gnome-shell-sass
[license]: COPYING
