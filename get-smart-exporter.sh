#!/usr/bin/env bash

LATEST=$(curl --silent "https://api.github.com/repos/prometheus-community/smartctl_exporter/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^\"]+)".*/\1/')

pushd ./tmp && \
wget https://github.com/prometheus-community/smartctl_exporter/releases/download/${LATEST}/smartctl_exporter -O smart_exporter && \
chmod +x ./smart_exporter && \
popd
