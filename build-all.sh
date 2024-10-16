#!/bin/bash
setupBuildEnv()
{
	if [ "$INIT_PATH" == "" ]; then
		INIT_PATH=$PATH
	fi

	if [ ! -d "$INIT_DIR/cache/android-ndk-r26b" ]; then
		echo "Downloading NDK R26b..."

		curl --output "$INIT_DIR/cache/android-ndk-r26b.zip" -# -L https://dl.google.com/android/repository/android-ndk-r26b-linux.zip

		echo "Unpacking NDK R26b..."

		7z x "$INIT_DIR/cache/android-ndk-r26b.zip" -o"$INIT_DIR/cache" &> /dev/null

		rm -f "$INIT_DIR/cache/android-ndk-r26b.zip"

		echo ""
	fi

	if [ ! -d "$INIT_DIR/cache/llvm-mingw-20240619-ucrt-ubuntu-20.04-x86_64" ]; then
		echo "Downloading llvm-mingw..."

		curl --output "$INIT_DIR/cache/llvm-mingw-20240619-ucrt-ubuntu-20.04-x86_64.tar.xz" -# -L https://github.com/mstorsjo/llvm-mingw/releases/download/20240619/llvm-mingw-20240619-ucrt-ubuntu-20.04-x86_64.tar.xz

		echo "Unpacking llvm-mingw..."

		cd "$INIT_DIR/cache"

		tar -xf "$INIT_DIR/cache/llvm-mingw-20240619-ucrt-ubuntu-20.04-x86_64.tar.xz"

		cd "$OLDPWD"

		rm -f "$INIT_DIR/cache/llvm-mingw-20240619-ucrt-ubuntu-20.04-x86_64.tar.xz"

		echo ""
	fi

	export PATH=$INIT_PATH:$INIT_DIR/cache/android-ndk-r26b/toolchains/llvm/prebuilt/linux-x86_64/bin:$INIT_DIR/cache/llvm-mingw-20240619-ucrt-ubuntu-20.04-x86_64/bin
	export ANDROID_SDK="$1"
	export ARCH="$2"

	if [ "$ARCH" == "i686" ]; then
		export CC=i686-linux-android$ANDROID_SDK-clang
		export CXX=i686-linux-android$ANDROID_SDK-clang++
		export TOOLCHAIN_VERSION="x86-4.9"
		export TOOLCHAIN_TRIPLE="i686-linux-android"
	elif [ "$ARCH" == "x86_64" ]; then
		export CC=x86_64-linux-android$ANDROID_SDK-clang
		export CXX=x86_64-linux-android$ANDROID_SDK-clang++
		export TOOLCHAIN_VERSION="x86_64-4.9"
		export TOOLCHAIN_TRIPLE="x86_64-linux-android"
	elif [ "$ARCH" == "armeabi-v7a" ]; then
		export CC=armv7a-linux-androideabi$ANDROID_SDK-clang
		export CXX=armv7a-linux-androideabi$ANDROID_SDK-clang++
		export TOOLCHAIN_VERSION="arm-linux-androideabi-4.9"
		export TOOLCHAIN_TRIPLE="arm-linux-androideabi"
	elif [ "$ARCH" == "aarch64" ]; then
		export CC=aarch64-linux-android$ANDROID_SDK-clang
		export CXX=aarch64-linux-android$ANDROID_SDK-clang++
		export TOOLCHAIN_VERSION="aarch64-linux-android-4.9"
		export TOOLCHAIN_TRIPLE="aarch64-linux-android"
	fi

	export PKG_CONFIG_PATH="$PREFIX/share/pkgconfig:$PREFIX/lib/pkgconfig"
	export PKG_CONFIG_LIBDIR="$PREFIX/lib/pkgconfig"
}

applyPatches()
{
	for patch in $(find $INIT_DIR/packages/$package -name "*.patch"); do
		echo "- Applying '$(basename $patch)' for '$package'..."

		patch -p1 < "$patch" -ts

		if [ $? != 0 ]; then
			echo "- Error on Applying Patch '$(basename $patch)' on '$package'"

			exit
		fi
	done

	echo ""

	$RUN_POST_APPLY_PATCH
}

