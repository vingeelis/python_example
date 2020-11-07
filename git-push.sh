#!/usr/bin/env bash
# put this file in the project root dir

COLOR_OFF='\033[0m'
RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"

colorize() {
    local COLOR_OFF='\033[0m'
    local color=$1
    local strings=$2
    printf "%b%s%b\n" "${color}${strings}${COLOR_OFF}"
}

todo=$(git status | awk \
    -v TO_ADD="Untracked files" \
    -v TO_STAGE="Changes not staged for commit" \
    -v TO_COMMIT="Changes to be committed" \
    -v TO_PUSH="Your branch is ahead of" '
    BEGIN {flag="false"}
    {if ($0 ~ TO_ADD || $0 ~ TO_STAGE || $0 ~ TO_COMMIT || $0 ~ TO_PUSH) flag="true"}
    END {print flag}
')

if [[ x"$todo" == x"false" ]]; then
    colorize $BLUE "nothing to push"
    exit
fi

root_dir=$(dirname "$(realpath $0)")
colorize "$BLUE" "$root_dir: git pushing..."
cd "$root_dir" || {
    colorize "$RED" "$root_dir: not exists"
    exit
}
git add .
git commit -m "$(date +'%F %t'): auto commit"
if git push; then
    colorize "$GREEN" "$root_dir: push succeeded"
else
    colorize "$RED" "$root_dir: push failed"
fi
