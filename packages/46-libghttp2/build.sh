SRC_URL=https://github.com/nghttp2/nghttp2/releases/download/v1.60.0/nghttp2-1.60.0.tar.xz
USE_NDK_VERSION=26b
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --enable-lib-only"
