SRC_URL=https://github.com/facebook/zstd/archive/v1.5.6.tar.gz
USE_NDK_VERSION=26b
MESON_ARGS="--cross-file=../../../meson-cross-file-$ARCHITECTURE -Ddefault_library=both -Dbin_programs=true -Dbin_tests=false -Dbin_contrib=true -Dzlib=enabled -Dlzma=disabled -Dlz4=disabled"
