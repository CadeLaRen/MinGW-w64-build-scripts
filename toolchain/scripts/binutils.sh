#!/usr/bin/env bash
set -e

if [ -f configure.marker ]
then
    echo "--> Already configured"
else
    echo "--> Configuring"
    sh $BINUTILS_SRC/configure --host=$HOST --build=$BUILD --target=$TARGET --with-sysroot=$PREFIX --prefix=$PREFIX \
                               --with-libexpat-prefix=$PREREQ_INSTALL \
                               $GNU_WIN32_OPTIONS \
                               CFLAGS="$BUILD_CFLAGS" LDFLAGS="$BUILD_LDFLAGS" \
                               > $LOG_DIR/binutils_configure.log 2>&1 || exit 1
    echo "--> Configured"
fi
touch configure.marker

if [ -f build.marker ]
then
    echo "--> Already built"
else
    echo "--> Building"
    make $MAKE_OPTS > $LOG_DIR/binutils_build.log 2>&1 || 
exit 1
fi
touch build.marker

if [ -f install.marker ]
then
    echo "--> Already installed"
else
    echo "--> Installing"
    make $MAKE_OPTS install > $LOG_DIR/binutils_install.log 2>&1 || exit 1
fi
touch install.marker
