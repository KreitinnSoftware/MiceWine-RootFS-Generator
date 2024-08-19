SRC_URL=https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.24.5.tar.xz
MESON_ARGS="--cross-file=../../../meson-cross-file-$ARCHITECTURE -Dcairo=disabled -Dexamples=disabled -Dgdk-pixbuf=disabled -Doss=disabled "
MESON_ARGS+="-Doss4=disabled -Dtests=disabled -Dv4l2=disabled -Daalib=disabled"
LDFLAGS="-L$PREFIX/lib -landroid-shmem"
