#!/bin/bash
set -e

mkdir -p .tmp/only_office

ARCH=amd64
curl -x $SOCKS5_PROXY_LOCAL \
  -o .tmp/only_office/onlyoffice-desktopeditors_${ARCH}.deb \
  -fL https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_${ARCH}.deb

mc cp .tmp/only_office/* aliyun/vscode/kasm/only_office/
