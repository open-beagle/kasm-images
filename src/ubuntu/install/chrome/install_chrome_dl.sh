#!/bin/bash
set -e

mkdir -p .tmp/chrome

curl -x $SOCKS5_PROXY_LOCAL \
  -o .tmp/chrome/google-chrome-stable_current_amd64.deb \
  -fL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

mc cp .tmp/chrome/* aliyun/vscode/kasm/chrome/
