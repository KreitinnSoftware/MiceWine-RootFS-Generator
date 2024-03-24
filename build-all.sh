#!/bin/bash
setupBuildEnv()
{
	case $1 in "25b")
		export PATH=$INIT_PATH:$NDK_ROOT/25.2.9519653/toolchains/llvm/prebuilt/linux-x86_64/bin
	  	;;
	  	"26b")
	  	export PATH=$INIT_PATH:$NDK_ROOT/26.1.10909125/toolchains/llvm/prebuilt/linux-x86_64/bin
	  	;;
	  	*)
	  	exit
	esac

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

	export PKG_CONFIG_PATH=/data/data/com.micewine.emu/files/usr/share/pkgconfig:/data/data/com.micewine.emu/files/usr/lib/pkgconfig
	export PKG_CONFIG_LIBDIR=""

	if [ "$4" != "--silent" ]; then
		echo -e "NDK Version: $NDK_VERSION\nAndroid API: $ANDROID_SDK\nArchitecture: $ARCH"
	fi
}

downloadPackages()
{
	mkdir -p $PREFIX/include
	
	for package in $PACKAGES; do 
		unset SRC_URL CONFIGURE_ARGS MESON_ARGS CMAKE_ARGS USE_NDK_VERSION RUN_POST_APPLY_PATCH RUN_POST_BUILD CFLAGS CPPFLAGS LDFLAGS LIBS OVERRIDE_PREFIX OVERRIDE_PKG_CONFIG_PATH OVERRIDE_FILENAME CHECK_FOLDERS CHECK_FILES

		. $INIT_DIR/packages/$package/build.sh

		mkdir -p "$INIT_DIR/cache"

		if [ "$OVERRIDE_FILENAME" != "" ]; then
			if [ -e "$INIT_DIR/cache/$(basename $OVERRIDE_FILENAME)" ]; then
				echo "Package '$package' already downloaded."
			else
				echo "Downloading '$package'..."
				curl --output "$INIT_DIR/cache/$OVERRIDE_FILENAME" -# -L -O $SRC_URL
			fi

			case "$(basename $OVERRIDE_FILENAME)" in *".tar"*)
				tar -xf "$INIT_DIR/cache/$(basename $OVERRIDE_FILENAME)"

				ARCHIVE_CONTENT=$(tar -tf "$INIT_DIR/cache/$(basename $OVERRIDE_FILENAME)")
				;;
				*".zip"*)
				unzip -o "$INIT_DIR/cache/$(basename $OVERRIDE_FILENAME)" 1> /dev/null

				ARCHIVE_CONTENT=$(unzip -Z1 "$INIT_DIR/cache/$(basename $OVERRIDE_FILENAME)")
			esac
		else
			if [ -e "$INIT_DIR/cache/$(basename $SRC_URL)" ]; then
				echo "Package '$package' already downloaded."
			else
				echo "Downloading '$package'..."
				curl --output-dir "$INIT_DIR/cache" -# -L -O $SRC_URL
			fi

			case "$(basename $SRC_URL)" in *".tar"*)
				tar -xf "$INIT_DIR/cache/$(basename $SRC_URL)"

				ARCHIVE_CONTENT=$(tar -tf "$INIT_DIR/cache/$(basename $SRC_URL)")
				;;
				*".zip"*)
				unzip -o "$INIT_DIR/cache/$(basename $SRC_URL)" 1> /dev/null

				ARCHIVE_CONTENT=$(unzip -Z1 "$INIT_DIR/cache/$(basename $SRC_URL)")
			esac
		fi

		cd $(echo $ARCHIVE_CONTENT | cut -d"/" -f 1 | head -n 1)

		echo

		case $(ls $INIT_DIR/packages/$package | grep "patch") in "")
			;;
			*)
			for patch in $(ls $INIT_DIR/packages/$package/*.patch); do
				echo "Applying '$patch' for '$package'..."
				git apply -v "$patch"

				if [ "$RUN_POST_APPLY_PATCH" != "" ]; then
					$RUN_POST_APPLY_PATCH
				fi
				echo
			done
		esac

		echo "export CFLAGS=$CFLAGS LIBS=$LIBS CPPFLAGS=$CPPFLAGS LDFLAGS=$LDFLAGS" > build.sh

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

		if [ -e "configure" ]; then
			echo "../configure --prefix=$PREFIX_DIR $CONFIGURE_ARGS" >> build.sh
			echo "make -j $(nproc) install" >> build.sh
		elif [ -e "autogen.sh" ]; then
			echo "../autogen.sh" >> build.sh
			echo "../configure --prefix=$PREFIX_DIR $CONFIGURE_ARGS" >> build.sh
			echo "make -j $(nproc) install" >> build.sh
		elif [ -e "CMakeLists.txt" ]; then
			echo "cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_DIR -DCMAKE_INSTALL_LIBDIR=$PREFIX_DIR/lib $CMAKE_ARGS .." >> build.sh
			echo "make -j $(nproc) install" >> build.sh
		elif [ -e "meson.build" ]; then
			echo "meson setup -Dprefix=$PREFIX_DIR $MESON_ARGS .." >> build.sh
			echo "ninja -j $(nproc) install" >> build.sh
		elif [ -e "Configure" ]; then
			echo "../Configure --prefix=$PREFIX_DIR $OPENSSL_FLAGS" >> build.sh
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

		chmod +x build.sh

		cd ..

		mv $(echo $ARCHIVE_CONTENT | cut -d"/" -f 1 | head -n 1) $package
	done
}

compileAll()
{
	for i in $(ls); do
		mkdir -p "$i/build_dir"

		cd "$i/build_dir"

		echo "Compiling Package '$i'..."

		. ../setup-ndk.sh

		../build.sh 1> "$INIT_DIR/logs/$i-log.txt" 2> "$INIT_DIR/logs/$i-error_log.txt"

		if [ $? -ne 0 ]; then
			echo "Package: '"$i"' failed to compile. Check logs"
			exit 2
		fi
 
		if [ -f "../check-build.sh" ]; then
			. ../check-build.sh
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
		echo "Cleaning Prefix..."

		rm -rf $PREFIX/*
	fi
else
	echo "This script will download packages only."
fi

if [ "$*" == "--clean-cache" ]; then
	echo "Cleaning Cache..."

	rm -rf cache
fi

if [ -e "workdir" ]; then
	echo "Cleaning Workdir..."
	rm -rf workdir
fi

if [ -e "logs" ] && [ "$*" != "--download-only" ]; then
	echo "Cleaning logs..."
	rm -rf logs
fi

export PACKAGES=$(ls packages)

export INIT_DIR=$PWD

export INIT_PATH=$PATH

if [ "$*" != "--download-only" ]; then
	setupBuildEnv 26b 32 $ARCHITECTURE --silent
fi

mkdir -p logs

mkdir -p workdir

cd workdir

downloadPackages

if [ "$*" != "--download-only" ]; then
	compileAll

	# Copy libc++_shared.so from NDK
	cp $NDK_ROOT/26.1.10909125/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/$ARCHITECTURE-linux-android/libc++_shared.so $PREFIX/lib

	# Copy VirGL Renderer and Wine Start Script
	cp $INIT_DIR/start-wine.sh $PREFIX/bin
	cp $INIT_DIR/start-virglrenderer.sh $PREFIX/bin

	# DNS Resolver File
	printf "127.0.0.1 localhost\n::1 ip6-localhost\n" > $PREFIX/etc/hosts
	printf "nameserver 8.8.8.8\nnameserver 8.8.4.4\n" > $PREFIX/etc/resolv.conf
fi
