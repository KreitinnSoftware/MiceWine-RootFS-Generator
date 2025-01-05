PKG_VER=1.3.2
SRC_URL=https://xorg.freedesktop.org/releases/individual/lib/libxshmfence-$PKG_VER.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --disable-futex"
