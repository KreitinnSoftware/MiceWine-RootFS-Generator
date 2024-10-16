PKG_VER=1.3.5
SRC_URL=https://github.com/xiph/ogg/releases/download/v$PKG_VER/libogg-$PKG_VER.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE"
