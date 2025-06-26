PKG_VER=0.8.1
SRC_URL=https://github.com/flightlessmango/MangoHud/releases/download/v$PKG_VER/MangoHud-v$PKG_VER-Source.tar.xz
LDFLAGS="-Wl,--undefined-version"
MESON_ARGS="-Dwith_xnvctrl=disabled -Dwith_wayland=disabled -Dwith_dbus=disabled -Dtests=disabled"