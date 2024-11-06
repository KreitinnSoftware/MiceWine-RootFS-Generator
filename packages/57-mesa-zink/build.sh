PKG_VER=[gss]
GIT_URL=https://gitlab.freedesktop.org/mesa/mesa
GIT_COMMIT=ed64ecc
LDFLAGS="-L$PREFIX/lib -landroid-shmem -lxcb-xfixes"
MESON_ARGS="-Dgallium-drivers=zink -Dvulkan-drivers= -Dglvnd=enabled -Dplatforms=x11 -Dxmlconfig=disabled -Dllvm=disabled -Dopengl=true -Degl=disabled -Dzstd=enabled"
