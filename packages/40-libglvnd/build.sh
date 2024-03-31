SRC_URL=https://gitlab.freedesktop.org/glvnd/libglvnd/-/archive/v1.7.0/libglvnd-v1.7.0.tar.gz
USE_NDK_VERSION=26b
CONFIGURE_ARGS="--disable-tls --host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE"
CFLAGS="-I$PREFIX_DIR/include"
