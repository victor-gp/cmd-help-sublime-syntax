# usage: use tests/syntax.py, don't run this manually

ARG SYNTECT_VERSION=5.2.0
ARG RUST_IMAGE_VERSION=1.84
ARG DEBIAN_IMAGE_VERSION=bookworm-slim

FROM rust:$RUST_IMAGE_VERSION AS build
LABEL keep=false
ARG SYNTECT_VERSION
RUN git clone --depth=1 --branch=v${SYNTECT_VERSION} \
    https://github.com/trishume/syntect.git \
    /usr/src/syntect
WORKDIR /usr/src/syntect
RUN cargo build --release --example syntest

FROM debian:$DEBIAN_IMAGE_VERSION
# RUN apt-get update && apt-get install -y EXTRA_RUNTIME_DEPENDENCIES && rm -rf /var/lib/apt/lists/*
COPY --from=build /usr/src/syntect/target/release/examples/syntest \
    /usr/local/bin/syntest
ENTRYPOINT [ "syntest" ]
CMD [ "/tests/syntax", "/syntaxes" ]
