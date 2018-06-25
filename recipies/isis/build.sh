

mkdir build
cd build
cmake -G Ninja -DJP2KFLAG=OFF -DbuildTests=OFF -DCMAKE_INSTALL_PREFIX=$PREFIX isis
ninja install
