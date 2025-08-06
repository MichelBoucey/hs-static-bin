# hs-static-bin

## 1. Goal

The goal of `hs-static-bin` is to get easily Haskell static binaries through an adhoc Docker container without never to have to login into it. The Haskell binary artifact is delivered on the local host with the right ownership.

It should be usable in a CI/CD process (not yet tested).

## 2. Usage

```
[user@box ~] $ make
Usage:

   image       Build hs-static-bin Docker image
   binary      Build an Haskell static binary
   clean       Remove static-bin/ where Haskell binary artifacts are delivered
   clean-all   Remove also hs-static-bin Docker image and containers
   help        Show this usage notice

Copyright (c) 2025 Michel Boucey (https://github.com/MichelBoucey/hs-static-bin)
```

### 2.1. Building the hs-static-bin Docker image

#### 2.1.1. Set GHC and Cabal versions

You have first to set the `GHC` and `Cabal` versions you need in `docker/Dockerfile` through two variables given by `GHCup`:

- `BOOTSTRAP_HASKELL_GHC_VERSION`
- `BOOTSTRAP_HASKELL_CABAL_VERSION`

#### 2.1.2. Launch the Docker image build

```
make image
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
make binary
```

Once the build process is finished, one can find the Haskell stripped binary artifact in `static-bin/` folder with the right ownership.

_N.B._ : If needed, between your tries to get a build success, you can tweak and edit the `script/build.sh`. You won't have to rebuild the `hs-static-bin` Docker image with `make image`, because the `build.sh` script is dynamically mounted during the running of a `hs-static-bin` container, so that it can be rewritten between tries.

## 3. How to test ?

- Just clone this repo
- Run `make image`
- Export `HASKELL_GIT_REPO_URL`
- Run `make binary`
- Run `ldd` against the just-built binary artifact to check that it has no library dependencies.
- Finally run the just-built binary artifact to check that the command is usable.

