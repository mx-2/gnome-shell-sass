pkgname=good-old-shell-theme
pkgver=42.0
pkgrel=2
pkgdesc="A Gnome shell theme based on earlier gnome versions with colorful icons."
arch=(any)
options=(!emptydirs)
url=""
branch=good-old-shell-42
source=("git+https://github.com/mx-2/gnome-shell-sass.git#branch=$branch")
sha256sums=("SKIP")

build() {
    cd "${srcdir}/gnome-shell-sass"
    make
}

package() {
    PREFIX=${pkgdir} make install
}
