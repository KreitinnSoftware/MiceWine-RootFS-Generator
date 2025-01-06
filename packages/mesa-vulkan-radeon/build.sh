PKG_VER=25.0.0-devel-[gss]
PKG_CATEGORY="VulkanDriver"
PKG_PRETTY_NAME="Mesa Radeon Driver"
VK_DRIVER_LIB="libvulkan_radeon.so"

BLACKLIST_ARCHITECTURE=aarch64

GIT_URL=https://gitlab.freedesktop.org/mesa/mesa
GIT_COMMIT=61593e9c549e6f497fd7344aa353663e10354058
LDFLAGS="-L$PREFIX/lib -landroid-shmem"
CPPFLAGS="-D__USE_GNU"
MESON_ARGS="-Dgallium-drivers= -Dvulkan-drivers=amd -Dglvnd=disabled -Dplatforms=x11 -Dxmlconfig=disabled -Dllvm=disabled -Dopengl=false -Degl=disabled -Dzstd=enabled"
