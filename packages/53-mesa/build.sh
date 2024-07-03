GIT_URL=https://gitlab.freedesktop.org/mesa/mesa

getVulkanDrivers() {
	if [ "$ARCHITECTURE" == "aarch64" ]; then
		echo "-Dvulkan-drivers=freedreno -Dfreedreno-kmds=kgsl,msm"
	elif [ "$ARCHITECTURE" == "x86_64" ]; then
		echo "-Dvulkan-drivers=intel_hasvk"
	fi
}

MESON_ARGS="--cross-file=../../../meson-cross-file-$ARCHITECTURE -Dgallium-drivers=swrast,zink,virgl $(getVulkanDrivers) -Dglvnd=enabled -Dglx=dri -Ddri3=enabled -Dplatforms=x11 -Dcpp_rtti=false -Dxmlconfig=disabled -Dllvm=disabled -Dopengl=true -Degl=enabled -Dshared-llvm=disabled -Dzstd=enabled"
USE_NDK_VERSION=26b
LDFLAGS="-L$PREFIX/lib -landroid-shmem"
