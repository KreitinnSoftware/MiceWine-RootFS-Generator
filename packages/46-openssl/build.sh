SRC_URL=https://www.openssl.org/source/openssl-3.2.1.tar.gz
USE_NDK_VERSION=26b
CFLAGS="-DNO_SYSLOG"
OPENSSL_FLAGS="android-$(if [ "$ARCHITECTURE" == "aarch64" ]; then echo "arm64"; elif [ "$ARCHITECTURE" == "x86_64" ]; then echo "x86_64"; fi) --openssldir=$PREFIX_DIR/etc/tls shared zlib-dynamic no-ssl no-hw no-srp no-tests enable-tls1_3"