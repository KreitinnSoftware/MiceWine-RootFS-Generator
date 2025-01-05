PKG_VER=1.5.6
SRC_URL=https://github.com/facebook/zstd/archive/v$PKG_VER.tar.gz
MESON_ARGS="-Ddefault_library=both -Dbin_programs=true -Dbin_tests=false -Dbin_contrib=true -Dzlib=enabled -Dlzma=disabled -Dlz4=disabled"
