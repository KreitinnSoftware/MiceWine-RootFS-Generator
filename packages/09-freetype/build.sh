PKG_VER=2.13.2
SRC_URL=https://downloads.sourceforge.net/freetype/freetype-$PKG_VER.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --without-bzip2 --without-harfbuzz"
