SRC_URL=https://github.com/openssl/openssl/releases/download/openssl-3.2.2/openssl-3.2.2.tar.gz
CFLAGS="-DNO_SYSLOG"

getOpenSSLArch()
{
	if [ "$ARCHITECTURE" == "aarch64" ]; then
		echo "arm64"
	elif [ "$ARCHITECTURE" == "x86_64" ]; then
		echo "x86_64"
	fi
}

OPENSSL_FLAGS="android-$(getOpenSSLArch) --openssldir=$PREFIX_DIR/etc/tls shared zlib-dynamic no-ssl no-hw no-srp no-tests enable-tls1_3"