downloadAndExtractPackage()
{
	if [ -e "$INIT_DIR/cache/$package" ]; then
		echo "-- Package '$package' already downloaded."
	else
		echo "-- Downloading '$package'..."
		curl --output "$INIT_DIR/cache/$package" -# -L $SRC_URL
	fi

	local ARCHIVE_MIME_TYPE=$(file -b --mime-type $INIT_DIR/cache/$package)

	case $ARCHIVE_MIME_TYPE in "application/x-xz"|"application/gzip"|"application/x-bzip2")
		ARCHIVE_BASE_FOLDER=$(tar -tf "$INIT_DIR/cache/$package" | cut -d "/" -f 1 | head -n 1)

		if [ ! -f "$ARCHIVE_BASE_FOLDER" ]; then
			tar -xf "$INIT_DIR/cache/$package"
		fi
		;;
		*)
		ARCHIVE_BASE_FOLDER=$(unzip -Z1 "$INIT_DIR/cache/$package" | cut -d "/" -f 1 | head -n 1)

		if [ ! -f "$ARCHIVE_BASE_FOLDER" ]; then
			unzip -o "$INIT_DIR/cache/$package" 1> /dev/null
		fi
	esac

	mv $ARCHIVE_BASE_FOLDER $package
}

gitDownload()
{
	if [ -d "$INIT_DIR/cache/$package" ]; then
		echo "-- Package '$package' already downloaded."

		git clone "$INIT_DIR/cache/$package" &> /dev/zero
	else
		echo "-- Git Cloning '$package'..."

		git clone --no-checkout $GIT_URL "$INIT_DIR/cache/$package" &> /dev/zero
		git clone "$INIT_DIR/cache/$package" &> /dev/zero
	fi

	cd $package

	if [ -n "$GIT_COMMIT" ]; then
		git checkout $GIT_COMMIT &> /dev/zero
	fi

	git checkout . &> /dev/zero
	git submodule update --init --recursive &> /dev/zero

	if [ "$PKG_VER" == "[gss]" ]; then
		PKG_VER=$(git rev-parse --short HEAD)
	fi

	cd ..
}

