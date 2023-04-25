SHELL=/usr/bin/env bash -ex

all: get install run

get: prepare get-zfs-exporter get-smartctl-exporter get-node-exporter

clean: stop clean-tmp uninstall

restart: stop run

prepare:
	mkdir -p ./tmp

get-zfs-exporter:
	./get-zfs-exporter.sh

get-smartctl-exporter:
	./get-smartctl-exporter.sh

get-node-exporter:
	./get-node-exporter.sh

install:
	sudo mkdir -p /bin/exporter/
	sudo chmod 777 /bin/exporter/
	cp ./tmp/* /bin/exporter/
	sudo ln -sf $(CURDIR)/configs/smartctl_exporter.yml /etc/smartctl_exporter.yml
	sudo ln -sf $(CURDIR)/systemd/zfs_exporter.service /etc/systemd/system/zfs_exporter.service
	sudo ln -sf $(CURDIR)/systemd/node_exporter.service /etc/systemd/system/node_exporter.service
	sudo ln -sf $(CURDIR)/systemd/smartctl_exporter.service /etc/systemd/system/smartctl_exporter.service

run:
	sudo systemctl daemon-reload
	sudo systemctl start zfs_exporter
	sudo systemctl start node_exporter
	sudo systemctl start smartctl_exporter

stop:
	sudo systemctl stop zfs_exporter
	sudo systemctl stop node_exporter
	sudo systemctl stop smartctl_exporter

uninstall:
	sudo rm -rf /bin/exporter/
	sudo rm -f /etc/systemd/system/zfs_exporter.service
	sudo rm -f /etc/systemd/system/node_exporter.service
	sudo rm -f /etc/systemd/system/smartctl_exporter.service
	sudo systemctl daemon-reload

clean-tmp:
	rm -rf ./tmp
