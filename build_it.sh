#!/bin/bash

cd $(dirname $0)
sassc -a gnome-shell.scss > gnome-shell.3.36.css
