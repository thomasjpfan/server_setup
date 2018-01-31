#!/bin/sh

pytest --connection=docker tests/test_install_services.py
pytest tests/test_manager_cli.py
