PKG_VER="10.1-esync"
PKG_CATEGORY="Wine"
PKG_PRETTY_NAME="Wine ($PKG_VER)"

BLACKLIST_ARCHITECTURE=aarch64

GIT_URL=https://github.com/KreitinnSoftware/wine
GIT_COMMIT=21db52b0934844bec8b2f6660a393445fb240f18
HOST_BUILD_CONFIGURE_ARGS="--enable-win64 --without-x"
HOST_BUILD_FOLDER="$INIT_DIR/workdir/$package/wine-tools"
HOST_BUILD_MAKE="make -j $(nproc) __tooldeps__ nls/all"
OVERRIDE_PREFIX="$(realpath $PREFIX/../wine)"
LDFLAGS="-L$PREFIX/lib -landroid-shmem"
CFLAGS="-I$PREFIX/include"
CONFIGURE_ARGS="--enable-archs=i386,x86_64 \
				--host=$TOOLCHAIN_TRIPLE \
				--with-wine-tools=$INIT_DIR/workdir/$package/wine-tools \
				--prefix=$OVERRIDE_PREFIX \
				--without-oss \
				--disable-winemenubuilder \
				--disable-win16 \
				--disable-tests \
				--with-x \
				--x-libraries=$PREFIX/lib \
				--x-includes=$PREFIX/include \
				--with-mingw=gcc \
				--with-pulse \
				--with-gstreamer \
				--with-opengl \
				--with-gnutls \
				--with-xshm \
				--without-xxf86vm \
				--without-osmesa \
				--without-usb \
				--without-sdl \
				--without-cups \
				--without-netapi \
				--without-pcap \
				--without-gphoto \
				--without-v4l2 \
				--without-pcsclite \
				--without-wayland \
				--without-opencl \
				--without-dbus \
				--without-sane \
				--without-udev \
				--without-capi"
