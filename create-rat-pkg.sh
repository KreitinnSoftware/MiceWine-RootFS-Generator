#!/bin/bash

showHelp()
{
	echo "Usage: $0 [package name] [architecture] [version] [category] [destdir-pkg] [output folder]"
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

if [ $# -lt 6 ]; then
	showHelp
	exit 0
fi

echo ""
echo "Creating Package '$1-$3-$2.rat'..."

export WORKDIR="$5"

if [ -d "$5/data/" ]; then
	WORKDIR="$5/data/data/com.micewine.emu/"
fi

cd $WORKDIR

echo "name=$1" > pkg-header
echo "category=$4" >> pkg-header
echo "version=$3" >> pkg-header
echo "architecture=$2" >> pkg-header

symlink2sh "files/" 

7z -tzip -mx=5 a "$6/$1-$3-$2.rat" &> /dev/zero