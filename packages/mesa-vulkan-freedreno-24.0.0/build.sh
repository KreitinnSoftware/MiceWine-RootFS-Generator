PKG_VER=24.0.0
PKG_CATEGORY="VulkanDriver"
PKG_PRETTY_NAME="Mesa Turnip Driver"
PKG_OPTIONAL=1
VK_DRIVER_LIB="libvulkan_freedreno.so"

BLACKLIST_ARCH=x86_64

SRC_URL=https://archive.mesa3d.org/mesa-$PKG_VER.tar.xz
LDFLAGS="-L$PREFIX/lib -landroid-shmem"
CPPFLAGS="-D__USE_GNU"
MESON_ARGS="-Dgallium-drivers= -Dvulkan-drivers=freedreno -Dfreedreno-kmds=msm,kgsl -Dglvnd=false -Dplatforms=x11 -Dxmlconfig=enabled -Dllvm=disabled -Dopengl=false -Degl=disabled -Dzstd=enabled"
