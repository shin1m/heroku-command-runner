# Heroku Command Runner

A tiny tool which runs posted commands within a web dyno itself.

The post body to `http[s]://<name>.herokuapp.com` is redirected to the standard input of `bash -s`.
The standard output and the standard error are redirected to the response.
`/app/output/some-path` is mapped to `http[s]://<name>.herokuapp.com/some-path`.

**Caution**

This is just a toy.
It has no security considerations.
It can destroy itself by posting such commands.
I recommend either you implement security or you activate it only when needed.


## Background

Vulcan is deprecated.

This tool was written in order to build binaries instead of using Vulcan.


## Examples

Running `ls -la`:

    curl https://<name>.herokuapp.com -d 'ls -la'

Running a bash script:

    curl https://<name>.herokuapp.com --data-binary path-to-script

An example script to build gcc/g++ 4.8:

    HOME=`pwd`
    WORK=$HOME/work
    PREFIX=$WORK/target

    GCC_SOURCE=gcc-4.8.2
    GMP_SOURCE=gmp-6.0.0
    GMP_SUFFIX=a
    MPFR_SOURCE=mpfr-3.1.2
    MPC_SOURCE=mpc-1.0.2

    rm -rf $WORK
    mkdir $WORK || exit -1
    cd $WORK || exit -1

    curl -L http://www.netgull.com/gcc/releases/$GCC_SOURCE/$GCC_SOURCE.tar.bz2 -o $GCC_SOURCE.tar.bz2 || exit -1
    curl -L ftp://ftp.gnu.org/gnu/gmp/$GMP_SOURCE$GMP_SUFFIX.tar.bz2 -o $GMP_SOURCE$GMP_SUFFIX.tar.bz2 || exit -1
    curl -L http://www.mpfr.org/mpfr-current/$MPFR_SOURCE.tar.bz2 -o $MPFR_SOURCE.tar.bz2 || exit -1
    curl -L ftp://ftp.gnu.org/gnu/mpc/$MPC_SOURCE.tar.gz -o $MPC_SOURCE.tar.gz || exit -1

    bzcat $GCC_SOURCE.tar.bz2 | tar xvf - || exit -1
    bzcat $GMP_SOURCE$GMP_SUFFIX.tar.bz2 | tar xvf - || exit -1
    mv $GMP_SOURCE $GCC_SOURCE/gmp || exit -1
    bzcat $MPFR_SOURCE.tar.bz2 | tar xvf - || exit -1
    mv $MPFR_SOURCE $GCC_SOURCE/mpfr || exit -1
    zcat $MPC_SOURCE.tar.gz | tar xvf - || exit -1
    mv $MPC_SOURCE $GCC_SOURCE/mpc || exit -1

    mkdir gcc-build || exit -1
    cd gcc-build || exit -1
    ../$GCC_SOURCE/configure --prefix=$PREFIX --enable-languages=c,c++ --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --disable-libstdcxx-pch --disable-libspp --disable-multilib --disable-werror --enable-checking=no --disable-bootstrap || exit -1
    make || exit -1
    make install-strip || exit -1

    cd $WORK || exit -1
    tar cvf target.tar target || exit -1
    bzip2 target.tar || exit -1
    mkdir -p $HOME/output || exit -1
    mv target.tar.bz2 $HOME/output || exit -1


## License

The MIT License (MIT)

Copyright (c) 2014 Shin-ichi MORITA

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
