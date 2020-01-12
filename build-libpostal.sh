#!/bin/bash
set -Eeuo pipefail

cp -r "${SRC_DIR}"/libpostal/* .
./bootstrap.sh
./configure --disable-sse2 --datadir="${INSTALL_DIR}/usr/local/libpostal/data" --disable-data-download --prefix="${INSTALL_DIR}" --exec-prefix="${INSTALL_DIR}" --host="${ARCH_TRIPLET}"
make -j$(nproc)
make install
