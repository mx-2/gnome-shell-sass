# Good-Old-Shell

A Gnome shell theme which aims to bring back the look of the old
transparent-black and colorful icons default shell from earlier Gnome versions
to Gnome 44.

Note: To get colorful icons you have to install an icon theme which provides
full color shell icons as well.

## Installation
Extract the tgz into ~/.themes. This should create the following path:
~/.themes/good-old-shell/gnome-shell/gnome-shell.css
Replace the file overview-wallpaper.png with a custom wallpaper for the activities screen if you like.

Then open gnome-tweaks, enable the user-themes extension and select
Good-Old-Shell as shell theme.

## Building
The source code can be found at: https://github.com/mx-2/gnome-shell-sass/tree/good-old-shell
Run `make && make tar` to build a theme tarball or `make && make install`
to install it system wide from source.

## System-wide installation
To install Good-Old-Shell system-wide, extract the tarball into "/usr/share/themes/",
use a package for your distribution or install it from source with `make install`.

### GDM Wallpaper
If Good-Old-Shell is installed system-wide, you can theme your GDM login screen
and use a custom wallpaper for it. Therefore, you have to install Good-Old-Shell
as default theme by replacing your system theme with Good-Old-Shell
(Ensure you have a backup first!).

Usually the system theme should be at:
/usr/share/gnome-shell/gnome-shell-theme.gresource.

The script build\_gresource.rb in the "utils" directory builds the required
gresource file from the current system gnome-shell-theme.gresource and embeds
Good-Old-Shell in it. To patch the global gresource add the `--install` flag.
The `--create-backup` flag can be used to create a backup of the existing
gresource. Make sure that you only give this flag on the first invocation,
otherwise the backup will be overridden by the already patched gresource file.

After patching the global gresource file, the file
"/usr/share/themes/good-old-shell/gnome-shell/gdm-wallpaper.png" is used as
wallpaper for the login screen. You can replace the provided default with any
PNG wallpaper you like. Just make sure that the wallpaper file is readable by
all users (mode 644) after modification.

### Special Icons
This is no longer necessary as of Gnome 44.

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

[shell-subtree]: https://gitlab.gnome.org/GNOME/gnome-shell/tree/HEAD/data/theme/gnome-shell-sass
[sass-repo]: https://gitlab.gnome.org/GNOME/gnome-shell-sass
[license]: COPYING
