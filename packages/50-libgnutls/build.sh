PKG_VER=3.8.5
SRC_URL=https://www.gnupg.org/ftp/gcrypt/gnutls/v${PKG_VER%.*}/gnutls-$PKG_VER.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --disable-hardware-acceleration --with-default-trust-store-file=$PREFIX_DIR/etc/tls/cert.pem --with-system-priority-file=$PREFIX_DIR/etc/gnutls/default-priorities --with-unbound-root-key-file=$PREFIX_DIR/etc/unbound/root.key  --with-included-libtasn1 --enable-local-libopts --without-p11-kit --disable-guile --disable-doc --without-zstd"
LDFLAGS="-L$PREFIX/lib"
CFLAGS="-I$PREFIX/include"
