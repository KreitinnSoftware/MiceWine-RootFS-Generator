PKG_VER=3.4.0
SRC_URL=https://downloads.sourceforge.net/freeglut/freeglut-$PKG_VER.tar.gz
CMAKE_ARGS="-DANDROID=OFF -DCMAKE_LIBRARY_PATH=/data/data/com.micewine.emu/files/usr/lib"
CFLAGS="-I$PREFIX_DIR/include"
