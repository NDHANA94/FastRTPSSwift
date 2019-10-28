#!/bin/bash
set -e
set -x
echo "$1" # Build type
echo MACOSX_DEPLOYMENT_TARGET="$MACOSX_DEPLOYMENT_TARGET"
if [ ! -f "Framework/libfastrtps.1.dylib" ]; then
if [ ! -d memory ]; then
git clone --quiet --recurse-submodules -b ios https://github.com/DimaRU/memory.git
fi
rm -rf "$PROJECT_TEMP_DIR/memory"
mkdir -p "$PROJECT_TEMP_DIR/memory" || true
cmake -Smemory -B"$PROJECT_TEMP_DIR/memory" -DCMAKE_INSTALL_PREFIX=build/osx \
-DFOONATHAN_MEMORY_BUILD_EXAMPLES=OFF \
-DFOONATHAN_MEMORY_BUILD_TESTS=OFF \
-DFOONATHAN_MEMORY_BUILD_TOOLS=ON \
-DCMAKE_BUILD_TYPE=Release
cmake --build "$PROJECT_TEMP_DIR/memory" --target install

rm -rf "$PROJECT_TEMP_DIR/Fast-RTPS"
if [ ! -d Fast-RTPS ]; then
git clone --quiet --recurse-submodules https://github.com/DimaRU/Fast-RTPS.git
fi
mkdir -p "$PROJECT_TEMP_DIR/Fast-RTPS" || true
cmake -SFast-RTPS -B"$PROJECT_TEMP_DIR/Fast-RTPS" -DCMAKE_INSTALL_PREFIX=build/osx \
-Dfoonathan_memory_DIR=build/osx/share/foonathan_memory/cmake -DTHIRDPARTY=ON -DCMAKE_BUILD_TYPE="$1"
cmake --build "$PROJECT_TEMP_DIR/Fast-RTPS" --target install
mkdir Framework || true
cp build/osx/lib/libfastrtps.1.dylib Framework/
cp build/osx/lib/libfastcdr.1.dylib Framework/
fi
