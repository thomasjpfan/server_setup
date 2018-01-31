import subprocess

cmd_s = ("docker --tlsverify --tlscacert=tests/private/client/ca.pem "
         "--tlscert=tests/private/client/cert.pem "
         "--tlskey=tests/private/client/key.pem -H=api1:2376").split(" ")


def test_node_is_manager():
    cmd = ["info", "-f", "{{ .Swarm.ControlAvailable }}"]
    output = subprocess.run(cmd_s + cmd, stdout=subprocess.PIPE)
    assert output.returncode == 0
    assert output.stdout == b"true\n"


def test_number_of_managers():
    cmd = ["info", "-f", "{{ .Swarm.Managers }}"]
    output = subprocess.run(cmd_s + cmd, stdout=subprocess.PIPE)
    assert output.returncode == 0
    assert output.stdout == b"1\n"


def test_number_of_workers():
    cmd = ["info", "-f", "{{ .Swarm.Nodes }}"]
    output = subprocess.run(cmd_s + cmd, stdout=subprocess.PIPE)
    assert output.returncode == 0
    assert output.stdout == b"2\n"


def test_docker_env():
    cmd = ["/usr/local/bin/docker", "version"]
    d_env = {
        "DOCKER_TLS_VERIFY": "1",
        "DOCKER_HOST": "tcp://api1:2376",
        "DOCKER_CERT_PATH": "tests/private/client"
    }
    o = subprocess.Popen(
        cmd, env=d_env, stdout=subprocess.PIPE).wait()
    assert o == 0
