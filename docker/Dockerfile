FROM alpine:3

ENV PATH="/root/.ghcup/bin:$PATH" \
    BOOTSTRAP_HASKELL_NONINTERACTIVE=1 \
    BOOTSTRAP_HASKELL_GHC_VERSION=9.8.2 \
    BOOTSTRAP_HASKELL_CABAL_VERSION=3.16.0.0 \
    BOOTSTRAP_HASKELL_ADJUST_BASHRC=P

RUN apk --no-cache add binutils-gold curl gcc g++ git gmp-dev ncurses-dev ncurses-static \
    libffi-dev make xz tar perl zlib-dev zlib-static sudo libc6-compat gmp-static \
    && curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

CMD ["mkdir","/tmp/script/"]
