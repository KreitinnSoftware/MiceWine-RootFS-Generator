PKG_VER=1.17
SRC_URL=https://ftp.gnu.org/pub/gnu/libiconv/libiconv-$PKG_VER.tar.gz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --enable-extra-encodings --enable-static --enable-shared"
