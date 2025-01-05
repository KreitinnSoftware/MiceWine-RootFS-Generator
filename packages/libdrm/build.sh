PKG_VER=2.4.123
SRC_URL=https://dri.freedesktop.org/libdrm/libdrm-$PKG_VER.tar.xz
MESON_ARGS="-Dfreedreno=enabled -Dfreedreno-kgsl=true -Dintel=disabled -Dradeon=enabled -Damdgpu=enabled -Dnouveau=disabled -Dvmwgfx=disabled -Dtests=false"
