PKG_VER=0.24
SRC_URL=https://mirrors.kernel.org/gnu/gettext/gettext-$PKG_VER.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE ac_cv_have_decl_posix_spawn=no ac_cv_header_spawn_h=no gl_cv_func_working_error=yes gl_cv_terminfo_tparm=yes --disable-openmp --without-included-libcroco --without-included-libglib --without-included-libxml"
