#!/bin/sh
if [ ! -d "$HOME/.wine" ]; then
		wineboot -i &> /dev/null
		rm -r ~/.wine/drive_c/ProgramData/Microsoft/Windows/Start\ Menu
		ln -s $PREFIX/opt/wine-utils/Start\ Menu ~/.wine/drive_c/ProgramData/Microsoft/Windows/
		ln -s $PREFIX/opt/wine-utils/Addons ~/.wine/drive_c/
		cp -f $PREFIX/opt/wine-utils/Addons/Windows/* ~/.wine/drive_c/windows/
		wine regedit c:/Addons/DefaultDLLsOverrides.reg &> /dev/null
		cp -rf $PREFIX/opt/wine-utils/DirectX/x32/* ~/.wine/drive_c/windows/syswow64
		cp -rf $PREFIX/opt/wine-utils/DirectX/x64/* ~/.wine/drive_c/windows/system32
fi

wineserver -k &> /dev/null

rm -rf $HOME/.wine/.wineserver

wine regedit c:/Addons/Themes/DarkBlue/DarkBlue_1280x720.reg &> /dev/null

export DXVK_STATE_CACHE_PATH="$HOME/.cache/dxvk-shader-cache"
export BOX64_LOG=1
export BOX64_MMAP32=1

wine explorer /desktop=shell,1280x720 start TFM-IB-0.1.8