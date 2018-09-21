mkdir build
cd build
ls /usgs/apps/kakadu/v7_9_1-01762L/managed/all_includes/
cmake -GNinja -DJP2KFLAG=ON -Dpybindings=OFF -DCMAKE_INSTALL_PREFIX=$PREFIX -Disis3Data=/usgs/cpkgs/isis3/data -Disis3TestData=/usgs/cpkgs/isis3/testData ../isis
ninja install
setisis .
