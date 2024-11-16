#!/bin/bash
set -e

mkdir -p .tmp/obs

curl -x $SOCKS5_PROXY_LOCAL \
  -o .tmp/obs/obs-v4l2sink-0.1.0.deb \
  -fL https://github.com/CatxFish/obs-v4l2sink/releases/download/0.1.0/obs-v4l2sink.deb

mc cp .tmp/obs/* aliyun/vscode/kasm/obs/
