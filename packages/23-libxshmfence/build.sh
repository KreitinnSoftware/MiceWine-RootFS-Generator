SRC_URL=https://xorg.freedesktop.org/releases/individual/lib/libxshmfence-1.3.2.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --disable-futex"
