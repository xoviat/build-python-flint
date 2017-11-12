# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    if [ -n "$IS_OSX" ]; then
        brew update
        brew install homebrew/science/arb
    else
        build_simple mpir 2.7.0 http://mpir.org/ tar.bz2 --disable-static --enable-fat --enable-gmpcompat
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
