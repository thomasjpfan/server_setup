#!/usr/bin/env sh
set -e

PRIVATE_DIR=${PRIVATE_DIR:-"private"}

run_playbook() {
	playbook="$1"
	shift 1

	cmd="ansible-playbook -e private_root=$PRIVATE_DIR $* $playbook"
	echo "$cmd"
	$cmd
}

root_setup() {
	run_playbook "root_setup.yml" -i $PRIVATE_DIR/inv_root "$@"
}

install_services() {
	run_playbook "install_services.yml" -i $PRIVATE_DIR/inv_deploy "$@"
}

hostname() {
	run_playbook "hostname.yml" -i $PRIVATE_DIR/inv_deploy"$@"
}

ping() {
	ansible -i $PRIVATE_DIR/inv_deploy -m ping all
}

requirements() {
	if [ -f "requirements.yml" ]; then
		ansible-galaxy install -r requirements.yml
	fi
}

usage() {
	echo "usage: $0 (root|services)"
	echo "  root: Runs root setup"
	echo "  services: Install services"
	echo "  require: Install requirements"
	echo "  hostname: Change hostname to ansible_host"
	echo "  ping: Ping servers"
	exit 1
}

cmd="$1"
args=""
if [ "$#" -gt 1 ]; then
	shift 1
	args="$*"
fi
case "$cmd" in
	root)
		root_setup "$args"
		;;
	services)
		install_services "$args"
		;;
	require)
		requirements "$args"
		;;
	hostname)
		hostname "$args"
		;;
	ping)
		ping "$args"
		;;
	*)
		usage
		;;
esac
