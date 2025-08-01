#!/bin/ash

cd /tmp
mkdir bin
git clone https://github.com/MichelBoucey/ip6addr.git build
cd ./build
cabal --enable-executable-static --installdir=/tmp/bin install
