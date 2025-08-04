# hs-static-bin

## 1. Goal

Get easily Haskell static binaries through an adhoc Docker container without never to have to login into it. The Haskell binary artefact is delivered on the local host.

It should be usable in a CI/CD process.

## 2. Usage

```
Usage:

   image         Build hs-static-bin Docker image
   binary        Build static binary (needs sudo root)
   clean         Remove static-bin/ where the binary artefact is delivered
   clean-all     Remove also hs-static-bin Docker image

Copyright (c) 2025 Michel Boucey (https://github.com/MichelBoucey/hs-static-bin)
```

### 2.1. Building hs-static-bin Docker image

```
make image
```

_N.B._ : 1°/ A single build is normally enough, 2°/ You will never have to login into it.

### 2.2. Adjust the Haskell script build process

You have to edit `script/build.sh`. You have at least to set `HASKELL_GIT_REPO` variable to an Haskell Git repo building an executable just by running a `cabal install` command inside it.

_N.B._ : Between tries to get build success, you won't have to rebuild the `hs-static-bin` Docker image, because `build.sh` is dynamically mounted during the running of a `hs-static-bin` container.

### 2.3. Building the binary artefact

_NB_ : You must have `sudo root` enabled

```
make binary
```

Once the build process is finished, one can find the stripped binary artefact in `static-bin/` folder with the right ownership.

## 3. How to test ?

- Clone the repo and launch commands as explained above to get a static binary of `ip6addr` in `static-bin/` folder.
- Run `ldd static-bin/ip6addr` to check that this binary artefact has no library dependencies.
- Run `./static-bin/ip6addr --random` to check that the command is usable.

