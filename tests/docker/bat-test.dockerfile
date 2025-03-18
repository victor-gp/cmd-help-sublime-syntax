# dependents:
#  tests/highlight_regression.sh
#  tests/theme_regression.sh
#  scripts/try_input.sh
#  scripts/demo_themes.sh

ARG BAT_VERSION=0.25.0
ARG DEBIAN_IMAGE_VERSION=bookworm-slim

FROM debian:$DEBIAN_IMAGE_VERSION
ENV COLORTERM=truecolor
ENV BAT_CACHE_PATH=/bat/cache
ENV BAT_CONFIG_DIR=/bat/config
ARG BAT_VERSION
ADD https://github.com/sharkdp/bat/releases/download/v$BAT_VERSION/bat_${BAT_VERSION}_amd64.deb \
    /tmp/bat.deb
RUN dpkg --install /tmp/bat.deb
COPY ./tests/docker/bat-test-entrypoints  /tests/entrypoints
COPY ./syntaxes/cmd-help.sublime-syntax  $BAT_CONFIG_DIR/syntaxes/
RUN bat cache --build > /dev/null
ENTRYPOINT ["/tests/inner_highlight_regression.sh"]
