#!/bin/bash

symlink2hardlink() {
  for i in *; do
    link=$(readlink $i)
    if [ "$link" != "" ]; then
      rm $i
      ln -f $link $i
    fi 
  done
}

export PREFIX=/data/data/com.micewine.emu/files/usr

if [ ! -e "$PREFIX" ]; then
  echo "$PREFIX: Don't Exist. Run 'build-all.sh' for generate the needed libs for creating a rootfs for MiceWine."
  exit
fi

cd $PREFIX/lib

symlink2hardlink

cd $PREFIX/..

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

case $* in *"--no-save-zip"*)
  ;;
  *"--strip-all"*|*"--clean-all"*)
  7z a ~/MiceWine-RootFS-Stripped.zip
  ;;
  *)
  7z a ~/MiceWine-RootFS.zip
esac

echo "RootFS Saved on $HOME."
