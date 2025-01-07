PKG_VER=2.43
SRC_URL=https://xorg.freedesktop.org/archive/individual/data/xkeyboard-config/xkeyboard-config-$PKG_VER.tar.xz
MESON_ARGS="-Dxkb-base=$PREFIX/share/X11/xkb -Dcompat-rules=true -Dxorg-rules-symlinks=false"
