PKG_VER=1
GIT_URL=https://github.com/KreitinnSoftware/icoutils
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE"
CFLAGS="-I$PREFIX/include"
LDFLAGS="-L$PREFIX/lib -lpng16"
