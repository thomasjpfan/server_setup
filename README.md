# Secure Server Setup

Set of playbooks that setups a secure server.

## Setup

1. Clone this repo.
1. Define `ROOTDNS` to be your root domain name, and `PRIVATE_DIR` to be your private directory to hold private keys.
1. Define `SSH_OPEN_PORT` to be the ssh port and `DOCKER_OPEN_PORT` to be the open docker port for cli.
1. Create a private directory using `make create_private_dir` and install `cfssl`.
1. Go into private directory and run `make all`.
1. Encrypt `deploy_cred.yml` and certs in private directory using `ansible vault`.
1. Install requirements `./cli.sh require`
1. Setup root hosts `./cli.sh root -l api1.server.com -k`
1. Setup services `./cli.sh services`
1. Update hostname if necessary `./cli.sh hostname`.

After setting up the private directory, it should be encrypted. This repo does not contain any keys to access your hosts.

## Troubleshooting

1. _`api1.server.com` is down, I must use another manager to run the docker daemon!_: Remove `api1.server.com` from the `docker_swarm_manager_open` group and add a working host to the group. Then run `./cli.services -l api2.server.com -t docker-port`. Update `docker.sh` with the new `DOCKER_HOST`.

2. _I want to add another server to the docker swarm_: Add the server into `inv_root` and `inv_deploy`. Run `./cli.sh root -l api2.server.com`, `./cli.sh services -l api2.server.com -t "services,docker-install"`, and `./cli.sh services -t "docker-cluster"`.

## Local Testing

The `tests/playbook.yml` file includes a pre-tasks that adds a ubuntu cacher configuration for local testing. You can start your own cacher by running:

```bash
docker network create ng
docker run --name apt-cacher -d --restart=always \
  --publish 3142:3142 \
  --volume /srv/docker/apt-cacher-ng:/var/cache/apt-cacher-ng \
  --network ng \
  sameersbn/apt-cacher-ng:latest
```

Then run:

```bash
make setup_test_local
make root_test
make install_services_test
make clean_up_local
```

## License

MIT
