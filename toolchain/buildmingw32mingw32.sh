#!/usr/bin/env bash
set -e

#platforms
export HOST=i686-w64-mingw32
export TARGET=i686-w64-mingw32
export BUILD=x86_64-redhat-linux
export EXESUFFIX=".exe"
export SHORT_NAME=mingw32
export LONG_NAME=mingw32mingw32
export CRT_MULTILIB='--disable-lib64 --enable-lib32'

# call main build script
. ./scripts/buildnative.sh
