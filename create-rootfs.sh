#!/bin/bash

symlink2sh() {
  for folder in $(find $1); do
    if [ -d "$folder" ]; then
      cd "$folder"

      for file in $(find $PWD); do
        target=$(readlink $file)

        if [ "$target" != "" ]; then
          rm "$file"

          echo "ln -sf $target $file" >> $1/generateSymlinks.sh
        fi
      done

      cd $OLDPWD
    fi
  done
}

export PREFIX=/data/data/com.micewine.emu/files/usr
export INITIAL_DIR=$PWD

if [ ! -e "$PREFIX" ]; then
  echo "$PREFIX: Don't Exist. Run 'build-all.sh' for generate the needed libs for creating a rootfs for MiceWine."
  exit
fi

# Convert symlinks to a .sh file that need to be executed after zip extract
symlink2sh $PREFIX

case $* in *"--clean-all"*)
  echo "Removing Static Libraries..."
  rm -f $PREFIX/lib/*.la
  rm -f $PREFIX/lib/*.a

  echo "Removing Generated Folders..."
  rm -rf $PREFIX/lib/{python*,cmake,pkgconfig}
  rm -rf $PREFIX/share/{cmake,aclocal,bash-completion,doc,info,man,util-macros,zsh}
  rm -rf $PREFIX/local
esac

case $* in *"--strip-all"*)
  echo "Stripping Libraries..."
  
  llvm-strip $PREFIX/lib/*.so*
esac

case $* in *"--strip-all"*|*"--clean-all"*)
  export ROOTFS_PACKAGE="MiceWine-RootFS-Stripped"
  ;;
  *)
  export ROOTFS_PACKAGE="MiceWine-RootFS"
esac

case $* in *"--no-zip"*)
  ;;
  *)
  7z a ~/$ROOTFS_PACKAGE.zip $PREFIX/..
esac
