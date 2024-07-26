SRC_URL=https://xorg.freedesktop.org/archive/individual/data/xkeyboard-config/xkeyboard-config-2.41.tar.xz
MESON_ARGS="-Dxkb-base=$PREFIX/share/X11/xkb -Dcompat-rules=true -Dxorg-rules-symlinks=false"
