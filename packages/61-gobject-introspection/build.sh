SRC_URL=https://download.gnome.org/sources/gobject-introspection/1.80/gobject-introspection-1.80.1.tar.xz
USE_NDK_VERSION=26b
MESON_ARGS="--cross-file=../../../meson-cross-file-$ARCHITECTURE -Dcairo_libname=libcairo-gobject.so -Dbuild_introspection_data=false"
RUN_POST_BUILD="sed -i \"/Requires:/d\" \"$PREFIX/lib/pkgconfig/gobject-introspection-1.0.pc\""
