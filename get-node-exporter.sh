#!/usr/bin/env bash

LATEST=$(curl --silent "https://api.github.com/repos/prometheus/node_exporter/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^\"]+)".*/\1/')
LATEST_W_V=$(curl --silent "https://api.github.com/repos/prometheus/node_exporter/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^\"]+)".*/\1/')

pushd ./tmp && \
wget https://github.com/prometheus/node_exporter/releases/download/${LATEST}/node_exporter-${LATEST_W_V}.linux-amd64.tar.gz -O node_exporter-${LATEST_W_V}.linux-amd64.tar.gz && \
tar -xf node_exporter-${LATEST_W_V}.linux-amd64.tar.gz && \
cp node_exporter-${LATEST_W_V}.linux-amd64/node_exporter . && \
rm -rf node_exporter-${LATEST_W_V}.linux-amd64* && \
popd
