# Set an Haskell Git repo URL that can deliver
# a binary just by running a cabal install command inside
HASKELL_GIT_REPO=https://github.com/MichelBoucey/ip6addr.git

# Below this line, it should be leaved usually unchanged

cd /tmp

git clone ${HASKELL_GIT_REPO} cloned-repo

cd cloned-repo

# The just-built static binary artefact have to be finally copied to /tmp/bin/
cabal --enable-executable-static --install-method=copy --installdir=/tmp/bin install

# Set the right ownership
chown $CURUID:$CURGID /tmp/bin/*
