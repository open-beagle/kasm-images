#!/bin/bash
set -e

mkdir -p .tmp/chrome

curl -x $SOCKS5_PROXY_LOCAL \
  -o .tmp/chrome/google-chrome-stable_current_amd64.deb \
  -fL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

curl -x $SOCKS5_PROXY_LOCAL \
  -o .tmp/chrome/google-chrome-stable_111.0.5563.146-1_amd64.deb \
  -fL https://mirror.cs.uchicago.edu/google-chrome/pool/main/g/google-chrome-stable/google-chrome-stable_111.0.5563.146-1_amd64.deb

mc cp .tmp/chrome/* aliyun/vscode/kasm/chrome/
