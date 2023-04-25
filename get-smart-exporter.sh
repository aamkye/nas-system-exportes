#!/usr/bin/env bash

LATEST=$(curl --silent "https://api.github.com/repos/prometheus-community/smartctl_exporter/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^\"]+)".*/\1/')
LATEST_W_V=$(curl --silent "https://api.github.com/repos/prometheus-community/smartctl_exporter/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^\"]+)".*/\1/')

pushd ./tmp && \
wget https://github.com/prometheus-community/smartctl_exporter/releases/download/${LATEST}/smartctl_exporter-${LATEST_W_V}.linux-amd64.tar.gz -O smartctl_exporter-${LATEST_W_V}.linux-amd64.tar.gz && \
tar -xf smartctl_exporter-${LATEST_W_V}.linux-amd64.tar.gz && \
cp smartctl_exporter-${LATEST_W_V}.linux-amd64/smartctl_exporter . && \
rm -rf smartctl_exporter-${LATEST_W_V}.linux-amd64* && \
chmod +x ./smart_exporter && \
popd
