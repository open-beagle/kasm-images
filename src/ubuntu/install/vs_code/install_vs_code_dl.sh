#!/bin/bash
set -e

mkdir -p .tmp/vs_code

ARCH=amd64
curl -x $SOCKS5_PROXY_LOCAL \
  -o .tmp/vs_code/code_1.95.3_x64.deb \
  -fL https://update.code.visualstudio.com/latest/linux-deb-x64/stable

ARCH=arm64
curl -x $SOCKS5_PROXY_LOCAL \
  -o .tmp/vs_code/code_1.95.3_arm64.deb \
  -fL https://update.code.visualstudio.com/latest/linux-deb-arm64/stable

curl -x $SOCKS5_PROXY_LOCAL \
  -o .tmp/vs_code/vscode.svg \
  -fL https://kasm-static-content.s3.amazonaws.com/icons/vscode.svg

mc cp .tmp/vs_code/* aliyun/vscode/kasm/vs_code/
