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
export GIT_SHORT_SHA=$(git rev-parse --short HEAD)

if [ ! -d "$INIT_DIR/built-pkgs" ]; then
  echo "built-pkgs: Don't Exist. Run 'build-all.sh' for generate the needed libs for creating a rootfs for MiceWine."
  exit 0
fi

export ROOTFS_PKGS=$(find "$INIT_DIR/built-pkgs" -name "*$1*.rat" | sort)
export WINE_PKG=$(find "$INIT_DIR/built-pkgs" -name "*wine*.rat")
export WINE_UTILS_PKG="$INIT_DIR/Wine-Utils-($GIT_SHORT_SHA)-any.rat"

if [ ! -f "$WINE_UTILS_PKG" ]; then
  ./download-external-dependencies.sh
  ./create-rat-pkg.sh "Wine-Utils" "Wine Utils" "any" "($GIT_SHORT_SHA)" "wine-utils" "$INIT_DIR/wine-utils" "$INIT_DIR"
fi

ROOTFS_PKGS+=" $WINE_UTILS_PKG"

if [ -f "$WINE_PKG" ]; then
  ROOTFS_PKGS+=" $WINE_PKG"
else
  echo "Warning, Wine Not Found."
fi

./cat-rat-pkgs.sh "MiceWine-RootFS" "($GIT_SHORT_SHA)" "rootfs" "$1" $ROOTFS_PKGS
