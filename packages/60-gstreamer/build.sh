PKG_VER=1.24.5
SRC_URL=https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-$PKG_VER.tar.xz
MESON_ARGS="--cross-file=../../../meson-cross-file-$ARCHITECTURE -Dintrospection=disabled -Dcheck=disabled -Dtests=disabled -Dexamples=disabled "
MESON_ARGS+="-Dbenchmarks=disabled -Dlibunwind=disabled -Dlibdw=disabled -Dnls=disabled"
CFLAGS="-I$PREFIX/include"
LDFLAGS="-L$PREFIX/lib"
