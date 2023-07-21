#!/bin/sh

for dylib in arm64/*; do 
  lipo -create -arch arm64 $dylib -arch x86_64 x86_64/$(basename $dylib) -output x86_64/$(basename $dylib); 
done
for dylib in universal/*; do
  lipo $dylib -info;
done
