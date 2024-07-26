SRC_URL=https://xorg.freedesktop.org/releases/individual/lib/libXxf86vm-1.1.5.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --enable-malloc0returnsnull"
