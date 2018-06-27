
cmake -G Ninja -DCMAKE_BUILD_TYPE=Debug  -DJP2KFLAG=OFF -DbuildTests=OFF -DCMAKE_INSTALL_PREFIX=$PREFIX isis
ninja install
