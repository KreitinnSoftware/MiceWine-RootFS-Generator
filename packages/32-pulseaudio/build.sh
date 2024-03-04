SRC_URL=https://github.com/pulseaudio/pulseaudio/archive/refs/tags/v17.0.zip
MESON_ARGS="--cross-file=../../../packages/32-pulseaudio/meson-cross-file-aarch64 -Dglib=disabled -Dgsettings=disabled -Dbashcompletiondir=$PREFIX/share/bash-completion -Dalsa=disabled -Dx11=disabled -Dgtk=disabled -Dopenssl=disabled -Dgsettings=disabled -Ddoxygen=false -Ddatabase=simple -Dtests=false"
USE_NDK_VERSION=25b
RUN_POST_APPLY_PATCH="cp include/libintl.h $PREFIX/include"
CFLAGS="-I$PREFIX/include"
LDFLAGS="-L$PREFIX/lib -Wl,--undefined-version"
LIBS="-L$PREFIX/lib"
