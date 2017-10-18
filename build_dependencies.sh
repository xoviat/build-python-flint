#! /bin/sh

set -e -x

if [ -n "$IS_OSX" ]; then
    brew update
    brew install gcc homebrew/science/arb
    export CC=gcc
    export CXX=gcc
else
    local PLATFORM_ARGS=--enable-fat
    
    wget http://mpir.org/mpir-2.7.0.tar.bz2
    tar -xf mpir-2.7.0.tar.bz2
    cd mpir-2.7.0
    ./configure --enable-gmpcompat --prefix=$BUILD_PREFIX --disable-static $PLATFORM_ARGS
    make -j4 > /dev/null 2>&1
    make install
    cd ..

    wget http://www.mpfr.org/mpfr-3.1.4/mpfr-3.1.4.tar.bz2
    tar -xf mpfr-3.1.4.tar.bz2
    cd mpfr-3.1.4
    ./configure --prefix=$BUILD_PREFIX --disable-static $PLATFORM_ARGS
    make -j4 > /dev/null 2>&1
    make install
    cd ..

    wget http://flintlib.org/flint-2.5.2.tar.gz
    tar -xf flint-2.5.2.tar.gz
    cd flint-2.5.2
    ./configure --prefix=$BUILD_PREFIX --disable-static
    make -j4 > /dev/null 2>&1
    make install
    cd ..

    cd arb
    ./configure --prefix=$BUILD_PREFIX
    make -j4
    make install
    cd ..
    
fi

# Copy the flint headers
cp /usr/local/include/flint/*.h /usr/local/include
