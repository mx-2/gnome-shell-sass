ifeq ($(PREFIX),)
    PREFIX := /
endif

all: css png

clean:
	rm -rf release/
	rm -f overview-wallpaper.png
	rm -f login-dialog-frame.png
	rm -f good-old-shell.tar.gz

css:
	sassc -a gnome-shell.scss > gnome-shell.css

png:
	inkscape overview-wallpaper.svg -o overview-wallpaper.png
	inkscape login-dialog-frame.svg -o login-dialog-frame.png

tar:
	mkdir -p release/good-old-shell/gnome-shell
	install -m 644 gnome-shell.css release/good-old-shell/gnome-shell/
	install -m 644 overview-wallpaper.png release/good-old-shell/gnome-shell/
	install -m 644 login-dialog-frame.png release/good-old-shell/gnome-shell/
	install -m 644 overview-wallpaper.png release/good-old-shell/gnome-shell/gdm-wallpaper.png

	install -d release/good-old-shell/extension/
	install -d release/good-old-shell/extension/good-old-shell@mx-2/
	install -m 644 gdm-ext/extension.js release/good-old-shell/extension/good-old-shell@mx-2/
	install -m 644 gdm-ext/metadata.json release/good-old-shell/extension/good-old-shell@mx-2/
	install -m 644 README.md release/good-old-shell/README.md

	install -d release/good-old-shell/utils/
	install -m 755 install-gdm-ext.py release/good-old-shell/utils/

	( \
	    cd release && tar -c --owner=0 --group=0 \
	    --mtime="$$(date +%Y-%m-%d\ %H:%M:%S)" \
	    good-old-shell/ \
	    | gzip -9 > ../good-old-shell.tar.gz \
	)

install:
	( \
	    prefix="$(PREFIX)/usr/share/themes/good-old-shell"; \
	    install -d "$${prefix}"; \
	\
	    install -d "$${prefix}/gnome-shell"; \
	    install -m 644 gnome-shell.css "$${prefix}/gnome-shell"; \
	    install -m 644 overview-wallpaper.png "$${prefix}/gnome-shell/"; \
	    install -m 644 login-dialog-frame.png "$${prefix}/gnome-shell/"; \
	    install -m 644 overview-wallpaper.png "$${prefix}/gnome-shell/gdm-wallpaper.png"; \
	    install -m 644 README.md "$${prefix}/README.md"; \
	    install -d "$${prefix}/utils"; \
	    install -m 755 install-gdm-ext.py "$${prefix}/utils/"; \
	\
	    prefix="$(PREFIX)/usr/share/gnome-shell/extensions/good-old-shell@mx-2"; \
	    install -d "$${prefix}"; \
	    install -m 644 gdm-ext/extension.js "$${prefix}/"; \
	    install -m 644 gdm-ext/metadata.json "$${prefix}/"; \
	)
