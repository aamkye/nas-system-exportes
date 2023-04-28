SHELL=/usr/bin/env bash -ex

all: get install enable run

get: prepare get-zfs-exporter get-smartctl-exporter get-node-exporter

clean: stop uninstall clean-tmp

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
	mkdir -p /bin/exporter/
	chmod 777 /bin/exporter/
	cp ./tmp/* /bin/exporter/
	ln -sf $(CURDIR)/systemd/zfs_exporter.service /etc/systemd/system/zfs_exporter.service
	ln -sf $(CURDIR)/systemd/node_exporter.service /etc/systemd/system/node_exporter.service
	ln -sf $(CURDIR)/systemd/smartctl_exporter.service /etc/systemd/system/smartctl_exporter.service
	
enable:
	systemctl daemon-reload
	systemctl enable zfs_exporter
	systemctl enable node_exporter
	systemctl enable smartctl_exporter

run:
	systemctl daemon-reload
	systemctl start zfs_exporter
	systemctl start node_exporter
	systemctl start smartctl_exporter

stop:
	systemctl daemon-reload
	systemctl stop zfs_exporter
	systemctl stop node_exporter
	systemctl stop smartctl_exporter

uninstall:
	rm -rf /bin/exporter/
	rm -f /etc/systemd/system/zfs_exporter.service
	rm -f /etc/systemd/system/node_exporter.service
	rm -f /etc/systemd/system/smartctl_exporter.service
	systemctl daemon-reload

clean-tmp:
	rm -rf ./tmp
