# hs-static-bin

## 1. Goal

Get easily Haskell static binaries through an adhoc Docker container without never to have to login into it. The Haskell binary artefact is delivered on the local host.

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

_N.B._ : You never have to login 

### 2.2. Adjust the Haskell script build process

You have to edit `script/build.sh`.

_N.B._ : Between tries to get build success, you won't have to rebuild the `hs-static-bin` Docker image, because `build.sh` is dynamically mounted during the running of the `hs-static-bin` container.

### 2.3. Building the binary artefact

```
make binary
```

Once the build process is finished, one can find the stripped binary artefact in `static-bin/` folder with the right ownership.

