FROM alpine:3

ARG CURUID
ARG CURGID
ARG BOOTSTRAP_HASKELL_GHC_VERSION
ARG BOOTSTRAP_HASKELL_CABAL_VERSION

ENV CURUID=$CURUID \
    CURGID=$CURGID \
    PATH="/root/.ghcup/bin:$PATH" \
    BOOTSTRAP_HASKELL_NONINTERACTIVE=1 \
    BOOTSTRAddP_HASKELL_GHC_VERSION=$BOOTSTRAP_HASKELL_GHC_VERSION \
    BOOTSTRAP_HASKELL_CABAL_VERSION=$BOOTSTRAP_HASKELL_CABAL_VERSION

RUN apk --no-cache add binutils-gold curl gcc g++ git gmp-dev ncurses-dev ncurses-static \
    libffi-dev make xz tar perl zlib-dev zlib-static sudo libc6-compat gmp-static \
    && curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

CMD ["mkdir","/tmp/script/"]
