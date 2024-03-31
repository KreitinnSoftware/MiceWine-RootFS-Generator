SRC_URL=https://download.gnome.org/sources/libxml2/2.12/libxml2-2.12.6.tar.xz
USE_NDK_VERSION=26b
RUN_POST_APPLY_PATCH="sed -i 's/^\(linux\*android\)\*)/\1-notermux)/' configure"
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE  --without-python"
CFLAGS="-fPIC"
