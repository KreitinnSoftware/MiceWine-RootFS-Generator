PKG_VER=25.0.0-[gss]
PKG_CATEGORY="VulkanDriver"
PKG_PRETTY_NAME="Mesa Android Wrapper"
VK_DRIVER_LIB="libvulkan_wrapper.so"

GIT_URL=https://github.com/xMeM/mesa
GIT_COMMIT=e65c7eb6ee2f9903c3256f2677beb1d98464103f
LDFLAGS="-L$PREFIX/lib -landroid-shmem"
MESON_ARGS="-Dgallium-drivers= -Dvulkan-drivers=wrapper -Dglvnd=disabled -Dplatforms=x11 -Dxmlconfig=disabled -Dllvm=disabled -Dopengl=false -Degl=disabled -Dzstd=enabled"
