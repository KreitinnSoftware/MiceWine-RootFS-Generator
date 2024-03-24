SRC_URL=https://download.sourceforge.net/libpng/libpng-1.6.43.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE"
USE_NDK_VERSION=26b
CHECK_FILES="$PREFIX/lib/libpng16.so"
