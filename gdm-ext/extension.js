/* extension.js
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';
import Gio from 'gi://Gio';
import GLib from 'gi://GLib';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

export default class PlainExampleExtension extends Extension {
    enable() {
        let local_theme = GLib.get_home_dir() +
            "/.themes/good-old-shell/gnome-shell/gnome-shell.css";
        let local_file = Gio.file_new_for_path(local_theme);

        if (local_file.query_exists(null)) {
            Main.setThemeStylesheet(local_theme);
        } else {
            Main.setThemeStylesheet(
                "/usr/share/themes/good-old-shell/gnome-shell/gnome-shell.css"
            );
        }
        Main.loadTheme();
    }

    disable() {
        Main.setThemeStylesheet(null);
        Main.loadTheme();
    }
}
