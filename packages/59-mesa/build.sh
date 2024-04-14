SRC_URL=https://gitlab.freedesktop.org/mesa/mesa/-/archive/main/mesa-main.tar.gz
MESON_ARGS="--cross-file=../../../meson-cross-file-$ARCHITECTURE -Dgallium-drivers=swrast,zink,virgl -Dvulkan-drivers=freedreno,virtio -Dfreedreno-kmds=kgsl,msm -Dglvnd=true -Dglx=dri -Ddri3=enabled -Dplatforms=x11 -Dcpp_rtti=false -Dxmlconfig=disabled -Dllvm=disabled -Dopengl=true -Degl=enabled -Dshared-llvm=disabled -Dzstd=enabled"
USE_NDK_VERSION=26b
LDFLAGS="-L$PREFIX/lib -landroid-shmem"
