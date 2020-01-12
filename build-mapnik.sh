#!/bin/bash
set -Eeuo pipefail

cp -r "${SRC_DIR}"/mapnik/* .
make reset
./configure INPUT_PLUGINS="sqlite,shape" PREFIX="${INSTALL_DIR}/usr/local" LINKING=shared OPTIMIZATION=2 CPP_TESTS=no CAIRO=no PLUGIN_LINKING=static MEMORY_MAPPED_FILE=no DEMO=no MAPNIK_INDEX=no MAPNIK_RENDER=no
make
make install
cp -r deps/mapbox/variant/include/mapbox "${INSTALL_DIR}/usr/local/include"
