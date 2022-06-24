# usage: through the docker-compose service

FROM curlimages/curl:latest as fetch-pkg
LABEL keep=false
ARG BAT_VERSION=0.21.0
RUN curl -LJ --output /tmp/bat.deb \
    https://github.com/sharkdp/bat/releases/download/v$BAT_VERSION/bat_${BAT_VERSION}_amd64.deb

FROM debian:bullseye-slim
COPY --from=fetch-pkg /tmp/bat.deb /tmp
RUN dpkg --install /tmp/bat.deb
ENV COLORTERM=truecolor
COPY run_*_regression.sh /tests/
CMD sleep infinity
