#!/usr/bin/env bash
set -e

SRC_FILE=$PACKAGE_DIR/gcc-${RUBENVB_GCC_VERSION}${MY_REVISION}_rubenvb.tar.bz2

case $HOST in
  "i686-w64-mingw32")
    PLATFORM_SUFFIX="win32"
    ;;
  "x86_64-w64-mingw32")
    PLATFORM_SUFFIX="win64"
    ;;
  "x86_64-linux-gnu")
    PLATFORM_SUFFIX="linux64"
    ;;
  "i686-linux-gnu")
    PLATFORM_SUFFIX="linux32"
    ;;
  "x86_64-apple-darwin10")
    PLATFORM_SUFFIX="mac64"
    ;;
  "i686-apple-darwin10")
    PLATFORM_SUFFIX="mac32"
    ;;
  "i686-pc-cygwin")
    PLATFORM_SUFFIX="cygwin"
    ;;
  *)
    echo "-> unknown host set: $HOST"
    ;;
esac

SRC_COMPRESS="tar -jhcf"
if [ "$HOST_OS" == "mingw32" ]
then
  BIN_COMPRESS="7za -l -bd -mx9 a"
  BIN_FILE=$PACKAGE_DIR/$HOST/$TARGET-gcc-${RUBENVB_GCC_VERSION}${MY_REVISION}-${PLATFORM_SUFFIX}_rubenvb.7z
else
  BIN_COMPRESS=$SRC_COMPRESS
  if [ "$SHORT_NAME" == "mingw32-dw2" ]
  then
    BIN_FILE=$PACKAGE_DIR/$HOST/$TARGET-gcc-dw2-${RUBENVB_GCC_VERSION}${MY_REVISION}-${PLATFORM_SUFFIX}_rubenvb.tar.bz2
  else
    BIN_FILE=$PACKAGE_DIR/$HOST/$TARGET-gcc-${RUBENVB_GCC_VERSION}${MY_REVISION}-${PLATFORM_SUFFIX}_rubenvb.tar.bz2
  fi
fi

if [ -f $BIN_FILE ]
then
  echo "--> Binary file already exists"
else
  echo "--> Zipping binaries"
  cd $PREFIX/..
  $BIN_COMPRESS $BIN_FILE $SHORT_NAME > $LOG_DIR/zipping.log
fi

if [ -f $SRC_FILE ]
then
  echo "--> Source file already exists"
else
  echo "--> Zipping sources"
  cd $TOP_DIR
  $BIN_COMPRESS $SRC_FILE --exclude='*.git*' --exclude='*.svn*' --exclude='src/LLVM' \
                          --exclude='build*clang??.sh' --exclude='scripts/buildclangfromcross.sh' --exclude='scripts/LLVM-Clang.sh' \
                          src scripts patches *.sh
fi

cd $TOP_DIR
