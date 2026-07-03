export HS_STATIC_BIN_VER := "1.3.1"
export CURDIR := invocation_directory_native()

help:
    @echo "Usage:"
    @echo
    @echo "   show-env-vars    Show hs-static-bin environment variables settings"
    @echo "   envrc            Create a .envrc for hs-static-bin environment variables"
    @echo "   image            Build hs-static-bin Docker image"
    @echo "   pull-image       Get pre-built hs-static-bin Docker image"
    @echo "   build            Build an Haskell static binary"
    @echo "   clean            Remove target/ where Haskell binary artifacts are delivered"
    @echo "   docker-clean     Remove hs-static-bin image and containers from Docker"
    @echo "   clean-all        Clean and docker-clean combined"
    @echo "   version          Show version"
    @echo "   help             Show this usage notice"
    @echo
    @echo "Copyright (c) 2025-2026 Michel Boucey (github.com/MichelBoucey/hs-static-bin)"

version:
    @echo ${HS_STATIC_BIN_VER}

image:
    docker buildx build \
    --build-arg BOOTSTRAP_HASKELL_GHC_VERSION=${HASKELL_GHC_VERSION} \
    --build-arg BOOTSTRAP_HASKELL_CABAL_VERSION=${HASKELL_CABAL_VERSION} \
    -t hs-static-bin:ghc-${HASKELL_GHC_VERSION} docker/

pull-image:
    docker pull ghcr.io/michelboucey/hs-static-bin:ghc-${HASKELL_GHC_VERSION}
    docker image tag ghcr.io/michelboucey/hs-static-bin:ghc-${HASKELL_GHC_VERSION} hs-static-bin:ghc-${HASKELL_GHC_VERSION}

show-env-vars:
    @echo "HASKELL_CABAL_VERSION=${HASKELL_CABAL_VERSION}"
    @echo "HASKELL_GHC_VERSION=${HASKELL_GHC_VERSION}"
    @echo "HASKELL_GIT_REPO_URL=${HASKELL_GIT_REPO_URL}"
    @echo "HASKELL_CABAL_SUB_PROJECT=${HASKELL_CABAL_SUB_PROJECT}"

binary: build

build:
    @echo "hs-static-bin version ${HS_STATIC_BIN_VER}"
    @if [ -n "$$HASKELL_GHC_VERSION" ] && [ -n "$$HASKELL_GIT_REPO_URL" ]; then \
        echo -n "Building Haskell static binary artifact at ${HASKELL_GIT_REPO_URL}"; \
              if [ -n "$$HASKELL_CABAL_SUB_PROJECT" ]; then \
                 echo " in Cabal sub-project ${HASKELL_CABAL_SUB_PROJECT}"; \
              else \
                 echo; \
              fi \
    else \
        echo "You have to set env vars HASKELL_GHC_VERSION and HASKELL_GIT_REPO_URL"; \
        exit 1; \
    fi
    @if [ -d "static-bin" ]; then \
        echo "Moving static-bin/ to target/ for compatibility"; \
        mv ${CURDIR}/static-bin ${CURDIR}/target; \
    fi
    @if [ ! -d "target" ]; then \
        mkdir ${CURDIR}/target; \
    fi
    @docker run \
    --env HASKELL_GIT_REPO_URL \
    --env HASKELL_CABAL_SUB_PROJECT \
    --env CURUID=$(id -u) \
    --env CURGID=$(id -g) \
    --mount type=bind,src=${CURDIR}/script/,dst=/tmp/script/ \
    --mount type=bind,src=${CURDIR}/target/,dst=/tmp/bin/ \
    hs-static-bin:ghc-${HASKELL_GHC_VERSION} \
    /bin/ash /tmp/script/build.sh
    strip --strip-all ${CURDIR}/target/*
    just docker-clean-containers

envrc:
    @make --no-print-directory show-env-vars | sed 's/^/export /' > .envrc

clean:
    rm -rf ${CURDIR}/target/

docker-clean-containers:
    @echo $(docker ps -a -q -f ancestor=hs-static-bin:ghc-$$HASKELL_GHC_VERSION -f status=exited) | xargs -r docker rm -f

docker-clean: docker-clean-containers
    @echo $(shell docker images | grep -P hs-static-bin\\s*ghc-$$HASKELL_GHC_VERSION | awk '{print $$3}' | uniq) | xargs -r docker rmi

clean-all: clean docker-clean

#
# Github hs-static-bin maintenance targets
# 
build-push:
    @packages/$@

build-push-all:
    @packages/$@
