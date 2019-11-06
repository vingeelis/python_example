#!/usr/bin/bash


function hint() {
    echo "======================================================================"
    echo "run $1 unittest"
}

# run test for all *_test.py in the subdir
python -m unittest discover -v -p *_test.py