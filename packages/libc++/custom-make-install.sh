mkdir -p $DESTDIR/$PREFIX/lib

cp $INIT_DIR/cache/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/$ARCH-linux-android/libc++_shared.so $DESTDIR/$PREFIX/lib
