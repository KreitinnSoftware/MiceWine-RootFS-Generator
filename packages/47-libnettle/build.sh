SRC_URL=https://mirrors.kernel.org/gnu/nettle/nettle-3.9.1.tar.gz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE"
LDFLAGS="-L$PREFIX/lib"
CFLAGS=-I$PREFIX/include
