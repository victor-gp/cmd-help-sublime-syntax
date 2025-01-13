# dependents:
#  tests/highlight_regression.sh
#  tests/theme_regression.sh
#  scripts/demo_themes.sh

ARG BAT_VERSION=0.25.0
ARG DEBIAN_IMAGE_VERSION=bookworm-slim

FROM curlimages/curl:latest AS fetch-pkg
LABEL keep=false
ARG BAT_VERSION
RUN curl -LJ \
    https://github.com/sharkdp/bat/releases/download/v$BAT_VERSION/bat_${BAT_VERSION}_amd64.deb \
    --output /tmp/bat.deb

FROM debian:$DEBIAN_IMAGE_VERSION
ENV COLORTERM=truecolor
ENV BAT_CACHE_PATH=/bat/cache
ENV BAT_CONFIG_DIR=/bat/config
COPY --from=fetch-pkg  /tmp/bat.deb  /tmp
RUN dpkg --install /tmp/bat.deb
COPY ./tests/docker/inner*.sh  /tests/
COPY ./syntaxes/cmd-help.sublime-syntax  $BAT_CONFIG_DIR/syntaxes/
RUN bat cache --build > /dev/null
ENTRYPOINT /tests/inner_highlight_regression.sh
