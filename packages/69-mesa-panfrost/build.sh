PKG_VER=[gss]
GIT_URL=https://github.com/joaobatista070/mesa-Panfork-android
LDFLAGS="-L$PREFIX/lib -landroid-shmem -lxcb-xfixes"
MESON_ARGS="-Dgallium-drivers=panfrost -Dvulkan-drivers= -Dglvnd=enabled -Dplatforms=x11 -Dxmlconfig=disabled -Dllvm=disabled -Dopengl=true -Degl=disabled -Dzstd=enabled"
