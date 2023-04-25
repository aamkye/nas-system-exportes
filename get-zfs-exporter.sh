#!/usr/bin/env bash

LATEST=$(curl --silent "https://api.github.com/repos/pdf/zfs_exporter/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^\"]+)".*/\1/')
LATEST_W_V=$(curl --silent "https://api.github.com/repos/pdf/zfs_exporter/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^\"]+)".*/\1/')

pushd ./tmp && \
wget https://github.com/pdf/zfs_exporter/releases/download/${LATEST}/zfs_exporter-${LATEST_W_V}.linux-amd64.tar.gz -O zfs_exporter-${LATEST_W_V}.linux-amd64.tar.gz && \
tar -xf zfs_exporter-${LATEST_W_V}.linux-amd64.tar.gz && \
cp zfs_exporter-${LATEST_W_V}.linux-amd64/zfs_exporter . && \
rm -rf zfs_exporter-${LATEST_W_V}.linux-amd64* && \
chmod +x ./zfs_exporter && \
popd
