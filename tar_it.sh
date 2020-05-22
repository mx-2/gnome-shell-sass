#!/bin/bash

cd "$(dirname $0)/release"

tar -cf ../good-old-shell.tar --owner=0 --group=0 \
    --mtime="$(date +%Y-%m-%d\ %H:%M:%S)" \
    *
