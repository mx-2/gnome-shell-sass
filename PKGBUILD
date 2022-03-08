pkgname=good-old-shell-theme
pkgver=42.0
pkgrel=1
pkgdesc="A Gnome shell theme based on earlier gnome versions with colorful icons."
arch=(any)
options=(!emptydirs)
url=""
commit=b65f0e7c8879bbe128ba968e97d64dd058dea7fb
source=("git+https://github.com/mx-2/gnome-shell-sass.git#commit=$commit")
sha256sums=("SKIP")

build() {
    cd "${srcdir}/gnome-shell-sass"
    make
}

package() {
    PREFIX=${pkgdir} make install
}
