pkgname=good-old-shell-theme
pkgver=45.1
pkgrel=1
pkgdesc="A Gnome shell theme based on earlier gnome versions with colorful icons."
arch=(any)
options=(!emptydirs)
url=""
branch=good-old-shell-45
source=("git+https://github.com/mx-2/gnome-shell-sass.git#branch=$branch")
sha256sums=("SKIP")

build() {
    cd "${srcdir}/gnome-shell-sass"
    make
}

package() {
    cd "${srcdir}/gnome-shell-sass"
    PREFIX=${pkgdir} make install
}
