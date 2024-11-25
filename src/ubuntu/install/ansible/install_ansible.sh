#!/usr/bin/env bash
set -ex

if grep -q "ID=debian" /etc/os-release || grep -q "VERSION_CODENAME=noble" /etc/os-release; then
  apt-get update
  apt-get install -y ansible
else
  apt-get update
  apt-get install -y software-properties-common
  apt-add-repository --yes --update ppa:ansible/ansible
  sed -i 's/ppa.launchpadcontent.net/launchpad.proxy.ustclug.org/g' /etc/apt/sources.list /etc/apt/sources.list.d/*.list
  apt-get install -y ansible
fi
