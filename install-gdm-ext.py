#!/usr/bin/env python3

import re
import subprocess
import sys

EXT_NAME = "'good-old-shell@mx-2'"


def print_usage():
    print("Usage: {} [enable|disable]".format(sys.argv[0]), file=sys.stderr)
    sys.exit(1)


def enable_extensions():
    result = subprocess.run([
            "dbus-launch",
            "gsettings",
            "set",
            "org.gnome.shell",
            "disable-user-extensions",
            "false",
        ],
        capture_output=True,
    )

    if result.returncode != 0:
        print("Enable extensions failed: {}".format(result.stderr))
        sys.exit(1)


def get_extensions() -> [str]:
    result = subprocess.run([
            "dbus-launch",
            "gsettings",
            "get",
            "org.gnome.shell",
            "enabled-extensions"
        ],
        capture_output=True,
    )

    if result.returncode != 0:
        print("Get extensions failed: {}".format(result.stderr))
        sys.exit(1)

    output = result.stdout.decode().strip()
    if output.startswith("@as"):
        return []

    return re.split(r', (?=")', re.sub(r'\[|\]', "", output))


def set_extensions(extensions: [str]):
    encoded = "[{}]".format(", ".join(extensions))
    result = subprocess.run([
            "dbus-launch",
            "gsettings",
            "set",
            "org.gnome.shell",
            "enabled-extensions",
            encoded,
        ],
        capture_output=True,
    )

    if result.returncode != 0:
        print("Set extensions failed: {}".format(result.stderr))
        sys.exit(1)


if len(sys.argv) != 2:
    print_usage()

if sys.argv[1] == "enable":
    ENABLE = True
elif sys.argv[1] == "disable":
    ENABLE = False
else:
    print_usage()

extensions = get_extensions()
if ENABLE:
    if EXT_NAME in extensions:
        print("Good-Old-Shell is already enabled.")
        sys.exit(0)
    extensions.append(EXT_NAME)
else:
    if EXT_NAME not in extensions:
        print("Good-Old-Shell is already disabled.")
        sys.exit(0)
    extensions.remove(EXT_NAME)

enable_extensions()
set_extensions(extensions)
