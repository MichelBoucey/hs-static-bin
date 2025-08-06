cd /tmp

git clone $1 cloned-repo

cd cloned-repo

# The just-built static binary artifact have to be copied to /tmp/bin/
cabal --enable-executable-static --install-method=copy --installdir=/tmp/bin install

# Set the right ownership
chown $CURUID:$CURGID /tmp/bin/*
