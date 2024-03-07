SRC_URL=https://gitlab.freedesktop.org/mesa/mesa/-/archive/main/mesa-main.tar.gz
MESON_ARGS="--cross-file=../../../meson-cross-file-aarch64 -Dgallium-drivers=swrast,virgl -Dvulkan-drivers= -Dglx=dri -Ddri3=enabled -Dplatforms=x11 -Dcpp_rtti=false -Dxmlconfig=disabled -Dllvm=disabled -Dopengl=true -Degl=enabled -Dshared-llvm=disabled -Dzstd=disabled"
USE_NDK_VERSION=26b
OVERRIDE_PREFIX=/data/data/com.micewine.emu/files/usr/mesa
