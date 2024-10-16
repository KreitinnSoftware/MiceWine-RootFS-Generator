PKG_VER=[gss]
GIT_URL=https://gitlab.freedesktop.org/pulseaudio/pulseaudio.git
MESON_ARGS="--cross-file=$INIT_DIR/meson-cross-file-$ARCHITECTURE -Dalsa=disabled -Dx11=disabled -Dgtk=disabled -Dopenssl=disabled -Dgsettings=disabled -Ddoxygen=false -Ddatabase=simple -Dsystemd=disabled -Dudev=disabled -Dgstreamer=disabled -Dglib=disabled -Dman=false -Dbashcompletiondir=false -Dzshcompletiondir=false -Dtests=false"
RUN_POST_APPLY_PATCH="cp include/libintl.h $PREFIX/include"
CFLAGS="-I$PREFIX/include"
CPPFLAGS="-I$PREFIX/include"
LDFLAGS="-L$PREFIX/lib -Wl,--undefined-version"
