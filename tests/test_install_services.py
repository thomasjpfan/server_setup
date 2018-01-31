import pytest


testinfra_hosts = ['tests_api2_1', 'tests_api2_1']

services = [
    'fail2ban',
    'ntp',
    'unattended-upgrades',
    'ufw'
]


@pytest.mark.parametrize('service', services)
def test_fail2ban_active(host, service):
    h_service = host.service(service)
    assert h_service.is_running
    assert h_service.is_enabled


def test_swarm_is_active(host):
    cmd = "docker info -f '{{ .Swarm.LocalNodeState }}'"
    output = host.check_output(cmd)
    assert output == "active"
