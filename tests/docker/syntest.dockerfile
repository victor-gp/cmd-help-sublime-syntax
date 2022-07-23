# usage: use tests/syntax.py, don't run this manually

FROM rust:1.59 as build
LABEL keep=false
ARG SYNTECT_VERSION=5.0.0
RUN git clone --depth=1 --branch=v${SYNTECT_VERSION} \
    https://github.com/trishume/syntect.git \
    /usr/src/syntect
WORKDIR /usr/src/syntect
RUN cargo build --release --example syntest

FROM debian:bullseye-slim
# RUN apt-get update && apt-get install -y EXTRA_RUNTIME_DEPENDENCIES && rm -rf /var/lib/apt/lists/*
COPY --from=build /usr/src/syntect/target/release/examples/syntest \
    /usr/local/bin/syntest
ENTRYPOINT [ "syntest" ]
CMD [ "/tests/syntax", "/syntaxes" ]
