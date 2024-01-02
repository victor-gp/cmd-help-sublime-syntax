# used in
#  tests/highlight_regression.sh
#  tests/theme_regression.sh
#  scripts/demo_themes.sh

FROM curlimages/curl:latest AS fetch-pkg
LABEL keep=false
ARG BAT_VERSION=0.24.0
RUN curl -LJ \
    https://github.com/sharkdp/bat/releases/download/v$BAT_VERSION/bat_${BAT_VERSION}_amd64.deb \
    --output /tmp/bat.deb

#fixme: run this without root
FROM debian:bullseye-slim
COPY --from=fetch-pkg  /tmp/bat.deb  /tmp
RUN dpkg --install /tmp/bat.deb
ENV COLORTERM=truecolor
COPY ./tests/docker/inner*.sh  /tests/
COPY ./syntaxes/cmd-help.sublime-syntax  /root/.config/bat/syntaxes/
RUN bat cache --build > /dev/null
ENTRYPOINT /tests/inner_highlight_regression.sh
