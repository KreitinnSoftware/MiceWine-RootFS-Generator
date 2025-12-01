#!/bin/bash
if [ $# -lt 1 ]; then
  echo "Specify Architecture for Building RootFS."
  exit 0
fi

if [ "$1" != "aarch64" ] && [ "$1" != "x86_64" ]; then
  echo "Invalid Architecture Specified, Available 'aarch64' and 'x86_64'"
  exit 0
fi

export PREFIX=/data/data/com.micewine.emu/files/usr
export INIT_DIR=$PWD
export ARCH=$1
export GIT_SHORT_SHA=$(git rev-parse --short HEAD)

if [ ! -d "$INIT_DIR/built-pkgs" ]; then
  echo "built-pkgs: Don't Exist. Run 'build-all.sh' for generate the needed libs for creating a rootfs for MiceWine."
  exit 0
fi

export ROOTFS_PKGS=$(find "$INIT_DIR/built-pkgs" -name "*$ARCH*.rat" | sort)
export WINE_PKG=$(find "$INIT_DIR/built-pkgs" -name "*wine*.rat")
export WINE_UTILS_PKG="$INIT_DIR/Wine-Utils-($GIT_SHORT_SHA)-any.rat"

if [ ! -f "$WINE_UTILS_PKG" ]; then
  $INIT_DIR/tools/download-external-dependencies.sh
  $INIT_DIR/tools/create-rat-pkg.sh "Wine-Utils" "Wine Utils" "" "any" "($GIT_SHORT_SHA)" "wine-utils" "$INIT_DIR/wine-utils" "$INIT_DIR"
fi

ROOTFS_PKGS+=" $WINE_UTILS_PKG"

if [ -f "$WINE_PKG" ]; then
  ROOTFS_PKGS+=" $WINE_PKG"
else
  echo "Warning, Wine Not Found."
fi

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

export RAND_VAL=$RANDOM

mkdir -p /tmp/$RAND_VAL

cd /tmp/$RAND_VAL

mkdir -p "vulkanDrivers"
mkdir -p "adrenoTools"
mkdir -p "box64"
mkdir -p "wine"

touch new_makeSymlinks.sh

for i in $ROOTFS_PKGS; do
  resolvedPath=$(resolvePath "$i")

  if [ -n "$resolvedPath" ] && [ ! -f "$INIT_DIR/built-pkgs/$(basename $i | sed "s/.rat/.isOptional/g")" ]; then
    echo "Extracting '$(basename $resolvedPath)'..."

    tar -xf "$resolvedPath" pkg-header

    packageCategory=$(getElementFromHeader 2)

    if [ "$packageCategory" == "VulkanDriver" ]; then
      cp -f "$resolvedPath" "vulkanDrivers"
    elif [ "$packageCategory" == "Box64" ]; then
      cp -f "$resolvedPath" "box64"
    elif [ "$packageCategory" == "Wine" ]; then
      cp -f "$resolvedPath" "wine"
    elif [ "$packageCategory" == "AdrenoTools" ]; then
      cp -f "$resolvedPath" "adrenoTools"
    else
      tar -xf "$resolvedPath"
    fi

    if [ -f "makeSymlinks.sh" ]; then
      cat makeSymlinks.sh >> new_makeSymlinks.sh
      rm -f makeSymlinks.sh
    fi
  fi
done

mv new_makeSymlinks.sh makeSymlinks.sh

$INIT_DIR/tools/create-rat-pkg.sh "MiceWine-RootFS" "MiceWine RootFS" "" "$ARCH" "($GIT_SHORT_SHA)" "rootfs" "$PWD" "$INIT_DIR"

cd "$INIT_DIR"

rm -rf /tmp/$RAND_VAL
