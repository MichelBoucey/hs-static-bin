HASKELL_GIT_REPO=https://github.com/MichelBoucey/ip6addr.git

# Below this line, it should be leaved unchanged

cd /tmp
git clone ${HASKELL_GIT_REPO} cloned-repo
cd cloned-repo
# The binary artefact have to be copied to /tmp/bin/
cabal --enable-executable-static --install-method=copy --installdir=/tmp/bin install
