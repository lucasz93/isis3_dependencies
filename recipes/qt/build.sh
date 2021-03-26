#!/bin/bash

# QT build for ISIS3. Specifically adds in flags for database plugins. 

# Compile
# -------
chmod +x configure

if [ $(uname) == Linux ]; then

    MAKE_JOBS=$CPU_COUNT

    ./configure -prefix $PREFIX \
                -libdir $PREFIX/lib \
                -bindir $PREFIX/bin \
                -headerdir $PREFIX/include/qt \
                -archdatadir $PREFIX \
                -datadir $PREFIX \
                -L $PREFIX/lib \
                -I $PREFIX/include \
                -release \
                -opensource \
                -confirm-license \
                -shared \
                -nomake examples \
                -nomake tests \
                -verbose \
                -skip location \
                -skip sensors \
                -skip serialport \
                -skip serialbus \
                -skip quickcontrols2 \
                -skip wayland \
                -skip canvas3d \
                -skip 3d \
                -skip webengine \
                -system-libpng \
                -system-zlib \
                -qt-pcre \
                -qt-xcb \
                -qt-xkbcommon \
                -plugin-sql-mysql \
                -plugin-sql-psql \
                -plugin-sql-sqlite \
                -no-sql-db2 \
                -no-sql-oci \
                -no-sql-ibase \
                -xkb-config-root $PREFIX/lib \
                -dbus \
                -no-linuxfb \
                -no-libudev \
                -no-avx \
                -no-avx2 \
                -D _X_INLINE=inline \
                -D XK_dead_currency=0xfe6f \
                -D XK_ISO_Level5_Lock=0xfe13 \
                -D FC_WEIGHT_EXTRABLACK=215 \
                -D FC_WEIGHT_ULTRABLACK=FC_WEIGHT_EXTRABLACK \
                -D GLX_GLXEXT_PROTOTYPES


    LD_LIBRARY_PATH=$PREFIX/lib make -j $MAKE_JOBS || exit 1
    make install
fi

if [ $(uname) == Darwin ]; then
    # Let Qt set its own flags and vars
    for x in OSX_ARCH CFLAGS CXXFLAGS LDFLAGS
    do
        unset $x
    done

    #patch -p0 < "${RECIPE_DIR}"/0011-qfontengine_QFixed_constructorname.patch
    #patch -p0 < "${RECIPE_DIR}"/0012-qcoacoahelpers_undeclaredidentifier_mac1013.patch

    export MACOSX_DEPLOYMENT_TARGET=10.13

    ./configure -prefix $PREFIX \
                -libdir $PREFIX/lib \
                -bindir $PREFIX/bin \
                -headerdir $PREFIX/include/qt \
                -archdatadir $PREFIX \
                -datadir $PREFIX \
                -L $PREFIX/lib \
                -I $PREFIX/include \
                -R $PREFIX/lib \
                -release \
                -opensource \
                -confirm-license \
                -shared \
                -nomake examples \
                -nomake tests \
                -verbose \
                -skip location \
                -skip sensors \
                -skip serialport \
                -skip serialbus \
                -skip quickcontrols2 \
                -skip wayland \
                -skip canvas3d \
                -skip 3d \
                -skip webengine \
                -system-libpng \
                -system-zlib \
                -qt-pcre \
                -qt-freetype \
                -plugin-sql-mysql \
                -plugin-sql-psql \
                -plugin-sql-sqlite \
                -no-sql-db2 \
                -no-sql-oci \
                -no-sql-ibase \
                -c++std 11 \
                -no-framework \
                -no-dbus \
                -no-mtdev \
                -no-harfbuzz \
                -no-xinput2 \
                -no-xcb-xlib \
                -no-libudev \
                -no-egl \
                -no-openssl \
                -sdk macosx10.13 \
    ####

    make -j $CPU_COUNT || exit 1
    make install
fi


# Post build setup
# ----------------
# Remove static libraries that are not part of the Qt SDK.
pushd "${PREFIX}"/lib > /dev/null
    find . -name "*.a" -and -not -name "libQt*" -exec rm -f {} \;
popd > /dev/null

# Add qt.conf file to the package to make it fully relocatable
cp "${RECIPE_DIR}"/qt.conf "${PREFIX}"/bin/

if [ $(uname) == Darwin ]
then
    BIN=$PREFIX/bin

    for name in Assistant Designer Linguist pixeltool qml
    do
        mv ${BIN}/${name}.app ${BIN}/${name}app
    done

    # We built Qt itself with SDK 10.9, but we shouldn't
    # force users to also build their Qt apps with SDK 10.9
    # https://bugreports.qt.io/browse/QTBUG-41238
    sed -i '' s/macosx10\.[[:digit:]]*/macosx/g ${PREFIX}/mkspecs/qdevice.pri

    POST_LINK=$BIN/.qt-post-link.sh
    PRE_UNLINK=$BIN/.qt-pre-unlink.sh
    cp $RECIPE_DIR/osx-post.sh $POST_LINK
    cp $RECIPE_DIR/osx-pre.sh $PRE_UNLINK
    chmod +x $POST_LINK $PRE_UNLINK
fi
