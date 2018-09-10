#!/bin/bash

COMPILER=/usr/local/bin/g++-8

CMAKE_ARGS="-DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=$COMPILER -DCMAKE_CXX_COMPILER=$COMPILER"

WD=`pwd`

echo $WD

# build VM and copy to bin
mkdir -p ../vm/release
cd ../vm/release && cmake $CMAKE_ARGS .. && make vm && cd $WD && cp ../vm/release/vm bin/vm

# build compiler and copy to bin
cd ../compiler && mvn package && cd $WD && cp ../compiler/target/compiler-0.1.0.jar bin/compiler.jar
