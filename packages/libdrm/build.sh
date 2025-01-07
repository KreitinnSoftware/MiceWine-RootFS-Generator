PKG_VER=2.4.124
SRC_URL=https://dri.freedesktop.org/libdrm/libdrm-$PKG_VER.tar.xz

getDrmDrivers()
{
	if [ "$ARCHITECTURE" == "aarch64" ]; then
		echo "-Dfreedreno=enabled -Dfreedreno-kgsl=true"
	elif [ "$ARCHITECTURE" == "x86_64" ]; then
		echo "-Dradeon=enabled -Damdgpu=enabled"
	fi
}

MESON_ARGS="-Dintel=disabled $(getDrmDrivers) -Dvmwgfx=disabled -Dtests=false"
