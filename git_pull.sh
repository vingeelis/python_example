#!/usr/bin/env bash
#


COLOR_RED="\033[0;31m"
COLOR_LIGHT_BLUE="\033[1;34m"
COLOR_END="\033[0m"

dirs=(
    ./
)

function pcl() {
    local COLOR_OFF='\033[0m'
    local color=$1
    local strings=$2
    printf "%b%s%b" "${color}${strings}${COLOR_OFF}"
}


for dir in ${dirs[@]}; do
    cd $(realpath $dir)

    # clear scratches_
    if [[ -d "scratches_" ]]; then
        pcl ${COLOR_LIGHT_BLUE} "[$dir]\$ "
        pcl ${COLOR_RED} "clearing scratches...\n"
        rm -rf scratches_/*
    fi

    # git pull
    # printf "[%b]\$ %b" "${COLOR_LIGHT_BLUE}${dir}${COLOR_END}" "${COLOR_RED}git pulling...${COLOR_END}"
    pcl ${COLOR_LIGHT_BLUE} "[$dir]\$ "
    pcl ${COLOR_RED} "git pulling..."
    git pull

done
