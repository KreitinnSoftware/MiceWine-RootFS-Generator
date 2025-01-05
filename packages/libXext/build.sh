PKG_VER=1.3.6
SRC_URL=https://xorg.freedesktop.org/releases/individual/lib/libXext-$PKG_VER.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --enable-malloc0returnsnull"
