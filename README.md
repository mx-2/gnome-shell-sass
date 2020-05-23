# Good-Old-Shell

A Gnome shell theme which aims to bring back the look of the old
transparent-black and colorful icons default shell from earlier Gnome versions
to Gnome 40.

Note: To get colorful icons you have to install an icon theme which provides
full color shell icons as well.

## Installation
Copy the file overview-wallpaper.svg to
~/.themes/good-old-shell/gnome-shell/overview-wallpaper.svg
Replace it with a custom wallpaper if you like.
Copy the generated file gnome-shell.40.0.css to
~/.themes/good-old-shell/gnome-shell/gnome-shell.css

Then open gnome-tweaks, enable the user-themes extension and select
Good-Old-shell as shell theme.

## GDM (advanced users)

With Good-Old-Shell, you can theme your GDM login screen and use a custom
wallpaper for it. Therefore, you have to install Good-Old-Shell globally by
replacing your system theme with Good-Old-Shell
(Ensure you have a backup first! Currently, this does not work on Ubuntu 20.04.)

Usually the system theme should be at:
/usr/share/gnome-shell/gnome-shell-theme.gresource.

The script build\_gresource builds the required gresource file from the
current system gnome-shell-theme.gresource and embeds Good-Old-Shell in it.
The size of the given wallpaper file is used as screen resolution.
By default, the wallpaper is loaded from:
/opt/gdm-wallpaper/wallpaper.png

You can use the provided gdm-wallpaper.svg to render some "shadow" on top of
your wallpaper to improve readability of gdm's controls.

Furthermore, you can use the build\_gresource script to embed custom, otherwise
non-themable, icons for "no-notifications" and "no-events" in the gresource
file. To do so, create and folder called "icons" next to the script and place
your icons in it.

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
