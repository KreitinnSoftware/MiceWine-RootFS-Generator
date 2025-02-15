cd $DESTDIR/$PREFIX/lib
for lib in pulseaudio/{,modules/}lib*.so*; do
	ln -v -s -f "$lib" "$(basename "$lib")"
done
