#!/bin/sh -eux

if [ -z "$PREFIX" ]; then
	PREFIX=`opam config var prefix`
fi

PKG_CONFIG_DEPS="gmp-xen mirage-xen-posix"
function check_deps {
  pkg-config --print-errors --exists ${PKG_CONFIG_DEPS}
}

if ! check_deps 2>/dev/null; then
	PKG_CONFIG_PATH="`opam config var prefix`/lib/pkgconfig"
	export PKG_CONFIG_PATH
fi
check_deps || exit 1

LDFLAGS=`pkg-config --libs gmp-xen`
export LDFLAGS

# WARNING: if you pass invalid cflags here, zarith will silently
# fall back to compiling with the default flags instead!
CFLAGS="`pkg-config --cflags gmp-xen mirage-xen-posix` -O2 -pedantic -fomit-frame-pointer -fno-builtin"
export CFLAGS
./configure
make
mkdir -p "$PREFIX/lib/zarith" # err, REALLY?
cp libzarith.a "$PREFIX/lib/zarith/libzarith-xen.a"
mv "$PREFIX/lib/zarith/META" "$PREFIX/lib/zarith/META.old"
cp META "$PREFIX/lib/zarith/META"
