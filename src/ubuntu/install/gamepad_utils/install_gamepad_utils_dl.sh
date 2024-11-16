#!/bin/bash
set -e

mkdir -p .tmp/gamepad_utils

curl -x $SOCKS5_PROXY_LOCAL \
  -o .tmp/gamepad_utils/gamepadtool_1.2_amd64.deb \
  -fL https://generalarcade.com/gamepadtool/linux/gamepadtool_1.2_amd64.deb

mc cp .tmp/gamepad_utils/* aliyun/vscode/kasm/gamepad_utils/
