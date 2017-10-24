#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root."
	exit 1
fi

mkdir -p /opt/bin

curl -L "https://github.com/docker/compose/releases/download/1.16.1/docker-compose-$(uname -s)-$(uname -m)" -o /opt/bin/docker-compose

chmod +x /opt/bin/docker-compose

# Test

docker -v

docker-compose -v
