mkdir bullet-build
cd bullet-build

cmake .. -G "Unix Makefiles" -DBUILD_PYBULLET=OFF \
	                     -DBUILD_SHARED_LIBS=ON \
                             -DBUILD_PYBULLET_NUMPY=OFF \
                             -DUSE_DOUBLE_PRECISION=ON \
                             -DCMAKE_BUILD_TYPE=Release \
                             -DCMAKE_INSTALL_PREFIX=${PREFIX} \
                             -DCMAKE_INSTALL_RPATH=${PREFIX}

make -j ${CPU_COUNT}  || exit 1
make install
