GIT_URL=https://gitlab.freedesktop.org/mesa/mesa
GIT_COMMIT=5eb0dec525a2e368d7b2a4cb79264926b51d8f88
MESON_ARGS="--cross-file=../../../meson-cross-file-$ARCHITECTURE -Dgallium-drivers=swrast,zink,virgl -Dvulkan-drivers=freedreno,virtio -Dfreedreno-kmds=kgsl,msm -Dglvnd=true -Dglx=dri -Ddri3=enabled -Dplatforms=x11 -Dcpp_rtti=false -Dxmlconfig=disabled -Dllvm=disabled -Dopengl=true -Degl=enabled -Dshared-llvm=disabled -Dzstd=enabled"
USE_NDK_VERSION=26b
LDFLAGS="-L$PREFIX/lib -landroid-shmem"
