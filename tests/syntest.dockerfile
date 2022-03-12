FROM rust:1.59 as build
LABEL keep=false
RUN git clone --depth=1 --branch=v4.7.1 \
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

# don't run this manually, use unit.py
