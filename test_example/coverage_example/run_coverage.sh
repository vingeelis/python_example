#!/usr/bin/bash


# install coverage
# pip install -U coverage

# collect data
coverage run app_test.py &>/dev/null
echo "----------------------------------------------------------------------"

# run report
coverage report -m