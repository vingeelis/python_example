#!/usr/bin/bash



# run test from parent dir if test file contains relatively import text, for example: from .package import *
#
export PYTHONPATH="/home/$(whoami)/gitrepo/python_example"
cd ..
python -m unittest -v relatively_.mydict_test.TestDict