SRC_URL=https://www.openssl.org/source/openssl-3.2.1.tar.gz
USE_NDK_VERSION=26b
CFLAGS="-DNO_SYSLOG"
OPENSSL_FLAGS="--openssldir=$PREFIX_DIR/etc/tls shared zlib-dynamic no-ssl no-hw no-srp no-tests enable-tls1_3"