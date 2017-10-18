# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function build_github {
    # Example: build_github fredrik-johansson/arb 2.11.1
    local path=$1
    local version=$2
    local configure_args=${@:3}
    local name=`basename "$path"`
    local name_version="${name}-${version}"
    if [ -e "${name}-stamp" ]; then
        return
    fi
    fetch_unpack "https://github.com/${path}/archive/${version}.tar.gz"
    ls -r .
    (cd $name_version \
        && ./configure --prefix=$BUILD_PREFIX $configure_args \
        && make \
        && make install)
    touch "${name}-stamp"
}

function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    if [ -n "$IS_OSX" ]; then
        HOMEBREW_NO_AUTO_UPDATE=1 brew install homebrew/science/arb
    else
        wget http://mpir.org/mpir-2.7.0.tar.bz2
        tar -xf mpir-2.7.0.tar.bz2
        cd mpir-2.7.0
        ./configure --enable-gmpcompat --prefix=$BUILD_PREFIX --disable-static --enable-fat
        make -j4 > /dev/null 2>&1
        make install
        cd ..

        build_simple mpfr 3.1.4 http://www.mpfr.org/mpfr-3.1.4/
        build_simple flint 2.5.2 http://flintlib.org/
        build_github fredrik-johansson/arb 2.11.1
    fi

    # Copy the flint headers
    cp /usr/local/include/flint/*.h /usr/local/include
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    :
}
