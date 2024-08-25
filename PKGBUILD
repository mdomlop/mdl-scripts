# Maintainer: Manuel Domínguez López <mdomlop at gmail>

pkgname=mdl-scripts
pkgver=0.4
pkgrel=1
pkgdesc='Useful scripts for mdl and maybe for you.'
arch=('any')
url="https://github.com/mdomlop/$pkgname"
source=()
license=('GPLv3+')


package() {
    cd $startdir
    #make install DESTDIR=$pkgdir PREFIX=/usr
    make install DESTDIR=$pkgdir
}
