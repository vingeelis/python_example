#!/usr/bin/env bash

cat cronus.out | perl -0777 -0ne '/Version.*?([\d.]+).*?<\/tr>/gs && print "$1\n"'


