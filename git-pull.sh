#!/usr/bin/env bash
# put this file in the project root dir

COLOR_OFF="\033[0m"
RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"

function colorize() {
  local COLOR_OFF='\033[0m'
  local color=$1
  local strings=$2
  printf "%b%s%b\n" "${color}${strings}${COLOR_OFF}"
}

root_dir=$(dirname "$(realpath $0)")
colorize "$BLUE" "$root_dir: git pulling..."
cd "$root_dir" || {
    colorize "$RED" "$root_dir: not exists"
    exit
}
if git pull; then
  colorize "$GREEN" "$root_dir: pull succeeded"
else
  colorize "$RED" "$root_dir: pull failed"
fi
