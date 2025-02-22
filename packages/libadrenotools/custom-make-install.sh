mkdir -p $DESTDIR/$PREFIX/lib
mkdir -p $DESTDIR/$PREFIX/include

cp libadrenotools.a $DESTDIR/$PREFIX/lib
cp lib/linkernsbypass/liblinkerbypass.a $DESTDIR/$PREFIX/lib
cp src/hook/*.so $DESTDIR/$PREFIX/lib
cp -rf ../include/* $DESTDIR/$PREFIX/include
cp ../lib/linkernsbypass/android_linker_ns.h $DESTDIR/$PREFIX/include
