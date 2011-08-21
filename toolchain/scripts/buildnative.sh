#!/usr/bin/env bash
set -e

# native compiler options
export GNU_WIN32_OPTIONS='--disable-win32-registry --disable-rpath --disable-werror'

# common settings
. ./scripts/common.sh

# Projects to be built, in the right order
PREGCC_STEPS="mingw-w64-headers
              binutils
              mingw-w64-crt
              winpthreads"
POSTGCC_STEPS="expat
               python
               gdb
               make
               llvm-clang
               cleanup
               zipping"
cd $BUILD_DIR
mkdir -p $PREGCC_STEPS
mkdir -p $POSTGCC_STEPS
cd $TOP_DIR

# Build
for step in $PREGCC_STEPS
do
    cd $BUILD_DIR/$step
    echo "-> $step"
    . $SCRIPTS/$step.sh || exit 1
    cd $TOP_DIR
done
# build GCC
cd $BUILD_DIR/gcc
echo "-> GCC combined tree"
. $SCRIPTS/gcc-combined.sh || exit 1
cd $TOP_DIR
# build the rest
for step in $POSTGCC_STEPS
do
    cd $BUILD_DIR/$step
    echo "-> $step"
    . $SCRIPTS/$step.sh || exit 1
    cd $TOP_DIR
done

