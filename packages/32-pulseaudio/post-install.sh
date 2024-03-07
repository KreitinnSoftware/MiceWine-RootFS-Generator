# Some Symlinks
cd $PREFIX/lib

for lib in pulseaudio/{,modules/}lib*.so*; do
	ln -v -s -f "$lib" "$(basename "$lib")"
done

# Pulseaudio fails to start when it cannot detect any sound hardware
# so disable hardware detection.
sed -i $PREFIX/etc/pulse/default.pa -e '/^load-module module-detect$/s/^/#/'
echo "load-module module-sles-sink" >> $PREFIX/etc/pulse/default.pa
echo "#load-module module-aaudio-sink" >> $PREFIX/etc/pulse/default.pa

cd $OLDPWD