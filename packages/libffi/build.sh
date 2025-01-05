PKG_VER=3.4.6
SRC_URL=https://github.com/libffi/libffi/releases/download/v$PKG_VER/libffi-$PKG_VER.tar.gz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --disable-multi-os-directory"
RUN_POST_CONFIGURE="echo \"#define FFI_MMAP_EXEC_WRIT 1\" >> fficonfig.h"
