.PHONY: create_deploy_cred all gen_all_certs

all: create_deploy_cred gen_all_certs

create_deploy_cred: ssh_keys/id_deploy

gen_all_certs: root/ca.pem client/cert.pem docker/docker.pem

ssh_keys/id_deploy:
	mkdir -p ssh_keys
	ssh-keygen -f $@ -t ecdsa -b 256 -P "" -C ""
	chmod 400 ssh_keys/id_deploy

root/ca.pem:
	mkdir -p root
	cfssl gencert -initca ca-csr.json | cfssljson -bare root/ca -

client/cert.pem: root/ca.pem
	mkdir -p client
	cfssl gencert -ca=root/ca.pem -ca-key=root/ca-key.pem \
	-config=ca-config.json -profile=client client.json | \
	cfssljson -bare client/client
	mv client/client-key.pem client/key.pem
	mv client/client.pem client/cert.pem
	cp root/ca.pem client/ca.pem

docker/docker.pem: root/ca.pem
	mkdir -p docker
	cfssl gencert -ca=root/ca.pem -ca-key=root/ca-key.pem \
	-config=ca-config.json -profile=server server.json | \
	cfssljson -bare docker/docker