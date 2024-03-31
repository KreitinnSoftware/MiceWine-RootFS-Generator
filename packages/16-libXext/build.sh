SRC_URL=https://xorg.freedesktop.org/releases/individual/lib/libXext-1.3.5.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --enable-malloc0returnsnull"
USE_NDK_VERSION=26b
