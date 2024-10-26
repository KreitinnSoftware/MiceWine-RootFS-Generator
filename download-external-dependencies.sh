dxvkDownload() {
	if [ -e "DXVK/DXVK-$1" ]; then
		echo "DXVK-$1 already downloaded."
	else
		echo "Downloading DXVK-$1..."

		cd "DXVK"

		curl -# -L -O "https://github.com/doitsujin/dxvk/releases/download/v$1/dxvk-$1.tar.gz"

		mkdir -p "DXVK-$1"

		tar -xf "dxvk-$1.tar.gz"

		mv "dxvk"*"/x32" "dxvk"*"/x64" "DXVK-$1"

		rm -rf "dxvk"*

		cd "$OLDPWD"
	fi
}

dxvkAsyncDownload() {
	if [ -e "DXVK/DXVK-$1-async" ]; then
		echo "DXVK-$1-async already downloaded."
	else
		echo "Downloading DXVK-$1-async..."

		cd "DXVK"

		curl -# -L -O "https://github.com/Sporif/dxvk-async/releases/download/$1/dxvk-async-$1.tar.gz"

		mkdir -p "DXVK-$1-async"

		tar -xf "dxvk-async-$1.tar.gz"

		mv "dxvk"*"/x32" "dxvk"*"/x64" "DXVK-$1-async"

		rm -rf "dxvk"*

		cd "$OLDPWD"
	fi
}

dxvkGplAsyncDownload() {
	if [ -e "DXVK/DXVK-$1-gplasync" ]; then
		echo "DXVK-$1-gplasync already downloaded."
	else
		echo "Downloading DXVK-$1-gplasync..."

		cd "DXVK"

		curl -# -L -O "https://gitlab.com/Ph42oN/dxvk-gplasync/-/raw/main/releases/dxvk-gplasync-v$1.tar.gz?ref_type=heads&inline=false"

		mkdir -p "DXVK-$1-gplasync"

		tar -xf "dxvk-gplasync-v$1.tar.gz"

		mv "dxvk"*"/x32" "dxvk"*"/x64" "DXVK-$1-gplasync"

		rm -rf "dxvk"*

		cd "$OLDPWD"
	fi
}

wined3dDownload() {
	if [ -e "WineD3D/WineD3D-($1)" ]; then
		echo "WineD3D-$1 already downloaded."
	else
		echo "Downloading WineD3D-$1..."

		cd "WineD3D"	

		curl -# -L -O "https://downloads.fdossena.com/Projects/WineD3D/Builds/WineD3DForWindows_$1.zip"
		curl -# -L -O "https://downloads.fdossena.com/Projects/WineD3D/Builds/WineD3DForWindows_$1-x86_64.zip"

		mkdir -p "WineD3D-($1)/x64"
		mkdir -p "WineD3D-($1)/x32"

		7z x "WineD3D*$1-x86_64.zip" -o"wined3d-x64" -aoa &> /dev/zero
		7z x "WineD3D*$1.zip" -o"wined3d-x32" -aoa &> /dev/zero

		for i in $(find "wined3d-x64" -name "*.dll"); do
			cp -f "$i" "WineD3D-($1)/x64"
		done

		for i in $(find "wined3d-x32" -name "*.dll"); do
			cp -f "$i" "WineD3D-($1)/x32"
		done

		rm -rf "wined3d"* *".zip"

		cd "$OLDPWD"
	fi
}

vkd3dDownload() {
	if [ -e "VKD3D/VKD3D-$1" ]; then
		echo "VKD3D-$1 already downloaded."
	else
		cd "VKD3D"

		echo "Downloading VKD3D-$1..."

		curl -# -L -O "https://github.com/HansKristian-Work/vkd3d-proton/releases/download/v$1/vkd3d-proton-$1.tar.zst"

		mkdir -p "VKD3D-$1"

		tar -xf "vkd3d-proton-$1.tar.zst"

		mv "vkd3d"*"/x64" "VKD3D-$1/"
		mv "vkd3d"*"/x86" "VKD3D-$1/x32"

		rm -rf "vkd3d"*

		cd "$OLDPWD"
	fi
}

wineMonoGeckoDownload() {
	mkdir -p "$WORKDIR/home/.cache/wine"

	cd "$WORKDIR/home/.cache/wine"

	if [ -e "wine-mono-$1-x86.msi" ]; then
		echo "Wine Mono $1 already downloaded"
	else
		echo "Downloading Wine Mono $1..."

		curl -# -L -O "https://dl.winehq.org/wine/wine-mono/$1/wine-mono-$1-x86.msi"
	fi

	if [ -e "wine-gecko-$2-x86_64.msi" ]; then
		echo "Wine Gecko $2 already downloaded"
	else
		echo "Downloading Wine Gecko $2..."

		curl -# -L -O "https://dl.winehq.org/wine/wine-gecko/$2/wine-gecko-$2-x86_64.msi"
	fi

	cd "$WORKDIR"
}

export INIT_DIR="$PWD"
export WORKDIR="$PWD/rootfs/files"

mkdir -p "$WORKDIR"

cd "$WORKDIR"

wineMonoGeckoDownload 9.3.0 2.47.4

mkdir -p "home" "wine-utils"

cd "wine-utils"

mkdir -p "DXVK" "WineD3D" "VKD3D"

for i in "2.4-1" "2.3.1-1" "2.3-1" "2.2-4" "2.1-4"; do
	dxvkGplAsyncDownload "$i"
done

for i in "2.0" "1.10.3" "1.10.2" "1.10.1" "1.10" "1.9.4" "1.9.3" "1.9.2" "1.9.1" "1.9"; do
	dxvkAsyncDownload "$i"
done

for i in "2.4.1" "2.4" "2.3.1" "2.3" "2.2" "2.1" "2.0" "1.10.3" "1.10.2" "1.10.1" "1.10" "1.9.4" "1.9.3" "1.9.2" "1.9.1" "1.9"; do
	dxvkDownload "$i"
done

for i in "9.20" "9.16" "9.3" "9.1" "9.0" "8.15" "7.11" "3.17"; do
	wined3dDownload "$i"
done

vkd3dDownload "2.13"

cp -rf "$INIT_DIR/etc/"* .
