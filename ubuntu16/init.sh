#!/bin/bash

sed -i -E -e 's#([a-z]+\.)?archive.ubuntu.com#cn.archive.ubuntu.com#' /etc/apt/sources.list
apt-get update -y
apt-get install -y --no-install-recommends \
	wget curl apt-utils language-pack-en language-pack-zh-hans tzdata

apt-get install -y --no-install-recommends tzdata
rm -f /etc/localtime
echo "Asia/Shanghai" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
