SRC_URL=https://mirrors.kernel.org/gnu/libtool/libtool-2.4.7.tar.gz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE"
USE_NDK_VERSION=26b
CHECK_FOLDERS="$PREFIX/share/libtool"
