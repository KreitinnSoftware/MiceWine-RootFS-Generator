#!/bin/bash

showHelp()
{
	echo "Usage: $0 [name] [version] [category] [architecture] [rat package 1] [rat package 2] ..."
	echo ""
}

resolvePath()
{
	if [ -f "$1" ]; then
		echo "$1"
	elif [ -f "$INIT_DIR/$1" ]; then
		echo "$INIT_DIR/$1"
	fi
}

getElementFromHeader()
{
	echo "$(cat pkg-header | head -n $1 | tail -n 1 | cut -d "=" -f 2)"
}

export INIT_DIR=$PWD
export RAND_VAL=$RANDOM--

if [ $# -lt 6 ]; then
	showHelp
	exit 0
fi

mkdir -p /tmp/$RAND_VAL

cd /tmp/$RAND_VAL

mkdir -p "vulkanDrivers"

touch new_makeSymlinks.sh

for i in $*; do
	resolvedPath=$(resolvePath "$i")

	if [ -n "$resolvedPath" ]; then
		echo "Extracting '$(basename $resolvedPath)'..."

		7z -aoa e "$resolvedPath" pkg-header &> /dev/zero

		packageCategory=$(getElementFromHeader 2)

		if [ "$packageCategory" == "VulkanDriver" ]; then
			cp -f "$resolvedPath" "vulkanDrivers"
		else
			7z -aoa x "$resolvedPath" &> /dev/zero
		fi

		if [ -f "makeSymlinks.sh" ]; then
			cat makeSymlinks.sh >> new_makeSymlinks.sh
			rm -f makeSymlinks.sh
		fi
	fi
done

mv new_makeSymlinks.sh makeSymlinks.sh

$INIT_DIR/create-rat-pkg.sh "$1" "MiceWine RootFS" "" "$4" "$2" "$3" "$PWD" "$INIT_DIR"

cd "$INIT_DIR"

rm -rf /tmp/$RAND_VAL
