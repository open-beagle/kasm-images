#!/usr/bin/env bash
set -ex
apt-get update

apt-get install -y joystick jstest-gtk

ARCH=$(arch | sed 's/aarch64/arm64/g' | sed 's/x86_64/amd64/g')

if [ "${ARCH}" == "amd64" ]; then
  curl -x socks5://www.ali.wodcloud.com:1283 -fL https://generalarcade.com/gamepadtool/linux/gamepadtool_1.2_amd64.deb >/tmp/gamepadtool.deb
  apt-get install -y /tmp/gamepadtool.deb
  rm /tmp/gamepadtool.deb
fi

if [ -z ${SKIP_CLEAN+x} ]; then
  apt-get autoclean
  rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/*
fi