setupPackages()
{
	cd "$INIT_DIR/workdir"

	mkdir -p "$PREFIX/include"
	
	for package in $PACKAGES; do
		unset NON_CONVENTIONAL_BUILD_PATH PKG_VER GIT_URL SRC_URL HOST_BUILD_FOLDER HOST_BUILD_MAKE HOST_BUILD_CONFIGURE_ARGS HOST_BUILD_CFLAGS HOST_BUILD_CXXFLAGS HOST_BUILD_LDFLAGS CONFIGURE_ARGS MESON_ARGS CMAKE_ARGS RUN_POST_APPLY_PATCH RUN_POST_BUILD RUN_POST_CONFIGURE CFLAGS CPPFLAGS LDFLAGS LIBS OVERRIDE_PREFIX OVERRIDE_PKG_CONFIG_PATH GIT_COMMIT BLACKLIST_ARCHITECTURE

		. "$INIT_DIR/packages/$package/build.sh"

		if [ "$PKG_VER" == "[gss]" ]; then
			if [ -n "$GIT_COMMIT" ]; then
				PKG_VER="$(echo $GIT_COMMIT | cut -c1-7)"
			fi
		fi

		if [ -f "$INIT_DIR/built-pkgs/$package-$PKG_VER-$ARCHITECTURE.zip" ]; then
			echo "-- Package '$package' already built, No configuring necessary."
		else
			if [ -e "$INIT_DIR/workdir/$package/build.sh" ]; then
				echo "-- Package '$package' already configured."
			else
				if [ "$BLACKLIST_ARCHITECTURE" == "$ARCHITECTURE" ]; then
					echo "-- Warning: '$package' will not be built."
				else
					if [ -n "$SRC_URL" ]; then
						downloadAndExtractPackage
					elif [ -n "$GIT_URL" ]; then
						gitDownload
					fi

					cd $package

					applyPatches

					if [ $EXPERIMENTAL_16KB_PAGESIZE -eq 1 ]; then
						LDFLAGS+=" -Wl,-z,max-page-size=16384"
					fi

					echo "export CFLAGS=\"$CFLAGS\" LIBS=\"$LIBS\" CPPFLAGS=\"$CPPFLAGS\" LDFLAGS=\"$LDFLAGS\"" > build.sh
					echo "export DESTDIR=\"$INIT_DIR/workdir/$package/destdir-pkg\"" >> build.sh

					if [ -n "$OVERRIDE_PREFIX" ]; then
						PREFIX_DIR=$OVERRIDE_PREFIX
					else
						PREFIX_DIR=$PREFIX
					fi

					if [ "$OVERRIDE_PKG_CONFIG_PATH" != "" ]; then
						echo "export PKG_CONFIG_PATH=$OVERRIDE_PKG_CONFIG_PATH" >> build.sh
					else
						echo "export PKG_CONFIG_PATH=$PKG_CONFIG_PATH" >> build.sh
					fi

					if [ -e "./configure" ] && [ -n "$CONFIGURE_ARGS" ]; then
						if [ -n "$HOST_BUILD_CONFIGURE_ARGS" ]; then
							echo "mkdir -p $HOST_BUILD_FOLDER" >> build.sh
							echo "cd $HOST_BUILD_FOLDER" >> build.sh
							echo "env -i bash -l -c \"../configure $HOST_BUILD_CONFIGURE_ARGS\"" >> build.sh
							echo "$HOST_BUILD_MAKE" >> build.sh
							echo 'cd $OLDPWD' >> build.sh
						fi

						echo "../configure --libdir=$PREFIX_DIR/lib --prefix=$PREFIX_DIR $CONFIGURE_ARGS" >> build.sh
						echo "$RUN_POST_CONFIGURE" >> build.sh

						if [ -e "$INIT_DIR/packages/$package/post-configure.sh" ]; then
							echo "$INIT_DIR/packages/$package/post-configure.sh" >> build.sh
						fi

						echo "make -j $(nproc)" >> build.sh

						if [ -e "$INIT_DIR/packages/$package/custom-make-install.sh" ]; then
							echo "$INIT_DIR/packages/$package/custom-make-install.sh" >> build.sh
						else
							echo "make -j $(nproc) install" >> build.sh
						fi
					elif [ -e "autogen.sh" ] && [ -n "$CONFIGURE_ARGS" ]; then
						echo "cd .." >> build.sh
						echo "./autogen.sh" >> build.sh
						echo "cd build_dir" >> build.sh
						echo "../configure --libdir=$PREFIX_DIR/lib --prefix=$PREFIX_DIR $CONFIGURE_ARGS" >> build.sh
						echo "$RUN_POST_CONFIGURE" >> build.sh

						if [ -e "$INIT_DIR/packages/$package/post-configure.sh" ]; then
							echo "$INIT_DIR/packages/$package/post-configure.sh" >> build.sh
						fi

						echo "make -j $(nproc)" >> build.sh

						if [ -e "$INIT_DIR/packages/$package/custom-make-install.sh" ]; then
							echo "$INIT_DIR/packages/$package/custom-make-install.sh" >> build.sh
						else
							echo "make -j $(nproc) install" >> build.sh
						fi
					elif [ -e ".$NON_CONVENTIONAL_BUILD_PATH/CMakeLists.txt" ] && [ -n "$CMAKE_ARGS" ]; then
						echo "cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_DIR -DCMAKE_INSTALL_LIBDIR=$PREFIX_DIR/lib $CMAKE_ARGS ..$NON_CONVENTIONAL_BUILD_PATH" >> build.sh
						echo "make -j $(nproc)" >> build.sh

						if [ -e "$INIT_DIR/packages/$package/custom-make-install.sh" ]; then
							echo "$INIT_DIR/packages/$package/custom-make-install.sh" >> build.sh
						else
							echo "make -j $(nproc) install" >> build.sh
						fi
					elif [ -e ".$NON_CONVENTIONAL_BUILD_PATH/meson.build" ] && [ -n "$MESON_ARGS" ]; then
						echo "meson setup -Dbuildtype=debug -Dprefix=$PREFIX_DIR $MESON_ARGS ..$NON_CONVENTIONAL_BUILD_PATH" >> build.sh

						if [ -e "$INIT_DIR/packages/$package/post-configure.sh" ]; then
							echo "$INIT_DIR/packages/$package/post-configure.sh" >> build.sh
						fi

						echo "ninja -j $(nproc)" >> build.sh

						if [ -e "$INIT_DIR/packages/$package/custom-make-install.sh" ]; then
							echo "$INIT_DIR/packages/$package/custom-make-install.sh" >> build.sh
						else
							echo "ninja -j $(nproc) install" >> build.sh
						fi
					elif [ -e "Configure" ] && [ -n "$OPENSSL_FLAGS" ]; then
						echo "../Configure --prefix=$PREFIX_DIR $OPENSSL_FLAGS" >> build.sh

						if [ -e "$INIT_DIR/packages/$package/post-configure.sh" ]; then
							echo "$INIT_DIR/packages/$package/post-configure.sh" >> build.sh
						fi

						echo "make -j $(nproc)" >> build.sh
						echo "make -j $(nproc) DESTDIR=\"\$DESTDIR\" install_sw" >> build.sh
					elif [ -e "Makefile" ]; then
						echo "cd .." >> build.sh
						echo "make -j $(nproc) install" >> build.sh
						echo "cd build_dir" >> build.sh
					else
						echo "Unsupported build system. Stopping..."
						exit 1
					fi

					if [ -e "$INIT_DIR/packages/$package/post-install.sh" ]; then
						echo "$INIT_DIR/packages/$package/post-install.sh" >> build.sh
					fi

					echo 'echo $? > exit_code' >> build.sh
					echo $PKG_VER >> pkg-ver

					chmod +x build.sh

					cd ..
				fi
			fi
		fi
	done
}

