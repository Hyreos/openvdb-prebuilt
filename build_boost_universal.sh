#!/bin/sh

rm -rf arm64 x86_64 universal stage bin.v2
rm -f b2 project-config*
./bootstrap.sh cxxflags="-arch x86_64 -arch arm64" cflags="-arch x86_64 -arch arm64" linkflags="-arch x86_64 -arch arm64"
./b2 toolset=clang-darwin target-os=darwin architecture=arm mflags=-mmacosx-version-min=11.0 mmflags=-mmacosx-version-min=11.0 abi=aapcs cxxflags="-mmacosx-version-min=11.0 -arch arm64" cflags="-mmacosx-version-min=11.0 -arch arm64" linkflags="-arch arm64 -mmacosx-version-min=11.0" -a
mkdir -p arm64 && cp stage/lib/*.dylib arm64
./b2 toolset=clang-darwin target-os=darwin architecture=x86 mflags=-mmacosx-version-min=11.0 mmflags=-mmacosx-version-min=11.0 cxxflags="-mmacosx-version-min=11.0 -arch x86_64" cflags="-mmacosx-version-min=11.0 -arch x86_64" linkflags="-arch x86_64 -mmacosx-version-min=11.0" abi=sysv binary-format=mach-o -a
mkdir x86_64 && cp stage/lib/*.dylib x86_64
mkdir universal
for dylib in arm64/*; do 
  lipo -create -arch arm64 $dylib -arch x86_64 x86_64/$(basename $dylib) -output universal/$(basename $dylib); 
done
for dylib in universal/*; do
  lipo $dylib -info;
done
