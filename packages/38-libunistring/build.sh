SRC_URL=https://mirrors.kernel.org/gnu/libunistring/libunistring-1.1.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE ac_cv_func_uselocale=no am_cv_langinfo_codeset=yes"
