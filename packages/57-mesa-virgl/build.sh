GIT_URL=https://gitlab.freedesktop.org/mesa/mesa
GIT_COMMIT=0a3784ae33bbdcd50b2a6d8de5d52779276bb36c
LDFLAGS="-L$PREFIX/lib -landroid-shmem"
OVERRIDE_PREFIX=$PREFIX/mesa-virgl
MESON_ARGS="--cross-file=../../../meson-cross-file-$ARCHITECTURE -Dgallium-drivers=virgl -Dvulkan-drivers= -Dglvnd=true -Dglx=dri -Ddri3=enabled -Dplatforms=x11 -Dxmlconfig=disabled -Dllvm=disabled -Dopengl=true -Degl=enabled -Dzstd=enabled"
