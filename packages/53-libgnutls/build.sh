SRC_URL=https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.3.tar.xz
USE_NDK_VERSION=26b
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --disable-hardware-acceleration --with-default-trust-store-file=$PREFIX_DIR/etc/tls/cert.pem --with-system-priority-file=$PREFIX_DIR/etc/gnutls/default-priorities --with-unbound-root-key-file=$PREFIX_DIR/etc/unbound/root.key  --with-included-libtasn1 --enable-local-libopts --without-p11-kit --disable-guile --disable-doc"
LDFLAGS="-L/data/data/com.micewine.emu/files/usr/lib"
CFLAGS="-I/data/data/com.micewine.emu/files/usr/include"