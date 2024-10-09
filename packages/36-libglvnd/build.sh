SRC_URL=https://gitlab.freedesktop.org/glvnd/libglvnd/-/archive/v1.7.0/libglvnd-v1.7.0.tar.gz
MESON_ARGS="--cross-file=../../../meson-cross-file-$ARCHITECTURE -Dtls=false"
CFLAGS="-I$PREFIX_DIR/include"
