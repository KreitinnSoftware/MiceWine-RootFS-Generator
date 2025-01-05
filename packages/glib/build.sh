PKG_VER=2.80.4
SRC_URL=https://download.gnome.org/sources/glib/${PKG_VER%.*}/glib-$PKG_VER.tar.xz
MESON_ARGS="-Dintrospection=disabled -Druntime_dir=$PREFIX/var/run -Dlibmount=disabled -Dman-pages=enabled -Dtests=false -Dselinux=disabled -Dlibelf=disabled"
CFLAGS="-I$PREFIX/include"
LDFLAGS="-L$PREFIX/lib -l:libiconv.a"
