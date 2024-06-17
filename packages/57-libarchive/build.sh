SRC_URL=https://github.com/libarchive/libarchive/releases/download/v3.7.4/libarchive-3.7.4.tar.gz
USE_NDK_VERSION=26b
CMAKE_ARGS="-DENABLE_BZip2=OFF -DENABLE_LZ4=OFF -DENABLE_LIBB2=OFF -DENABLE_ICONV=OFF -DENABLE_ZSTD=OFF -DENABLE_NETTLE=OFF -DENABLE_ACL=OFF -DENABLE_XATTR=OFF -DENABLE_LZMA=OFF"
RUN_POST_APPLY_PATCH="rm -f configure"
RUN_POST_BUILD="sed -i '/^Requires\.private:/s/ iconv//' $PREFIX_DIR/lib/pkgconfig/libarchive.pc"
LDFLAGS="-L/data/data/com.micewine.emu/files/usr/lib
"
