PKG_VER=3.7.7
SRC_URL=https://github.com/libarchive/libarchive/releases/download/v$PKG_VER/libarchive-$PKG_VER.tar.gz
CMAKE_ARGS="-DENABLE_BZip2=OFF -DENABLE_LZ4=OFF -DENABLE_LIBB2=OFF -DENABLE_ICONV=OFF -DENABLE_ZSTD=OFF -DENABLE_NETTLE=OFF -DENABLE_ACL=OFF -DENABLE_XATTR=OFF -DENABLE_LZMA=OFF -DENABLE_ZLIB=OFF"
RUN_POST_BUILD="sed -i '/^Requires\.private:/s/ iconv//' $PREFIX/lib/pkgconfig/libarchive.pc"
LDFLAGS="-L$PREFIX/lib -lz"
DEPENDENCIES="zlib zstd openssl libxml2"
