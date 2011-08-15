#!/usr/bin/env bash
set -e

# options
export GCC_LANGUAGES="c,c++,lto,fortran,objc,obj-c++,ada" #java
export BUILD_CORES=2 #used as argument for "make -jn"
export SHARED='--disable-static --enable-shared'
export STATIC='--enable-static --disable-shared'
export GNU_MULTILIB='--disable-multilib' #'--enable-multilib --enable-targets=i686-w64-mingw32,x86_64-w64-mingw32'
export GNU_EXTRA_OPTIONS='--disable-nls --disable-werror --enable-lto' #--enable-libgcj

# directories: SRC_DIR contains full source package.
export TOP_DIR=`pwd`
export SRC_DIR=$TOP_DIR/src
export BUILD_DIR=$TOP_DIR/$SHORT_NAME
export LOG_DIR=$BUILD_DIR/logs
export GCC_LIBS=$BUILD_DIR/libs
export GRAPHITE_LIBS="--with-ppl=$GCC_LIBS --with-cloog=$GCC_LIBS --enable-cloog-backend=isl"
export SCRIPTS=$TOP_DIR/scripts

    export GCC_SRC=$SRC_DIR/gcc
    export GCC_PREREQUISITES="--with-libiconv-prefix=$GCC_LIBS --with-libexpat-prefix=$GCC_LIBS \
                              --with-gmp=$GCC_LIBS --with-mpfr=$GCC_LIBS --with-mpc=$GCC_LIBS \
                              $GRAPHITE_LIBS --with-host-libstdcxx=-lstdc++"
export PREFIX=$BUILD_DIR/$SHORT_NAME
DIRS_TO_MAKE="$BUILD_DIR $LOG_DIR
              $PREFIX $PREFIX/mingw/include $PREFIX/$TARGET/include
              $GCC_LIBS $GCC_LIBS/include $GCC_LIBS/lib"
mkdir -p $DIRS_TO_MAKE

# optimized for my system.
#export BUILD_CFLAGS='-O2 -mtune=core2 -fomit-frame-pointer -momit-leaf-frame-pointer -fgraphite-identity -floop-interchange -floop-block -floop-parallelize-all'
export BUILD_LDFLAGS=
export BUILD_CFLAGS_LTO=$BUILD_CFLAGS #'-O2 -mtune=core2 -flto -fomit-frame-pointer -momit-leaf-frame-pointer -fgraphite-identity -floop-interchange -floop-block -floop-parallelize-all'
export BUILD_LDFLAGS_LTO= #'-flto='$BUILD_CORES
export MAKE_OPTS="-j"$BUILD_CORES

# get version info
. ./versions.sh

# create build directories
echo "Creating build directories"
cd $BUILD_DIR
mkdir -p $PROJECTS
cd $TOP_DIR
echo "Building"
for project in $PROJECTS
do
    cd $BUILD_DIR/$project
    echo "-> $project"
    . $SCRIPTS/$project.sh || exit 1
    cd $TOP_DIR
done

