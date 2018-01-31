.PHONY: create_private_dir

PRIVATE_DIR?=tests/private
ROOTDNS?=server.com
SSH_OPEN_PORT?=32795
DOCKER_OPEN_PORT?=2376

create_private_dir: $(PRIVATE_DIR)

$(PRIVATE_DIR):
	mkdir -p $@
	cp private_template/ca-*.json $@
	cp private_template/client.json $@
	cp private_template/deploy_cred.yml $@
	cp private_template/Makefile $@

	sed 's/ROOTDNS/$(ROOTDNS)/g' \
	private_template/docker.sh | \
	sed 's/DOCKER_OPEN_PORT/$(DOCKER_OPEN_PORT)/g' > \
	$@/docker.sh

	sed 's/ROOTDNS/$(ROOTDNS)/g' \
	private_template/inv_deploy | \
	sed 's/SSH_OPEN_PORT/$(SSH_OPEN_PORT)/g' | \
	sed 's/DOCKER_OPEN_PORT/$(DOCKER_OPEN_PORT)/g' > \
	$@/inv_deploy

	sed 's/ROOTDNS/$(ROOTDNS)/g' \
	private_template/inv_root > $@/inv_root

	sed 's/ROOTDNS/$(ROOTDNS)/g' \
	private_template/server.json > $@/server.json

## Testing

.PHONY: setup_test_local clean_up_local root_cli root_test services_cli services_test setup_test clean_up both_test

ROOT_INV?=tests/inv_root
DEPLOY_INV?=tests/inv_deploy

both_test: root_test services_test

services_cli:
	docker exec -ti \
	-e "INVENTORY_PATH=$(DEPLOY_INV)" \
	-e "PLAYBOOK_PATH=install_services.yml" \
	-e "TEST_PATH=tests/run_install_services_test.sh" \
	tests_runner_1 /bin/sh

services_test:
	docker exec -ti \
	-e "INVENTORY_PATH=$(DEPLOY_INV)" \
	-e "PLAYBOOK_PATH=install_services.yml" \
	-e "TEST_PATH=tests/run_install_services_test.sh" \
	tests_runner_1 cli all

root_cli:
	docker exec -ti \
	-e "INVENTORY_PATH=$(ROOT_INV)" \
	-e "PLAYBOOK_PATH=root_setup.yml" \
	-e "TEST_PATH=tests/run_root_setup_tests.sh" tests_runner_1 /bin/sh

root_test:
	docker exec -ti \
	-e "INVENTORY_PATH=$(ROOT_INV)" \
	-e "PLAYBOOK_PATH=root_setup.yml" \
	-e "TEST_PATH=tests/run_root_setup_tests.sh" tests_runner_1 \
	sh -c "cli requirements && \
	cli lint && \
	cli syntax_check && \
	cli converge && \
	cli run_test"

setup_test_local:
	docker-compose -f tests/docker-compose-local.yml up -d

clean_up_local:
	docker-compose -f tests/docker-compose-local.yml down

setup_test:
	docker-compose -f tests/docker-compose.yml up -d

clean_up:
	docker-compose -f tests/docker-compose.yml down
