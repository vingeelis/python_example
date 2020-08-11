#!/usr/bin/env bash
# put this file in the project root dir

COLOR_RED="\033[0;31m"
COLOR_LIGHT_BLUE="\033[1;34m"

function colorize() {
    local COLOR_OFF='\033[0m'
    local color=$1
    local strings=$2
    printf "%b%s%b\n" "${color}${strings}${COLOR_OFF}"
}

function red() {
    colorize "${COLOR_RED}" "$1"
}

function blue() {
    colorize "${COLOR_LIGHT_BLUE}" "$1"
}

red "git pulling..."
cd ../
git pull
if [[ $? -eq 0 ]]; then
    blue "pull success"
else
    red "pull failed"
fi
