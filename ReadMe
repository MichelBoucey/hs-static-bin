# hs-static-bin

## 1. Goal

Get easily Haskell static binaries through an adhoc Docker container without never to have to login into it.

## 2. Usage

### 2.1. Building hs-static-bin Docker image

```
make image
```

__N.B.__ : You never have to login 

### 2.2. Adjust the Haskell script build process

You have to edit `script/build.sh`.

__N.B.__ : Between tries to get build success, you won't have to rebuild the `hs-static-bin` Docker image, because `build.sh` is dynamically mounted during the running of the `hs-static-bin` container.

### 2.3. Building the binary artefact

```
make binary
```

Once the build process is finished, one can find the stripped binary artefact in `static-bin/` folder with the right ownership.

