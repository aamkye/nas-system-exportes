SHELL:=/usr/bin/env bash -ex

all: get install run

get: prepare get-zfs-exporter get-smart-exporter get-node-exporter

clean: stop clean-tmp uninstall

restart: stop run

prepare:
	mkdir -p ./tmp

get-zfs-exporter:
	pushd ./tmp; \
	wget https://github.com/pdf/zfs_exporter/releases/download/v2.2.5/zfs_exporter-2.2.5.linux-amd64.tar.gz -O zfs_exporter-2.2.5.linux-amd64.tar.gz; \
	tar -xf zfs_exporter-2.2.5.linux-amd64.tar.gz; \
	cp zfs_exporter-2.2.5.linux-amd64/zfs_exporter .; \
	rm -rf zfs_exporter-2.2.5.linux-amd64*; \
	popd

get-smart-exporter:
	pushd ./tmp; \
	wget https://github.com/prometheus-community/smartctl_exporter/releases/download/smartctl_exporter_0.6/smartctl_exporter -O smart_exporter; \
	chmod +x ./smart_exporter; \
	popd

get-node-exporter:
	pushd ./tmp; \
	wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz -O node_exporter-1.3.1.linux-amd64.tar.gz; \
	tar -xf node_exporter-1.3.1.linux-amd64.tar.gz; \
	cp node_exporter-1.3.1.linux-amd64/node_exporter .; \
	rm -rf node_exporter-1.3.1.linux-amd64*; \
	popd

install:
	sudo mkdir -p /bin/exporter/
	sudo chmod 777 /bin/exporter/
	cp ./tmp/* /bin/exporter/
	sudo ln -sf $(CURDIR)/configs/smart_exporter.yml /etc/smart_exporter.yml
	sudo ln -sf $(CURDIR)/systemd/zfs_exporter.service /etc/systemd/system/zfs_exporter.service
	sudo ln -sf $(CURDIR)/systemd/node_exporter.service /etc/systemd/system/node_exporter.service
	sudo ln -sf $(CURDIR)/systemd/smart_exporter.service /etc/systemd/system/smart_exporter.service

run:
	sudo systemctl daemon-reload
	sudo systemctl start zfs_exporter
	sudo systemctl start node_exporter
	sudo systemctl start smart_exporter

stop:
	sudo systemctl stop zfs_exporter
	sudo systemctl stop node_exporter
	sudo systemctl stop smart_exporter

uninstall:
	sudo rm -rf /bin/exporter/
	sudo rm /etc/systemd/system/zfs_exporter.service
	sudo rm /etc/systemd/system/node_exporter.service
	sudo rm /etc/systemd/system/smart_exporter.service
	sudo systemctl daemon-reload

clean-tmp:
	rm -rf ./tmp
