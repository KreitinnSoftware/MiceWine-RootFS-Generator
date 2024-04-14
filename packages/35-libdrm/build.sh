SRC_URL=https://dri.freedesktop.org/libdrm/libdrm-2.4.120.tar.xz
MESON_ARGS="--cross-file=../../../meson-cross-file-$ARCHITECTURE -Dfreedreno=enabled -Dfreedreno-kgsl=true -Dintel=disabled -Dradeon=disabled -Damdgpu=disabled -Dnouveau=disabled -Dvmwgfx=disabled -Dtests=false"
USE_NDK_VERSION=26b
