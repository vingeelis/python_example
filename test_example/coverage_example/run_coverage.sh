#!/usr/bin/bash


# should run pip install coverage first
coverage run app_test.py &>/dev/null
echo "----------------------------------------------------------------------"

coverage report -m