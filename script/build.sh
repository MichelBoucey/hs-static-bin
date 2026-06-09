#!/bin/ash

# To be sure to use
# the latest packages
cabal update

cd /tmp

echo "Cloning $HASKELL_GIT_REPO_URL"
git clone $HASKELL_GIT_REPO_URL cloned-repo

cd cloned-repo/$HASKELL_CABAL_SUB_PROJECT

# The just-built static binary artifact
# have to be copied to /tmp/bin/
cabal --enable-executable-static \
      --overwrite-policy=always \
      --install-method=copy \
      --installdir=/tmp/bin \
      install

# Set the right ownership
chown $CURUID:$CURGID /tmp/bin/*
