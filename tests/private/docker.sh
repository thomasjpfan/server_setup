#!/usr/bin/env sh

PRIVATE_DIR=${PRIVATE_DIR:-"$PWD/private"}

export DOCKER_TLS_VERIFY=1
export DOCKER_HOST=tcp://api1.server.com:2376
export DOCKER_CERT_PATH=$PRIVATE_DIR/client
