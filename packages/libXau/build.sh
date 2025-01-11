PKG_VER=1.0.12
SRC_URL=https://xorg.freedesktop.org/releases/individual/lib/libXau-$PKG_VER.tar.gz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --disable-static"
