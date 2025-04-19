PKG_VER=v17.0
SRC_URL=https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/archive/$PKG_VER/pulseaudio-$PKG_VER.tar.gz
MESON_ARGS="-Dalsa=disabled -Dx11=disabled -Dgtk=disabled -Dopenssl=disabled -Dgsettings=disabled -Ddoxygen=false -Ddatabase=simple -Dsystemd=disabled -Dudev=disabled -Dgstreamer=disabled -Dglib=disabled -Dman=false -Dbashcompletiondir=false -Dzshcompletiondir=false -Dtests=false"
CFLAGS="-I$PREFIX/include"
CPPFLAGS="-I$PREFIX/include"
LDFLAGS="-L$PREFIX/lib -Wl,--undefined-version -l:libintl.a"
