PKG_VER=1.8.9
SRC_URL=https://xorg.freedesktop.org/releases/individual/lib/libX11-$PKG_VER.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --enable-malloc0returnsnull"
