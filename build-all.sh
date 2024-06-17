#!/bin/bash
setupBuildEnv()
{
	if [ "$INIT_PATH" == "" ]; then
		INIT_PATH=$PATH
	fi

	if [ "$1" == "25b" ]; then
		export PATH=$INIT_PATH:$NDK_ROOT/25.2.9519653/toolchains/llvm/prebuilt/linux-x86_64/bin
	elif [ "$1" == "26b" ]; then
	  	export PATH=$INIT_PATH:$NDK_ROOT/26.1.10909125/toolchains/llvm/prebuilt/linux-x86_64/bin
	else
	  	exit
	fi

	export NDK_VERSION="$1"

	export ANDROID_SDK="$2"

	export ARCH="$3"

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

	export PKG_CONFIG_PATH=$PREFIX/share/pkgconfig:$PREFIX/lib/pkgconfig
	export PKG_CONFIG_LIBDIR=""

	if [ "$4" != "--silent" ]; then
		echo -e "NDK Version: $NDK_VERSION\nAndroid API: $ANDROID_SDK\nArchitecture: $ARCH"
	fi
}

applyPatches()
{
	PACKAGE=$1

	for patch in $(ls $INIT_DIR/packages/$PACKAGE/*.patch 2> /dev/null); do
		echo "Applying '$(basename $patch)' for '$PACKAGE'..."

		git apply "$patch"

		$RUN_POST_APPLY_PATCH

		printf "\n"
	done
}

downloadAndExtractPackage()
{
	URL=$1

	if [ "$2" == "" ]; then
		FILENAME=$(basename $SRC_URL)
	else
		FILENAME=$2
	fi

	if [ -e "$INIT_DIR/cache/$(basename $FILENAME)" ]; then 
		echo "Package '$package' already downloaded."
	else
		echo "Downloading '$package'..."
		curl --output "$INIT_DIR/cache/$FILENAME" -# -L -O $SRC_URL
	fi

	case "$(basename $FILENAME)" in *".tar"*)
		ARCHIVE_BASE_FOLDER=$(tar -tf "$INIT_DIR/cache/$(basename $FILENAME)" | cut -d "/" -f 1 | head -n 1)

		if [ ! -f "$ARCHIVE_BASE_FOLDER" ]; then
			tar -xf "$INIT_DIR/cache/$(basename $FILENAME)"
		fi
		;;
		*".zip"*)
		ARCHIVE_BASE_FOLDER=$(unzip -Z1 "$INIT_DIR/cache/$(basename $FILENAME)" | cut -d "/" -f 1 | head -n 1)

		if [ ! -f "$ARCHIVE_BASE_FOLDER" ]; then
			unzip -o "$INIT_DIR/cache/$(basename $FILENAME)" 1> /dev/null
		fi
	esac

	mv $ARCHIVE_BASE_FOLDER $package
}

gitDownload()
{
	URL=$1
	PACKAGE=$2

	git clone $URL $PACKAGE

	if [ "$GIT_COMMIT" != "" ]; then
		cd $PACKAGE

		rm -rf *

		git checkout $GIT_COMMIT .

		cd ..
	fi

	ARCHIVE_BASE_FOLDER=$package
}

setupPackages()
{
	mkdir -p "$PREFIX/include"

	mkdir -p "$INIT_DIR/cache"
	
	for package in $PACKAGES; do 
		if [ -e "$INIT_DIR/workdir/$package/build.sh" ]; then
			echo "Package '$package' already configured."
		else
			unset NON_CONVENTIONAL_BUILD_PATH GIT_URL SRC_URL CONFIGURE_ARGS MESON_ARGS CMAKE_ARGS USE_NDK_VERSION RUN_POST_APPLY_PATCH RUN_POST_BUILD RUN_POST_CONFIGURE CFLAGS CPPFLAGS LDFLAGS LIBS OVERRIDE_PREFIX OVERRIDE_PKG_CONFIG_PATH OVERRIDE_FILENAME CHECK_FOLDERS CHECK_FILES GIT_COMMIT

			. $INIT_DIR/packages/$package/build.sh

			if [ "$SRC_URL" != "" ]; then
				downloadAndExtractPackage $SRC_URL $OVERRIDE_FILENAME
			elif [ "$GIT_URL" != "" ]; then
				gitDownload $GIT_URL $package
			fi

			cd $package

			printf "\n"

			applyPatches $package

			echo "export CFLAGS=\"$CFLAGS\" LIBS=\"$LIBS\" CPPFLAGS=\"$CPPFLAGS\" LDFLAGS=\"$LDFLAGS\"" > build.sh

			if [ "$OVERRIDE_PREFIX" != "" ]; then
				PREFIX_DIR=$OVERRIDE_PREFIX
			else
				PREFIX_DIR=$PREFIX
			fi

			if [ "$OVERRIDE_PKG_CONFIG_PATH" != "" ]; then
				echo "export PKG_CONFIG_PATH=$OVERRIDE_PKG_CONFIG_PATH" >> build.sh
			else
				echo "export PKG_CONFIG_PATH=$PKG_CONFIG_PATH" >> build.sh
			fi

			if [ -e "./configure" ]; then
				echo "../configure --prefix=$PREFIX_DIR $CONFIGURE_ARGS" >> build.sh
				echo "$RUN_POST_CONFIGURE" >> build.sh
				if [ -e "$INIT_DIR/packages/$package/post-configure.sh" ]; then
					echo "$INIT_DIR/packages/$package/post-configure.sh" >> build.sh
				fi
				echo "make -j $(nproc)" >> build.sh
				echo "make -j $(nproc) install" >> build.sh
			elif [ -e "autogen.sh" ]; then
				echo "cd ..; ./autogen.sh; cd build_dir" >> build.sh
				echo "../configure --prefix=$PREFIX_DIR $CONFIGURE_ARGS" >> build.sh
				echo "$RUN_POST_CONFIGURE" >> build.sh
				if [ -e "$INIT_DIR/packages/$package/post-configure.sh" ]; then
					echo "$INIT_DIR/packages/$package/post-configure.sh" >> build.sh
				fi
				echo "make -j $(nproc)" >> build.sh
				echo "make -j $(nproc) install" >> build.sh
			elif [ -e ".$NON_CONVENTIONAL_BUILD_PATH/CMakeLists.txt" ]; then
				echo "cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_DIR -DCMAKE_INSTALL_LIBDIR=$PREFIX_DIR/lib $CMAKE_ARGS ..$NON_CONVENTIONAL_BUILD_PATH" >> build.sh
				echo "make -j $(nproc)" >> build.sh
				echo "make -j $(nproc) install" >> build.sh
			elif [ -e ".$NON_CONVENTIONAL_BUILD_PATH/meson.build" ]; then
				echo "meson setup -Dprefix=$PREFIX_DIR $MESON_ARGS ..$NON_CONVENTIONAL_BUILD_PATH" >> build.sh
				if [ -e "$INIT_DIR/packages/$package/post-configure.sh" ]; then
					echo "$INIT_DIR/packages/$package/post-configure.sh" >> build.sh
				fi
				echo "ninja -j $(nproc)" >> build.sh
				echo "ninja -j $(nproc) install" >> build.sh
			elif [ -e "Configure" ]; then
				echo "../Configure --prefix=$PREFIX_DIR $OPENSSL_FLAGS" >> build.sh
				if [ -e "$INIT_DIR/packages/$package/post-configure.sh" ]; then
					echo "$INIT_DIR/packages/$package/post-configure.sh" >> build.sh
				fi
				echo "make -j $(nproc)" >> build.sh
				echo "make -j $(nproc) install" >> build.sh
			elif [ -e "Makefile" ]; then
				echo "cd ..; make -j $(nproc) install; cd build_dir" >> build.sh
			else
				echo "Unsupported build system. Stopping..."
				exit 1
			fi

			if [ -e "$INIT_DIR/packages/$package/post-install.sh" ]; then
				echo "$INIT_DIR/packages/$package/post-install.sh" >> build.sh
			fi

			echo "setupBuildEnv $USE_NDK_VERSION 32 $ARCHITECTURE --silent" > setup-ndk.sh

			for i in $CHECK_FOLDERS; do
				echo -e "if [ ! -d "$i" ]; then echo Package: "'$i'" failed to compile. Check logs; exit 1; fi" >> check-build.sh
			done

			for i in $CHECK_FILES; do
				echo -e "if [ ! -f "$i" ]; then echo Package: "'$i'" failed to compile. Check logs; exit 1; fi" >> check-build.sh
			done

			echo 'echo $? > exit_code' >> build.sh

			chmod +x build.sh

			cd ..
		fi
	done
}

compileAll()
{
	echo -e "\n-- Starting Building --\n"

	for i in $(ls); do
		mkdir -p "$i/build_dir"

		cd "$i/build_dir"

		touch exit_code

		if [ "$(cat exit_code)" == "0" ]; then
			echo "Package '$i' already compiled."
		else
			echo "Compiling Package '$i'..."

			. ../setup-ndk.sh

			../build.sh 1> "$INIT_DIR/logs/$i-log.txt" 2> "$INIT_DIR/logs/$i-error_log.txt"

			if [ "$(cat exit_code)" != "0" ]; then
				echo "Package: '"$i"' failed to compile. Check logs"
				exit 0
			fi
	 
			if [ -f "../check-build.sh" ]; then
				. ../check-build.sh
			fi
		fi

		cd ../..
	done
}

export PREFIX=/data/data/com.micewine.emu/files/usr

case $1 in "aarch64"|"x86_64")
	export ARCHITECTURE=$1
	;;
	"")
	echo "Error: No Architecture Specified."
	echo "Usage: $0 {Architecture}"
	echo "Available Architectures: 'x86_64', 'aarch64'"
	exit 1
	;;
	*)
	echo "Error: Invalid Architecture Specified."
	echo "Usage: $0 {Architecture}"
	echo "Available Architectures: 'x86_64', 'aarch64'"
	exit
esac

if [ "$NDK_ROOT" == "" ] && [ "$*" != "--download-only" ]; then
	echo "Please Provide a Valid Folder with NDK 25b and 26b on 'NDK_ROOT' environment variable."
	exit
fi

if [ "$*" != "--download-only" ]; then
	if [ ! -e "$PREFIX" ]; then
		sudo mkdir -p "$PREFIX"
		sudo chown -R $(whoami):$(whoami) "$PREFIX"
		sudo chmod 755 -R "$PREFIX"
	else
		case $* in *"--clean-prefix"*)
			echo "Cleaning Prefix..."

			rm -rf $PREFIX/*
		esac
	fi
else
	echo "This script will download packages only."
fi

case $* in *"--clean-cache"*)
	echo "Cleaning Cache..."

	rm -rf cache
esac

case $* in *"--clean-workdir"*)
	echo "Cleaning Workdir..."

	rm -rf workdir
esac

if [ -e "logs" ] && [ "$*" != "--download-only" ]; then
	echo "Cleaning logs..."
	rm -rf logs
fi

export PACKAGES=$(ls packages)

export INIT_DIR=$PWD

export INIT_PATH=$PATH

setupBuildEnv 26b 32 $ARCHITECTURE --silent

mkdir -p logs

mkdir -p workdir

cd workdir

setupPackages

if [ "$*" != "--download-only" ]; then
	compileAll

	# Copy libc++_shared.so from NDK
	cp $NDK_ROOT/26.1.10909125/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/$ARCHITECTURE-linux-android/libc++_shared.so $PREFIX/lib

	# Set RPath for not need set env LD_LIBRARY_PATH
	for i in $(ls $PREFIX/bin); do
		if [ ! -f "$i" ]; then
			patchelf --set-rpath $PREFIX/lib $PREFIX/bin/$i
		fi
	done

	for i in $(ls $PREFIX/lib); do
		if [ "$i" == *".so"* ]; then
			patchelf --set-rpath $PREFIX/lib $PREFIX/lib/$i
		fi
	done
fi
