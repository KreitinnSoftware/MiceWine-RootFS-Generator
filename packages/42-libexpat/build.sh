SRC_URL=https://github.com/libexpat/libexpat/releases/download/R_2_6_2/expat-2.6.2.tar.bz2
USE_NDK_VERSION=26b
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --without-xmlwf --without-docbook"
RUN_POST_APPLY_PATCH="sed -i 's/^\(linux\*android\)\*)/\1-non-micewine)/' configure"
