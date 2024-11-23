#!/bin/bash

showHelp()
{
	echo "Usage: $0 [package name] [package pretty name] [architecture] [version] [category] [destdir-pkg] [output folder]"
	echo ""
}

symlink2sh() {
  for folder in $(find $1 -type d); do
    if [ -d "$folder" ]; then
      cd "$folder"

      for file in $(find $PWD -type l); do
        target=$(readlink $file)

        if [ "$target" != "nul" ]; then
          rm "$file"

          target=$(echo $target | sed "s@$WORKDIR@$APP_ROOT_DIR@g")
          file=$(echo $file | sed "s@$WORKDIR@$APP_ROOT_DIR@g")

          echo "ln -sf $target $file" >> $WORKDIR/makeSymlinks.sh
        fi
      done

      cd $OLDPWD
    fi
  done
}

export INIT_DIR=$PWD
export APP_ROOT_DIR=/data/data/com.micewine.emu/

export PACKAGE_NAME=$1
export PACKAGE_PRETTY_NAME=$2
export PACKAGE_ARCHITECTURE=$3
export PACKAGE_VERSION=$4
export PACKAGE_CATEGORY=$5
export DESTDIR_PKG=$6
export OUTDIR=$7

if [ $# -lt 7 ]; then
	showHelp
	exit 0
fi

echo ""
echo "Creating Package '$PACKAGE_NAME-$PACKAGE_VERSION-$PACKAGE_ARCHITECTURE.rat'..."

export WORKDIR="$DESTDIR_PKG"

if [ -d "$DESTDIR_PKG/data/" ]; then
	WORKDIR="$DESTDIR_PKG/data/data/com.micewine.emu/"
fi

cd $WORKDIR

echo "name=$PACKAGE_PRETTY_NAME" > pkg-header
echo "category=$PACKAGE_CATEGORY" >> pkg-header
echo "version=$PACKAGE_VERSION" >> pkg-header
echo "architecture=$PACKAGE_ARCHITECTURE" >> pkg-header

symlink2sh "files/" 

7z -tzip -mx=5 a "$OUTDIR/$PACKAGE_NAME-$PACKAGE_VERSION-$PACKAGE_ARCHITECTURE.rat" &> /dev/zero