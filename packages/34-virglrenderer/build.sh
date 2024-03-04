SRC_URL=https://gitlab.freedesktop.org/virgl/virglrenderer/-/archive/virglrenderer-0.10.4/virglrenderer-virglrenderer-0.10.4.tar.gz
MESON_ARGS="--cross-file=../../../meson-cross-file-aarch64 --libdir lib -Degl_without_gbm=true -Dplatforms=egl"
USE_NDK_VERSION=26b