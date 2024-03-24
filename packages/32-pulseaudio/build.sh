SRC_URL=https://github.com/pulseaudio/pulseaudio/archive/refs/tags/v17.0.zip
MESON_ARGS="--cross-file=../../../meson-cross-file-$ARCHITECTURE -Dsoxr=disabled -Dorc=disabled -Davahi=disabled -Ddbus=disabled -Dgstreamer=disabled -Dglib=disabled -Dgsettings=disabled -Dbashcompletiondir=/data/data/com.micewine.emu/files/usr/share/bash-completion -Dalsa=disabled -Dx11=disabled -Dgtk=disabled -Dopenssl=disabled -Dgsettings=disabled -Ddoxygen=false -Ddatabase=simple -Dtests=false -Dsystemd=disabled -Dbluez5=disabled -Dasyncns=disabled"
USE_NDK_VERSION=25b
RUN_POST_APPLY_PATCH="cp include/libintl.h $PREFIX/include"
CFLAGS="-I$PREFIX/include"
CPPFLAGS="-I$PREFIX/include"
LDFLAGS="-L$PREFIX/lib"
LIBS="-L$PREFIX/lib"
CHECK_FILES="$PREFIX/lib/libpulse.so"
