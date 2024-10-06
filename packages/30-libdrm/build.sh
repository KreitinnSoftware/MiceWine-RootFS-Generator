SRC_URL=https://dri.freedesktop.org/libdrm/libdrm-2.4.123.tar.xz
MESON_ARGS="--cross-file=../../../meson-cross-file-$ARCHITECTURE -Dfreedreno=enabled -Dfreedreno-kgsl=true -Dintel=disabled -Dradeon=enabled -Damdgpu=enabled -Dnouveau=disabled -Dvmwgfx=disabled -Dtests=false"
