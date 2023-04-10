# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

# set version label
ARG BUILD_DATE
ARG VERSION
ARG GNUCASH_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

ENV \
  CUSTOM_PORT="8080" \
  CUSTOM_HTTPS_PORT="8181" \
  HOME="/config" \
  TITLE="Calibre"

RUN \
  echo "**** install runtime packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    dbus \
    fcitx-rime \
    fonts-wqy-microhei \
    jq \
    libnss3 \
    libopengl0 \
    libqpdf28 \
    libxkbcommon-x11-0 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-xinerama0 \
    poppler-utils \
    python3 \
    python3-xdg \
    ttf-wqy-zenhei \
    wget \
    xz-utils && \
  apt-get install -y \
    speech-dispatcher && \
  echo "**** install gnucash ****" && \
  mkdir -p \
    /opt/gnucash && \
  if [ -z ${GNUCASH_RELEASE+x} ]; then \
    GNUCASH_RELEASE=$(curl -sX GET "https://api.github.com/repos/Gnucash/gnucash/releases/latest" \
    | jq -r .tag_name); \
  fi && \
  GNUCASH_VERSION="$(echo ${GNUCASH_RELEASE} )" && \
  GNUCASH_URL="https://download.gnucash-ebook.com/${GNUCASH_VERSION}/gnucash-${GNUCASH_VERSION}-x86_64.txz" && \
  curl -o \
    /tmp/gnucash-tarball.txz -L \
    "$GNUCASH_URL" && \
  tar xvf /tmp/gnucash-tarball.txz -C \
    /opt/gnucash && \
  /opt/gnucash/gnucash_postinstall && \
  dbus-uuidgen > /etc/machine-id && \
  sed -i 's|</applications>|  <application title="gnucash" type="normal">\n    <maximized>yes</maximized>\n  </application>\n</applications>|' /etc/xdg/openbox/rc.xml && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY root/ /
