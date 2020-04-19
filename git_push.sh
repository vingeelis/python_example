#!/usr/bin/env bash
#


COLOR_RED="\033[0;31m"
COLOR_LIGHT_BLUE="\033[1;34m"
COLOR_END="\033[0m"

GIT_TO_ADD="Untracked files"
GIT_TO_STAGE="Changes not staged for commit"
GIT_TO_COMMIT="Changes to be committed"
GIT_TO_PUSH="Your branch is ahead of"

dirs=(
	./
)


function pcl() {
    local COLOR_OFF="\033[0m"
    local color=$1
    local strings=$2
    printf "%b%s%b" "${color}${strings}${COLOR_OFF}"
}

for dir in ${dirs[@]}; do
    cd $(realpath $dir)

    need_push=$(git status | awk \
        -v TO_ADD="${GIT_TO_ADD}" \
        -v TO_STAGE="${GIT_TO_STAGE}" \
        -v TO_COMMIT="${GIT_TO_COMMIT}" \
        -v TO_PUSH="${GIT_TO_PUSH}" '
        BEGIN {flag="false"} 
        {if ($0 ~ TO_ADD || $0 ~ TO_STAGE || $0 ~ TO_COMMIT || $0 ~ TO_PUSH) flag="true"} 
        END {print flag}
    ')

    if [[ x"$need_push" == x"false" ]]; then
        continue
    fi

    pcl ${COLOR_LIGHT_BLUE} "[$dir]\$ "
    pcl ${COLOR_RED} "git pushing..."

    git add .
    git commit -m "$(date +'%F %t'): auto commit"
    git push
done
