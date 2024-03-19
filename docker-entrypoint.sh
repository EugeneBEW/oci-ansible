#!/usr/bin/env bash

set -Eeo pipefail

_is_sourced() {
	[ "${#FUNCNAME[@]}" -ge 2 ] \
	   && [ "${FUNCNAME[0]}" = '_is_sourced' ] \
	   && [ "${FUNCNAME[1]}" = 'source' ] 
}

docker_setup_env() {
	[ -f /ansible/.env ] && . /ansible/.env
}


_main() {
	docker_setup_env

	if [ "${1:0:1}" = "-" ]; then 
		[ "${1:0:2}" = "--" ] && shift
		set -- ansible-playbook "$@"
	fi

	exec "$@"
}



if ! _is_sourced; then
	_main "$@"
fi