installBuiltPackagesOnEnv()
{
	if [ -n "$(ls "$INIT_DIR/built-pkgs")" ]; then
		echo ""
		echo "-- Installing All Built Packages on Environment --"
		echo ""

		for package in $(find "$INIT_DIR/built-pkgs" -name "*$ARCHITECTURE*"); do
			echo "-- Installing '$(basename $package .zip)'"
			unzip -o "$package" -d / &> /dev/zero
		done

		echo "-- Done"
	fi
}

compileAll()
{
	echo ""
	echo "-- Starting Building --"

	for package in $(ls "$INIT_DIR/workdir"); do
		mkdir -p "$INIT_DIR/workdir/$package/build_dir"
		mkdir -p "$INIT_DIR/workdir/$package/destdir-pkg"

		cd "$INIT_DIR/workdir/$package/build_dir"

		touch exit_code

		pkgVersion="$(cat ../pkg-ver)"

		if [ -f "$INIT_DIR/built-pkgs/$package-$pkgVersion-$ARCHITECTURE.zip" ]; then
			echo "-- Package '$package' already built."
		else
			echo ""
			echo "-- Compiling Package '$package'..."

			../build.sh 1> "$INIT_DIR/logs/$package-log.txt" 2> "$INIT_DIR/logs/$package-error_log.txt"

			if [ "$?" != "0" ]; then
				echo "- Package: '"$package"' failed to compile. Check logs"
				exit 0
			fi

			if [ ! -d "$INIT_DIR/workdir/$package/destdir-pkg/data/data/com.micewine.emu" ]; then
				echo "- Package: '"$package"' failed to compile. Check logs"
				exit 0
			fi

			cp -rf "$INIT_DIR/workdir/$package/destdir-pkg/data/data/com.micewine.emu/"* "/data/data/com.micewine.emu"

   			find "$INIT_DIR/workdir/$package/destdir-pkg" > "$INIT_DIR/logs/$package-package-files.txt"

			echo "-- Packaging Package '$package'..."

			cd "$INIT_DIR/workdir/$package/destdir-pkg"

			7z a "$INIT_DIR/built-pkgs/$package-$pkgVersion-$ARCHITECTURE.zip" &> /dev/zero
		fi
	done
}

showHelp()
{
	echo "Usage: $0 ARCHITECTURE [OPTIONS]"
	echo ""
	echo "Options:"
	echo "	--help: Show this message and exit."
	echo "	--clean-prefix: Clean generated rootfs."
	echo "	--clean-workdir: Clean workdir (for a clean compiling)."
	echo "	--clean-cache: Clean cache of downloaded packages."
	echo "  --16kb: Compile with experimental support for Android 15 with 16kb pagesizes"
	echo ""
	echo "Available Architectures:"
	echo "	x86_64"
	echo "	aarch64"
}

export PREFIX=/data/data/com.micewine.emu/files/usr

if [ -n "$1" ]; then
	case $1 in "aarch64"|"x86_64")
		export ARCHITECTURE=$1
		;;
		"--help")
		showHelp
		exit
		;;
		*)
		echo "Error: Invalid Architecture Specified."
		echo ""
		showHelp
		exit
	esac
else
	showHelp
	exit 1
fi

if [ ! -e "$PREFIX" ]; then
	sudo mkdir -p "$PREFIX"
	sudo chown -R $(whoami):$(whoami) "$PREFIX/../.."
	sudo chmod 755 -R "$PREFIX/../.."
else
	case $* in *"--clean-prefix"*)
		echo "Cleaning Prefix..."

		rm -rf $PREFIX/*
	esac
fi

case $* in "--clean-cache")
	rm -rf cache
esac

case $* in "--clean-workdir")
	rm -rf workdir
esac

case $* in "--16kb")
	echo "Warning: Compiling MiceWine RootFS with experimental support to 16kb pagesizes, Work is not garanted"
	echo ""

	export EXPERIMENTAL_16KB_PAGESIZE=1
esac

rm -rf logs

export PACKAGES="$(ls packages)"
export INIT_DIR="$PWD"
export INIT_PATH="$PATH"

mkdir -p $INIT_DIR/{workdir,logs,cache,built-pkgs}

installBuiltPackagesOnEnv
setupBuildEnv 32 $ARCHITECTURE
setupPackages

compileAll

cp $INIT_DIR/cache/android-ndk-r26b/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/$ARCHITECTURE-linux-android/libc++_shared.so $PREFIX/lib
