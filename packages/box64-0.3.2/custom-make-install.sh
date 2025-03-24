mkdir -p $DESTDIR/$PREFIX/bin
mkdir -p $DESTDIR/$PREFIX/etc

cp box64 $DESTDIR/$PREFIX/bin
cp ../system/box64.box64rc $DESTDIR/$PREFIX/etc
