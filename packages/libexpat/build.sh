PKG_VER=2.6.2
SRC_URL=https://github.com/libexpat/libexpat/releases/download/R_$(echo $PKG_VER | sed 's/\./_/g')/expat-$PKG_VER.tar.bz2
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --without-xmlwf --without-docbook"
RUN_POST_APPLY_PATCH="sed -i 's/^\(linux\*android\)\*)/\1-non-micewine)/' configure"
