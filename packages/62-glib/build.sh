SRC_URL=https://download.gnome.org/sources/glib/2.80/glib-2.80.2.tar.xz
USE_NDK_VERSION=26b
MESON_ARGS="--cross-file=../../../meson-cross-file-$ARCHITECTURE -Dintrospection=enabled -Druntime_dir=$PREFIX/var/run -Dlibmount=disabled -Dman-pages=enabled -Dtests=false -Dxattr=false -Dnls=disabled"
RUN_POST_APPLY_PATCH="sed -i \"/Requires:/d\" \"$PREFIX/lib/pkgconfig/gobject-introspection-1.0.pc\""
CFLAGS="-D__BIONIC__=1"
