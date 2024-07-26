SRC_URL=https://github.com/libffi/libffi/releases/download/v3.4.6/libffi-3.4.6.tar.gz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --disable-multi-os-directory"
RUN_POST_CONFIGURE="echo \"#define FFI_MMAP_EXEC_WRIT 1\" >> fficonfig.h"
