GIT_URL=https://github.com/KreitinnSoftware/icoutils
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE"
USE_NDK_VERSION=26b
LDFLAGS="-L$PREFIX/lib -lpng16"
