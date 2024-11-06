PKG_VER=[gss]
GIT_URL=https://gitlab.freedesktop.org/mesa/mesa
GIT_COMMIT=a02dd9b36fac2837491e052b9b860ab64408b03a
BLACKLIST_ARCHITECTURE=aarch64
LDFLAGS="-L$PREFIX/lib -landroid-shmem"
CPPFLAGS="-D__USE_GNU"
MESON_ARGS="-Dgallium-drivers= -Dvulkan-drivers=amd -Dglvnd=disabled -Dplatforms=x11 -Dxmlconfig=disabled -Dllvm=disabled -Dopengl=false -Degl=disabled -Dzstd=enabled"
