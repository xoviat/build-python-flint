#! /bin/sh

set -e -x

if [ -n "$IS_OSX" ]; then
    HOMEBREW_NO_AUTO_UPDATE=1 brew install homebrew/science/arb
else
    local PLATFORM_ARGS=--enable-fat
    
    wget http://mpir.org/mpir-2.7.0.tar.bz2
    tar -xf mpir-2.7.0.tar.bz2
    cd mpir-2.7.0
    ./configure --enable-gmpcompat --prefix=$BUILD_PREFIX --disable-static $PLATFORM_ARGS
    make -j4 > /dev/null 2>&1
    make install
    cd ..

    build_simple mpfr 3.1.4 http://www.mpfr.org/mpfr-3.1.4/
    build_simple flint 2.5.2 http://flintlib.org/

    wget https://github.com/fredrik-johansson/arb/archive/2.11.1.tar.gz
    tar -xf 2.11.1
    cd arb-2.11.1
    ./configure --prefix=$BUILD_PREFIX
    make -j4 > /dev/null 2>&1
    make install
    cd ..
fi

# Copy the flint headers
cp /usr/local/include/flint/*.h /usr/local/include
