# hs-static-bin [![hs-static-bin](https://github.com/MichelBoucey/hs-static-bin/actions/workflows/justfile.yml/badge.svg)](https://github.com/MichelBoucey/hs-static-bin/actions/workflows/justfile.yml)

## 1. Goal

The goal of `hs-static-bin` is to build easily `Haskell static binaries` through an adhoc Docker container. The Haskell binary artifacts are delivered on the localhost with the right ownership. No localhost installation of Haskell build environment is needed. Can run in a CI/CD workflow (tested with Github Actions).

## 2. Usage

```
[user@box ~] $ just
Usage:

   show-env-vars    Show hs-static-bin environment variables settings
   envrc            Create a .envrc for hs-static-bin environment variables
   image            Build hs-static-bin Docker image
   pull-image       Get pre-built hs-static-bin Docker image
   build            Build an Haskell static binary
   clean            Remove target/ where Haskell binary artifacts are delivered
   docker-clean     Remove hs-static-bin image and containers from Docker
   clean-all        Clean and docker-clean combined
   version          Show version
   help             Show this usage notice

Copyright (c) 2025-2026 Michel Boucey (github.com/MichelBoucey/hs-static-bin)
```

## 3. The hs-static-bin environment variables

### 3.1. Set the hs-static-bin environment variables

You have to set and export those env vars before running commands:

- `HASKELL_GHC_VERSION`: the `GHC` version to embed into the Docker image
- `HASKELL_CABAL_VERSION`: the `Cabal` version to embed into the Docker image
- `HASKELL_GIT_REPO_URL`: the URL of an Haskell Git repo capable of building executable(s) just by running a `cabal install`-like command inside it

```
[user@box ~] $ export HASKELL_CABAL_VERSION=3.16.0.0
[user@box ~] $ export HASKELL_GHC_VERSION=9.8.2
[user@box ~] $ export HASKELL_GIT_REPO_URL=https://github.com/ndmitchell/ghcid
```

For a `monorepo` (`cabal.project`), you have to add:

- `HASKELL_CABAL_SUB_PROJECT`: the name of the package's name, which is also the corresponding sub-directory's name.

```
[user@box ~] $ export HASKELL_CABAL_SUB_PROJECT=project
```

_N.B._: `GHC` and `Cabal` versions are those supported by `GHCup` at build time.

### 3.2. Check the hs-static-bin environment variables

You can check the `hs-static-bin` environment:

```
[user@box hs-static-bin] $ just show-env-vars
HASKELL_CABAL_VERSION=3.16.0.0
HASKELL_GHC_VERSION=9.8.2
HASKELL_GIT_REPO_URL=https://github.com/ndmitchell/ghcid
HASKELL_CABAL_SUB_PROJECT=
```

### 3.3. Create a hs-static-bin .envrc file

_Optionally_, based upon the `hs-static-bin` env vars currently exported, one can create a corresponding `.envrc` file.

```
[user@box hs-static-bin] $ just envrc
[user@box hs-static-bin] $ cat .envrc
export HASKELL_CABAL_VERSION=3.16.0.0
export HASKELL_GHC_VERSION=9.8.2
export HASKELL_GIT_REPO_URL=https://github.com/ndmitchell/ghcid
export HASKELL_CABAL_SUB_PROJECT=
```

## 4. Get hs-static-bin Docker image

- You can build by yourself this Docker image or pull a pre-built one.
- `hs-static-bin` Docker images are tagged with the GHC version embedded, like `hs-static-bin:ghc-9.8.2`
- You won't need to login into `hs-static-bin` containers. They normally stop on `exit 0` and cleared just after from Docker

### 4.1. Get a pre-built hs-static-bin Docker image

Get the pre-built `hs-static-bin` Docker image you need from [hs-static-bin package](https://github.com/MichelBoucey/hs-static-bin/pkgs/container/hs-static-bin).

```
[user@box hs-static-bin] $ just pull-image
```

_N.B._: if the `hs-static-bin` Docker image you need is missing, [open an issue](https://github.com/MichelBoucey/hs-static-bin/issues).

### 4.2. Build hs-static-bin Docker image

- [Docker CLI plugin buildx](https://github.com/docker/buildx) is needed
- A single build is enough for the intended usage

```
[user@box hs-static-bin] $ just image
```

## 5. Launch the Haskell binary artifact build

```
[user@box hs-static-bin] $ just build
```

Once the build process is finished, one can find the Haskell stripped binary artifact in `target/` folder with the right ownership.

```
[user@box hs-static-bin] $ ls target/
ghcid
```

_N.B._ : If needed, between your tries to get a build success, you can tweak and edit the `script/build.sh`. You won't have to rebuild the `hs-static-bin` Docker image with `just image`, because the `build.sh` script is dynamically mounted during the running of a `hs-static-bin` container, so that it can be rewritten between tries.

## 6. Cleanup Docker from hs-static-bin image and containers

```
[user@box hs-static-bin] $ just docker-clean
```

_N.B._: Cleans only objects with the current GHC version tag.

## 7. In brief, how to test and check hs-static-bin ?

- Clone this repo
- Set properly and export `HASKELL_CABAL_VERSION`, `HASKELL_GHC_VERSION`, `HASKELL_GIT_REPO_URL` and, when necessary, `HASKELL_CABAL_SUB_PROJECT`
- Run `just pull-image` or `just image`
- Run `just binary`
- Run `ldd` against the just-built binary artifact delivered in `target/` to check and ensure that it has no library dependencies.
- Run the just built binary artifact to check that the command is usable.

