set -ex

export DESTDIR="/"

if [[ $(uname) == Darwin ]]; then
  export PKG_CONFIG=$BUILD_PREFIX/bin/pkg-config
fi

if [ -z "$MESON_ARGS" ]; then
  # for some reason this is not set on Linux
  MESON_ARGS="--buildtype=release --prefix=${PREFIX} --libdir=lib"
fi

# _BSD_SOURCE must be set on old versions of Linux to expose some typedefs
export CPPFLAGS="-D_BSD_SOURCE=1 ${CPPFLAGS}"

meson setup builddir \
	 ${MESON_ARGS} \
	-Dopenssl=enabled \
	-Dgnutls=disabled
ninja -v -C builddir -j ${CPU_COUNT}
ninja -C builddir install -j ${CPU_COUNT}
