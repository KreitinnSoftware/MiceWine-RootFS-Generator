#!/bin/bash

symlink2sh() {
  for folder in $(find $1 -type d); do
    if [ -d "$folder" ]; then
      cd "$folder"

      for file in $(find $PWD -type l); do
        target=$(readlink $file)

        if [ "$target" != "nul" ]; then
          rm "$file"

          echo "ln -sf $target $file" >> $1/generateSymlinks.sh
        fi
      done

      cd $OLDPWD
    fi
  done
}

export PREFIX=/data/data/com.micewine.emu/files/usr
export INIT_DIR=$PWD

if [ ! -e "$PREFIX" ]; then
  echo "$PREFIX: Don't Exist. Run 'build-all.sh' for generate the needed libs for creating a rootfs for MiceWine."
  exit
fi

if [ $# == 1 ]; then
  if [ $1 == "--clean-all" ]; then
    export ARGS="$1"
  else
    export ZIPFILE_APPEND="-$1"
  fi
elif [ $# == 2 ]; then
  export ZIPFILE_APPEND="-$2"
  export ARGS="$1"
fi

# Convert symlinks to a .sh file that need to be executed after zip extract
symlink2sh "$PREFIX"

case $ARGS in *"--clean-all"*)
  echo "Removing Static Libraries..."
  rm -f "$PREFIX/lib/"*".la"
  rm -f "$PREFIX/lib/"*".a"

  echo "Removing Generated Folders..."
  rm -rf $PREFIX/lib/{python*,cmake,pkgconfig}
  rm -rf $PREFIX/share/{cmake,aclocal,bash-completion,doc,info,man,util-macros,zsh}
  rm -rf $PREFIX/local
esac

case $ARGS in *"--clean-all"*)
  export ROOTFS_PACKAGE="MiceWine-RootFS-Minimal$ZIPFILE_APPEND"
  ;;
  *)
  export ROOTFS_PACKAGE="MiceWine-RootFS$ZIPFILE_APPEND"
esac

./external-files-download-path.sh

cp -rf "$PREFIX" "$INIT_DIR/rootfs/usr"

if [ -f "$PREFIX/../wine" ]; then
  cp -rf "$PREFIX/../wine" "$INIT_DIR/rootfs/wine"
fi

7z a "$HOME/$ROOTFS_PACKAGE.zip" "$INIT_DIR/rootfs"
