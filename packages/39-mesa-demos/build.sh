SRC_URL=https://mesa.freedesktop.org/archive/demos/mesa-demos-9.0.0.tar.xz
MESON_ARGS="--cross-file=../../../meson-cross-file-$ARCHITECTURE -Dlibdrm=disabled -Dvulkan=disabled -Dwayland=disabled -Dwith-system-data-files=true -Dglut=disabled -Degl=disabled"
