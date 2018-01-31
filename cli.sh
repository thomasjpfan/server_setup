#!/usr/bin/env sh
set -e

PRIVATE_DIR=${PRIVATE_DIR:-"private"}

root_setup() {
	cmd="ansible-playbook -i $PRIVATE_DIR/inv_root $* root_setup.yml"
	echo "$cmd"
	$cmd
}

install_services() {
	cmd="ansible-playbook -i $PRIVATE_DIR/inv_deploy $* install_services.yml"
	echo "$cmd"
	$cmd
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
	*)
		usage
		;;
esac
