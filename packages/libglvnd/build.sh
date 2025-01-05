PKG_VER=1.7.0
SRC_URL=https://gitlab.freedesktop.org/glvnd/libglvnd/-/archive/v$PKG_VER/libglvnd-v$PKG_VER.tar.gz
MESON_ARGS="-Dtls=false"
CFLAGS="-I$PREFIX_DIR/include"
