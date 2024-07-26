SRC_URL=https://mirrors.kernel.org/gnu/gmp/gmp-6.3.0.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE"
LDFLAGS="-L$PREFIX/lib"
