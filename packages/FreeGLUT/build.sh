PKG_VER=3.4.0
SRC_URL=https://downloads.sourceforge.net/freeglut/freeglut-$PKG_VER.tar.gz
CMAKE_ARGS="-DANDROID=OFF -DCMAKE_LIBRARY_PATH=$PREFIX_DIR/lib"
CFLAGS="-I$PREFIX_DIR/include"
LDFLAGS="-L$PREFIX_DIR/lib -lGL -landroid-shmem"
DEPENDENCIES="libX11 libXi libXrandr libXxf86vm GLU android-shmem"
