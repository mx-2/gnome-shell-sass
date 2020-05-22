ifeq ($(PREFIX),)
    PREFIX := /
endif

all: css png

clean:
	rm -rf release/
	rm -f overview-wallpaper.png
	rm -f login-dialog-frame.png
	rm -f gnome-shell-theme.gresource
	rm -f good-old-shell.tar.gz

css:
	sassc -a gnome-shell.scss > gnome-shell.css

png:
	inkscape overview-wallpaper.svg -o overview-wallpaper.png
	inkscape login-dialog-frame.svg -o login-dialog-frame.png

gresource:
	./build_gresource.rb

tar:
	install -d release/good-old-shell/gnome-shell/icons/
	install -m 644 gnome-shell.css release/good-old-shell/gnome-shell/
	install -m 644 overview-wallpaper.png release/good-old-shell/gnome-shell/
	install -m 644 login-dialog-frame.png release/good-old-shell/gnome-shell/
	install -m 644 overview-wallpaper.png release/good-old-shell/gnome-shell/gdm-wallpaper.png

	install -d release/good-old-shell/utils/
	install -m 755 build_gresource.rb "release/good-old-shell/utils";
	install -m 644 good-old-shell.hook "release/good-old-shell/utils";
	install -m 644 README.md release/good-old-shell/README.md

	( \
	    cd release && tar -c --owner=0 --group=0 \
	    --mtime="$$(date +%Y-%m-%d\ %H:%M:%S)" \
	    good-old-shell/ \
	    | gzip -9 > ../good-old-shell.tar.gz \
	)

install:
	( \
	    prefix="$(PREFIX)/usr/share/themes/good-old-shell"; \
	    mkdir -p "$${prefix}"; \
	\
	    install -d "$${prefix}/gnome-shell"; \
	    install -d "$${prefix}/gnome-shell/icons/"; \
	    touch "$${prefix}/gnome-shell/icons/.keep"; \
	    chmod 644 "$${prefix}/gnome-shell/icons/.keep"; \
	\
	    install -m 644 gnome-shell.css "$${prefix}/gnome-shell"; \
	    install -m 644 overview-wallpaper.png "$${prefix}/gnome-shell/"; \
	    install -m 644 login-dialog-frame.png "$${prefix}/gnome-shell/"; \
	    install -m 644 overview-wallpaper.png "$${prefix}/gnome-shell/gdm-wallpaper.png"; \
	\
	    install -d "$${prefix}/utils"; \
	    install -m 755 build_gresource.rb "$${prefix}/utils"; \
	    install -m 644 good-old-shell.hook "$${prefix}/utils"; \
	    install -m 644 README.md "$${prefix}/README.md"; \
	)
