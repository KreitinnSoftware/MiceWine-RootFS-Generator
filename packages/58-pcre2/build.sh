PKG_VER=10.44
SRC_URL=https://github.com/PhilipHazel/pcre2/releases/download/pcre2-$PKG_VER/pcre2-$PKG_VER.tar.bz2
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --enable-jit --enable-pcre2-16 --enable-pcre2-32"
