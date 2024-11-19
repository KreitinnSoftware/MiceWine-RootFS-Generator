PKG_VER=[gss]
GIT_URL=https://github.com/joaobatista070/mesa-Panfork-android
LDFLAGS="-L$PREFIX/lib -landroid-shmem -lxcb-xfixes -Wl,--undefined-version"
MESON_ARGS="-Dgallium-drivers=panfrost,swrast -Dvulkan-drivers= -Dglvnd=true -Dplatforms=x11 -Dxmlconfig=disabled -Dllvm=disabled -Dopengl=true -Degl=disabled -Dzstd=enabled"
BLACKLIST_ARCHITECTURE=x86_64
