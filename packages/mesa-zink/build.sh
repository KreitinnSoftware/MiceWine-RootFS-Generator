PKG_VER=24.3.0
PKG_CATEGORY="OpenGLDriver"
PKG_PRETTY_NAME="Mesa Zink Driver"

SRC_URL=https://archive.mesa3d.org/mesa-$PKG_VER.tar.xz
LDFLAGS="-L$PREFIX/lib -landroid-shmem -lxcb-xfixes"
MESON_ARGS="-Dgallium-drivers=zink -Dvulkan-drivers= -Dglvnd=enabled -Dplatforms=x11 -Dxmlconfig=enabled -Dllvm=disabled -Dopengl=true -Degl=disabled -Dzstd=enabled" 
