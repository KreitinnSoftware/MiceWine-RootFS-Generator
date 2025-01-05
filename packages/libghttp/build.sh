PKG_VER=1.61.0
SRC_URL=https://github.com/nghttp2/nghttp2/releases/download/v$PKG_VER/nghttp2-$PKG_VER.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --enable-lib-only"
