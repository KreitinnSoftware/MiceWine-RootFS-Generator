#!/bin/sh
wine()
{
	box64 $ROOT_DIR/wine/x86_64/bin/wine $*
}

wineserver()
{
	box64 $ROOT_DIR/wine/x86_64/bin/wineserver $*
}

wineboot()
{
	wine wineboot $*
}

export ROOT_DIR=/data/data/com.micewine.emu/files

if [ ! -d "$HOME/.wine" ]; then
	echo Creating Prefix...
	wineboot -i &> /dev/null
	rm -rf "$HOME/.wine/drive_c/ProgramData/Microsoft/Windows/Start Menu"
	cp -rf "$ROOT_DIR/wine-utils/Start Menu" "$HOME/.wine/drive_c/ProgramData/Microsoft/Windows/"
	ln -sf "$ROOT_DIR/wine-utils/Addons" "$HOME/.wine/drive_c/"
	cp -rf $ROOT_DIR/wine-utils/Addons/Windows/* "$HOME/.wine/drive_c/windows/"
	wine regedit c:/Addons/DefaultDLLsOverrides.reg &> /dev/null
	cp -rf $ROOT_DIR/wine-utils/DirectX/x32/* "$HOME/.wine/drive_c/windows/syswow64"
	cp -rf $ROOT_DIR/wine-utils/DirectX/x64/* "$HOME/.wine/drive_c/windows/system32"
fi

wineserver -k &> /dev/null

rm -rf $HOME/.wine/.wineserver

echo Applying Theme...

wine regedit c:/Addons/Themes/DarkBlue/DarkBlue_1280x720.reg

export DXVK_STATE_CACHE_PATH="$HOME/.cache/dxvk-shader-cache"
export BOX64_LOG=1
export BOX64_MMAP32=1

echo Main Process

wine explorer /desktop=shell,1280x720 start TFM-IB-0.1.8