PKG_VER=1.5.4
SRC_URL=https://xorg.freedesktop.org/releases/individual/lib/libXrandr-$PKG_VER.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --enable-malloc0returnsnull"
