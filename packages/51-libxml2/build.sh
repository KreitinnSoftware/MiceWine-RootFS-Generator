SRC_URL=https://download.gnome.org/sources/libxml2/2.12/libxml2-2.12.6.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE  --without-python --without-lzma"
RUN_POST_APPLY_PATCH="sed -i 's/^\(linux\*android\)\*)/\1-notermux)/' configure"
CFLAGS="-fPIC"
