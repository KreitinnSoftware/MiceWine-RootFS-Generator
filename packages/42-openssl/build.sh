PKG_VER=3.2.2
SRC_URL=https://github.com/openssl/openssl/releases/download/openssl-$PKG_VER/openssl-$PKG_VER.tar.gz
CFLAGS="-DNO_SYSLOG"

getOpenSSLArch()
{
	if [ "$ARCHITECTURE" == "aarch64" ]; then
		echo "arm64"
	elif [ "$ARCHITECTURE" == "x86_64" ]; then
		echo "x86_64"
	fi
}

OPENSSL_FLAGS="android-$(getOpenSSLArch) --openssldir=$PREFIX/etc/tls shared zlib-dynamic no-ssl no-hw no-srp no-tests enable-tls1_3"