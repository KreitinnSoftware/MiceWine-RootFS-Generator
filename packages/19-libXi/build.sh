SRC_URL=https://xorg.freedesktop.org/releases/individual/lib/libXi-1.8.1.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --enable-malloc0returnsnull"