# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

# set version label
ARG BUILD_DATE
ARG VERSION
ARG GNUCASH_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="nnard1616"

ENV \
  CUSTOM_PORT="8080" \
  CUSTOM_HTTPS_PORT="8181" \
  HOME="/config" \
  TITLE="Gnucash"

RUN \
  echo "**** install runtime packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    adwaita-icon-theme-full \
    at-spi2-core \
    dbus \
    fcitx-rime \
    fonts-wqy-microhei \
    gir1.2-gtk-3.0 \
    gobject-introspection \
    jq \
    libgtk-3-dev \
    libnss3 \
    libopengl0 \
    libqpdf28 \
    librsvg2-common \
    libxkbcommon-x11-0 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-xinerama0 \
    poppler-utils \
    python3 \
    python3-gi \
    python3-xdg \
    ttf-wqy-zenhei \
    wget \
    xz-utils  && \
  sed -i 's|</applications>|  <application title="gnucash" type="normal">\n    <maximized>yes</maximized>\n  </application>\n</applications>|' /etc/xdg/openbox/rc.xml
RUN apt-get install -y gnucash
RUN  echo "**** cleanup ****" && \
  /usr/lib/x86_64-linux-gnu/gdk-pixbuf-2.0/gdk-pixbuf-query-loaders --update-cache && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*
#  echo "**** install gnucash ****" && \
#  mkdir -p \
#    /opt/gnucash && \
#  if [ -z ${GNUCASH_RELEASE+x} ]; then \
#    GNUCASH_RELEASE=$(curl -sX GET "https://api.github.com/repos/Gnucash/gnucash/releases/latest" \
#    | jq -r .tag_name); \
#  fi && \
#  GNUCASH_VERSION="$(echo ${GNUCASH_RELEASE} )" && \
#  GNUCASH_URL="https://sourceforge.net/projects/gnucash/files/gnucash%20(stable)/${GNUCASH_VERSION}/gnucash-${GNUCASH_VERSION}.tar.bz2" && \
#  curl -o \
#    /tmp/gnucash.tar.bz2 -L \
#    "$GNUCASH_URL" && \
#  tar xjf /tmp/gnucash.tar.bz2 -C \
#    /opt/gnucash && \  #TODO create build directory and build/install gnucash
#  /opt/gnucash/gnucash_postinstall && \
#  dbus-uuidgen > /etc/machine-id && \
#  sed -i 's|</applications>|  <application title="gnucash" type="normal">\n    <maximized>yes</maximized>\n  </application>\n</applications>|' /etc/xdg/openbox/rc.xml && \
#  echo "**** cleanup ****" && \
#  apt-get clean && \
#  rm -rf \
#    /tmp/* \
#    /var/lib/apt/lists/* \
#    /var/tmp/*

# TODO: adjust local files for gnucash
# add local files
COPY root/ /
