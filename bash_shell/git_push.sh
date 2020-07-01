#!/usr/bin/env bash
#

COLOR_RED="\033[0;31m"
COLOR_LIGHT_BLUE="\033[1;34m"

function colorize() {
    local COLOR_OFF='\033[0m'
    local color=$1
    local strings=$2
    printf "%b%s%b\n" "${color}${strings}${COLOR_OFF}"
}

function red() {
    colorize "${COLOR_RED}" $1
}

function blue() {
    colorize "${COLOR_LIGHT_BLUE}" $1
}

will_push=$(git status | awk \
    -v TO_ADD="Untracked files" \
    -v TO_STAGE="Changes not staged for commit" \
    -v TO_COMMIT="Changes to be committed" \
    -v TO_PUSH="Your branch is ahead of" '
    BEGIN {flag="false"}
    {if ($0 ~ TO_ADD || $0 ~ TO_STAGE || $0 ~ TO_COMMIT || $0 ~ TO_PUSH) flag="true"}
    END {print flag}
')

if [[ x"$will_push" == x"false" ]]; then
    exit
fi

red "git pulling..."
cd ../
git add .
git commit -m "$(date +'%F %t'): auto commit"
git push
if [[ $? -eq 0 ]]; then
    blue "push success"
else
    red "pull failed"
fi
