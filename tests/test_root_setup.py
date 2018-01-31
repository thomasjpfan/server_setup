import pytest

testinfra_hosts = ['tests_api1_1', 'tests_api2_1']


@pytest.mark.parametrize('package', ['iproute2', 'openssh-server'])
def test_packages_installed(host, package):
    assert host.package(package).is_installed
