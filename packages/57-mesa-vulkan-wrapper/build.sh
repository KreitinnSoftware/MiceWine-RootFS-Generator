PKG_VER=24.2.5
SRC_URL=https://archive.mesa3d.org/mesa-$PKG_VER.tar.xz
LDFLAGS="-L$PREFIX/lib -landroid-shmem"
MESON_ARGS="-Dgallium-drivers= -Dvulkan-drivers=wrapper -Dglvnd=disabled -Dplatforms=x11 -Dxmlconfig=disabled -Dllvm=disabled -Dopengl=true -Degl=disabled -Dzstd=enabled"
