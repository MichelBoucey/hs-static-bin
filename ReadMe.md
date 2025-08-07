# hs-static-bin

## 1. Goal

The goal of `hs-static-bin` is to get easily Haskell static binaries through an adhoc Docker container without never to have to login into it. The Haskell binary artifact is delivered on the local host with the right ownership.

Should be usable in a CI/CD process (not yet tested).

## 2. Usage

```
[user@box ~] $ make
Usage:

   image            Build hs-static-bin Docker image
   show-env-vars    Show hs-static-bin environment variables settings
   envrc            Create a .envrc for hs-static-bin environment variables
   binary           Build an Haskell static binary
   clean            Remove static-bin/ where Haskell binary artifacts are delivered
   docker-clean     Remove hs-static-bin image and containers from Docker
   clean-all        Clean and docker-clean combined
   help             Show this usage notice

Copyright (c) 2025 Michel Boucey (github.com/MichelBoucey/hs-static-bin)
```

## 3. The hs-static-bin environment variables

### 3.1. Set the hs-static-bin environment variables

You have to set and export those env vars before running commands:

- `HASKELL_GHC_VERSION`: the `GHC` version to embed into the Docker image
- `HASKELL_CABAL_VERSION`: the `Cabal` version to embed into the Docker image
- `HASKELL_GIT_REPO_URL`: an Haskell Git repo capable of building executable(s) just by running a `cabal install`-like command inside it

```
[user@box ~] $ export HASKELL_CABAL_VERSION=3.16.0.0
[user@box ~] $ export HASKELL_GHC_VERSION=9.8.2
[user@box ~] $ export HASKELL_GIT_REPO_URL=https://github.com/ndmitchell/ghcid
```

### 3.2. Check the hs-static-bin environment variables

You can check the `hs-static-bin` environment:

```
[user@box hs-static-bin] $ make show-env-vars
HASKELL_CABAL_VERSION=3.16.0.0
HASKELL_GHC_VERSION=9.8.2
HASKELL_GIT_REPO_URL=https://github.com/ndmitchell/ghcid
```

### 3.3. Create a hs-static-bin .envrc file

Based upon the `hs-static-bin` env vars currently exported, on can create a corresponding `.envrc` file.

```
[user@box hs-static-bin] $ make envrc
[user@box hs-static-bin] $ cat .envrc
export HASKELL_CABAL_VERSION=3.16.0.0
export HASKELL_GHC_VERSION=9.8.2
export HASKELL_GIT_REPO_URL=https://github.com/ndmitchell/ghcid
```

## 4. Launch the Docker image build

```
[user@box hs-static-bin] $ make image
```

_N.B._ :
- `hs-static-bin` Docker images are tagged with the GHC version embedded, like `hs-static-bin:ghc-9.8.2`
- A single build is normally enough, until you have to change `GHC` or `Cabal` version
- You shouldn't have to login into `hs-static-bin` containers.

## 5. Launch the Haskell binary artifact build

```
[user@box hs-static-bin] $ make binary
```

Once the build process is finished, one can find the Haskell stripped binary artifact in `static-bin/` folder with the right ownership.

```
[user@box hs-static-bin] $ ls static-bin/
ghcid
```

_N.B._ : If needed, between your tries to get a build success, you can tweak and edit the `script/build.sh`. You won't have to rebuild the `hs-static-bin` Docker image with `make image`, because the `build.sh` script is dynamically mounted during the running of a `hs-static-bin` container, so that it can be rewritten between tries.

## 6. Cleanup Docker from hs-static-bin image and containers

```
[user@box hs-static-bin] $ make docker-clean
```

## 7. In brief, how to test and check hs-static-bin ?

- Clone this repo
- Set properly and export `HASKELL_CABAL_VERSION`, `HASKELL_GHC_VERSION` and `HASKELL_GIT_REPO_URL`
- Run `make image`
- Run `make binary`
- Run `ldd` against the just-built binary artifact delivered in `static-bin/` to check and ensure that it has no library dependencies.
- Run the just-built binary artifact to check that the command is usable.

