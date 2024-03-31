SRC_URL=https://mirrors.kernel.org/gnu/gmp/gmp-6.3.0.tar.xz
USE_NDK_VERSION=26b
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE"
LDFLAGS="-L$PREFIX_DIR/lib"
