cd $DESTDIR/$PREFIX/lib
for lib in pulseaudio/{,modules/}lib*.so*; do
	ln -v -s -f "$lib" "$(basename "$lib")"
done

# Pulseaudio fails to start when it cannot detect any sound hardware
# so disable hardware detection.
sed -i $DESTDIR/$PREFIX/etc/pulse/default.pa -e '/^load-module module-detect$/s/^/#/'
echo "load-module module-aaudio-sink" >> $DESTDIR/$PREFIX/etc/pulse/default.pa