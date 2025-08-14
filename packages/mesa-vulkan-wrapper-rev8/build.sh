PKG_VER=24.2.5
PKG_CATEGORY="VulkanDriver"
PKG_PRETTY_NAME="Mesa Android Wrapper (Rev 8)"
PKG_OPTIONAL=1
VK_DRIVER_LIB="libvulkan_wrapper.so"

SRC_URL=https://archive.mesa3d.org/mesa-$PKG_VER.tar.xz
LDFLAGS="-L$PREFIX/lib -landroid-shmem"
MESON_ARGS="-Dgallium-drivers= -Dvulkan-drivers=wrapper -Dglvnd=disabled -Dplatforms=x11 -Dxmlconfig=enabled -Dllvm=disabled -Dopengl=false -Degl=disabled -Dzstd=enabled"
DEPENDENCIES="xorgproto libdrm libX11 libxcb libxshmfence Vulkan-Headers Vulkan-Loader zlib zstd libexpat libglvnd libpng libXext libXrandr libxshmfence libXxf86vm"
