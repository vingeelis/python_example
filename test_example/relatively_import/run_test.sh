#!/usr/bin/bash



# run test from parent dir if test file contains relatively import text, for example: from .package import *
#
cd ..
python -m unittest relatively_import.mydict_test.TestDict