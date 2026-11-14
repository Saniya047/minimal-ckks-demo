#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

if [ ! -f "$PWD/../.deps/install/lib/cmake/SEAL/SEALConfig.cmake" ] && \
   [ ! -f "$PWD/../.deps/install/lib64/cmake/SEAL/SEALConfig.cmake" ] && \
   [ ! -f "$PWD/.deps/install/lib/cmake/SEAL/SEALConfig.cmake" ] && \
   [ ! -f "$PWD/.deps/install/lib64/cmake/SEAL/SEALConfig.cmake" ]; then
  ./setup.sh
fi

if [ -f "$PWD/../.deps/install/lib/cmake/SEAL/SEALConfig.cmake" ] || \
   [ -f "$PWD/../.deps/install/lib64/cmake/SEAL/SEALConfig.cmake" ]; then
  SEAL_PREFIX="$PWD/../.deps/install"
else
  SEAL_PREFIX="$PWD/.deps/install"
fi

cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$SEAL_PREFIX"
cmake --build build --config Release -j 4
exec python3 app.py
