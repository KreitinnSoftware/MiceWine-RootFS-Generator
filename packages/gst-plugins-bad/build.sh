PKG_VER=1.24.11
SRC_URL=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-$PKG_VER.tar.xz
MESON_ARGS="-Dandroidmedia=disabled -Dexamples=disabled -Drtmp=disabled -Dshm=disabled -Dtests=disabled -Dzbar=disabled -Dwebp=disabled -Dvulkan=disabled -Dhls-crypto=openssl"
LDFLAGS="-lm"
