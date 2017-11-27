#!/usr/bin/env bash

V="1.0.0" # The version number of this script.

PROG=$0
COMPOSEVERSION=""

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root."
	exit 1
fi

main() {

	while getopts ":hVv:" opt; do
		case ${opt} in
			h )
				usage
				exit 0
				;;
			V )
				version
				exit 0
				;;
			v )
				COMPOSEVERSION=$OPTARG # set the docker compose version.
				;;
			\? )
				echo "Invalid option: -$OPTARG" 1>&2
				echo
				usage
				exit 1
				;;
			: )
				echo "Invalid option: -$OPTARG requires an argument" 1>&2
				echo
				usage
				exit 1
				;;
		esac
	done
	shift $((OPTIND -1))

	run
}

usage() {
	echo "Usage: $PROG"
	echo "      Install docker-compose on CoreOS Container Linux."
	echo "  -v"
	echo "      Supply the docker-compose version number to install."
	echo "  -h"
	echo "      Display this help message."
	echo "  -V"
	echo "      Display this script's version number and exit."
}

version() {
	echo "$PROG version $V"
}

run() {
	if [[ -z "$COMPOSEVERSION" ]]; then
		echo "You must supply a docker-compose version number to install."
		echo "See https://github.com/docker/compose/releases for available releases."
		echo
		usage
		exit 1
	fi

	mkdir -p /opt/bin

	echo "Downloading docker-compose version ${COMPOSEVERSION}..."
	echo "https://github.com/docker/compose/releases/download/${COMPOSEVERSION}/docker-compose-$(uname -s)-$(uname -m)"
	curl -s -L "https://github.com/docker/compose/releases/download/${COMPOSEVERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /opt/bin/docker-compose

	chmod +x /opt/bin/docker-compose

	docker -v

	docker-compose -v
}

main $@

