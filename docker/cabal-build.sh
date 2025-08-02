#!/bin/ash

cd /tmp
mkdir bin
git clone https://github.com/MichelBoucey/ip6addr.git cloned-repo
cd cloned-repo
cabal --enable-executable-static --install-method=copy --installdir=/tmp/bin install
