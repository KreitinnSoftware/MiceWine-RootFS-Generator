PKG_VER=1.4
SRC_URL=https://github.com/xiph/opus/releases/download/v$PKG_VER/opus-$PKG_VER.tar.gz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --disable-extra-programs"
