GIT_URL=https://gitlab.freedesktop.org/pulseaudio/pulseaudio.git
MESON_ARGS="--cross-file=../../../meson-cross-file-$ARCHITECTURE -Dalsa=disabled -Dx11=disabled -Dgtk=disabled -Dopenssl=disabled -Dgsettings=disabled -Ddoxygen=false -Ddatabase=simple -Dtests=false"
USE_NDK_VERSION=25b
RUN_POST_APPLY_PATCH="cp include/libintl.h $PREFIX/include"
CFLAGS="-I$PREFIX/include"
CPPFLAGS="-I$PREFIX/include"
LDFLAGS="-L$PREFIX/lib"
LIBS="-L$PREFIX/lib"
CHECK_FILES="$PREFIX/lib/libpulse.so"
