FROM alpine:3

ENV PATH="/root/.ghcup/bin:$PATH" \
    BOOTSTRAP_HASKELL_NONINTERACTIVE=1 \
    BOOTSTRAP_HASKELL_GHC_VERSION=9.8.2 \
    BOOTSTRAP_HASKELL_CABAL_VERSION=3.16.0.0 \
    BOOTSTRAP_HASKELL_ADJUST_BASHRC=P

RUN apk add --no-cache binutils-gold curl gcc g++ gmp gmp-dev libc-dev \
    libffi-dev make musl-dev ncurses-dev perl tar xz zlib-dev git \
    && curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

ADD build.sh .

RUN chmod 755 build.sh

ENTRYPOINT ["/build.sh"]
