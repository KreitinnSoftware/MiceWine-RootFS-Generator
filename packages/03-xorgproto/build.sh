SRC_URL=https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2024.1.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE"
USE_NDK_VERSION=26b
CHECK_FOLDERS="$PREFIX/include/X11"
