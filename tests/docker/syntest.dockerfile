# usage: use tests/syntax.py, don't run this manually

ARG SYNTECT_VERSION=5.2.0
ARG RUST_IMAGE_VERSION=1.84
ARG DEBIAN_IMAGE_VERSION=bookworm-slim

FROM rust:$RUST_IMAGE_VERSION AS build
LABEL keep=false
ARG SYNTECT_VERSION
ADD https://github.com/trishume/syntect.git#v${SYNTECT_VERSION} \
    /usr/src/syntect
WORKDIR /usr/src/syntect
RUN cargo build --release --example syntest

FROM debian:$DEBIAN_IMAGE_VERSION
COPY --from=build /usr/src/syntect/target/release/examples/syntest \
    /usr/local/bin/syntest
ADD https://raw.githubusercontent.com/sharkdp/bat/refs/tags/v0.25.0/assets/syntaxes/02_Extra/Manpage.sublime-syntax \
    /syntaxes/vendor/Manpage.sublime-syntax
ENTRYPOINT [ "syntest" ]
CMD [ "/tests/syntax", "/syntaxes" ]
