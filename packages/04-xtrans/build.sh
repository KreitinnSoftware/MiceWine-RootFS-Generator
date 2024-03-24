SRC_URL=https://xorg.freedesktop.org/releases/individual/lib/xtrans-1.5.0.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE"
USE_NDK_VERSION=26b
CHECK_FOLDERS="$PREFIX/include/X11/Xtrans"
