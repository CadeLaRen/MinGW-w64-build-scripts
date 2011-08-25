#!/usr/bin/env bash
set -e

# platform information
export HOST=i686-w64-mingw32
export TARGET=x86_64-w64-mingw32
export SHORT_NAME=mingw32
export LONG_NAME=mingw32mingw64
export CRT_MULTILIB='--enable-lib64 --disable-lib32'

# call main build script
. ./scripts/buildfromcross.sh
