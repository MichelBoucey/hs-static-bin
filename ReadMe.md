# hs-static-bin

## 1. Goal

The goal of `hs-static-bin` is to get easily Haskell static binaries through an adhoc Docker container without never to have to login into it. The Haskell binary artifact is delivered on the local host with the right ownership.

It should be usable in a CI/CD process (not yet tested).

## 2. Usage

```
[user@box ~] $ make
Usage:

   image          Build hs-static-bin Docker image
   binary         Build an Haskell static binary
   clean          Remove static-bin/ where Haskell binary artifacts are delivered
   docker-clean   Remove hs-static-bin image and containers from Docker
   clean-all      clean and docker-clean combined
   help           Show this usage notice

Copyright (c) 2025 Michel Boucey (https://github.com/MichelBoucey/hs-static-bin)
```

### 2.1. Building the hs-static-bin Docker image

#### 2.1.1. Set GHC and Cabal versions

You have to set and export the `GHC` and `Cabal` versions you want to use through two variables given by `GHCup`:

- `BOOTSTRAP_HASKELL_GHC_VERSION`
- `BOOTSTRAP_HASKELL_CABAL_VERSION`

```
[user@box ~] $ export BOOTSTRAP_HASKELL_GHC_VERSION=9.8.2
[user@box ~] $ export BOOTSTRAP_HASKELL_CABAL_VERSION=3.16.0.0
```

You can check them with:

```
[user@box ~] $ make show-image-env-vars
BOOTSTRAP_HASKELL_CABAL_VERSION=3.16.0.0
BOOTSTRAP_HASKELL_GHC_VERSION=9.8.2
```

#### 2.1.2. Launch the Docker image build

```
[user@box hs-static-bin] $ make image
```

_N.B._ : 1°/ A single build is normally enough, 2°/ You will never have to login into it.

### 2.2. Building the Haskell binary artifact

#### 2.2.1. Set the Haskell Git repo

You have to set and export `HASKELL_GIT_REPO_URL` env var to an Haskell Git repo capable of building an executable just by running a `cabal install` command inside it.

```
[user@box ~] $ export HASKELL_GIT_REPO_URL=https://github.com/MichelBoucey/ip6addr
```

#### 2.2.2. Launch the Haskell binary artifact build

```
[user@box hs-static-bin] $ make binary
```

Once the build process is finished, one can find the Haskell stripped binary artifact in `static-bin/` folder with the right ownership.

_N.B._ : If needed, between your tries to get a build success, you can tweak and edit the `script/build.sh`. You won't have to rebuild the `hs-static-bin` Docker image with `make image`, because the `build.sh` script is dynamically mounted during the running of a `hs-static-bin` container, so that it can be rewritten between tries.

## Cleanup Docker from hs-static-bin image and containers

```
[user@box hs-static-bin] $ make docker-clean
```

## 2.3. Creating an env vars file

```
[user@box ~] $ make show-env-vars > .env
```

## 3. In brief, how to test and check hs-static-bin ?

- Clone this repo
- Set and export `BOOTSTRAP_HASKELL_CABAL_VERSION` and `BOOTSTRAP_HASKELL_GHC_VERSION`
- Run `make image`
- Set and export `HASKELL_GIT_REPO_URL`
- Run `make binary`
- Run `ldd` against the just-built binary artifact delivered in `static-bin/` to check and to ensure that it has no library dependencies.
- Run the just-built binary artifact to check that the command is usable.

