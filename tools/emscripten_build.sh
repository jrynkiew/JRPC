#!/usr/bin/env bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
REPO_DIR=$THIS_DIR/..
cd $REPO_DIR

if [ ! -d build_emscripten ]; then
  mkdir build_emscripten
fi

cd build_emscripten
source ~/emsdk/emsdk_env.sh
emcmake /home/jeremi/Coding/Tools/cmake-3.21.0-rc2-linux-x86_64/bin/cmake ..
make -j 4
