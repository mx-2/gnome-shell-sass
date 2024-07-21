# Good-Old-Shell

A Gnome shell theme which aims to bring back the look of the old
transparent-black and colorful icons default shell from earlier Gnome versions
to Gnome 46.

Note: To get colorful icons you have to install an icon theme which provides
full color shell icons as well.

## Installation
Extract the tgz into `~/.themes`. This should create the following path:
`~/.themes/good-old-shell/gnome-shell/gnome-shell.css`
Replace the file `overview-wallpaper.png` with a custom wallpaper for the
activities screen if you like.

Then open gnome-tweaks, enable the user-themes extension and select
Good-Old-Shell as shell theme.

## Building
The source code can be found at: `https://github.com/mx-2/gnome-shell-sass/tree/good-old-shell`
Run `make && make tar` to build a theme tarball or `make && make install`
to install it system wide from source.

## System-wide installation
To install Good-Old-Shell system-wide, extract the tarball into `/usr/share/themes/`,
use a package for your distribution or install it from source with `make install`.

### GDM Wallpaper
If Good-Old-Shell is installed system-wide, you can theme your GDM login screen
and use a custom wallpaper for it. Starting with Good-Old-Shell 46, a Gnome-Shell
extension is available in the `good-old-shell@mx-2` directory which loads the
theme into GDM.

To install the extension execute the following steps:

* Install Good-Old-Shell system-wide into `/usr/share/themes/good-old-shell`.
* Install the Gnome extension from the `extension/good-old-shell@mx-2` directory
  to `/usr/share/gnome-shell/extensions/good-old-shell@mx-2`.
* Copy the script `utils/install-gdm-ext.py` to `/tmp` set the correct permissions
  and execute it as `gdm` user:
  ```
  cp install-gdm-ext.py /tmp/
  chmod 755 /tmp/install-gdm-ext.py
  sudo -u gdm ./install-gdm-ext.py enable
  ```
* To uninstall, execute the script with the disable argument:
  ```
  cp install-gdm-ext.py /tmp/
  chmod 755 /tmp/install-gdm-ext.py
  sudo -u gdm ./install-gdm-ext.py disable
  ```

When the GDM theme is enabled, the file
`/usr/share/themes/good-old-shell/gnome-shell/gdm-wallpaper.png` is used as
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
