SRC_URL=https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.24.5.tar.xz
MESON_ARGS="--cross-file=../../../meson-cross-file-$ARCHITECTURE -Dintrospection=disabled -Dtests=disabled -Dexamples=disabled -Dpango=disabled "
MESON_ARGS+="-Dtools=disabled -Dglib-asserts=disabled -Dglib-checks=disabled"
LDFLAGS="-L$PREFIX/lib -landroid-shmem"
