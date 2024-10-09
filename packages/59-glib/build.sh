SRC_URL=https://download.gnome.org/sources/glib/2.80/glib-2.80.4.tar.xz
MESON_ARGS="--cross-file=../../../meson-cross-file-$ARCHITECTURE -Dintrospection=disabled -Druntime_dir=$PREFIX/var/run -Dlibmount=disabled -Dman-pages=enabled -Dtests=false -Dselinux=disabled -Dlibelf=disabled"
CFLAGS="-I$PREFIX/include"
LDFLAGS="-L$PREFIX/lib -l:libiconv.a"
