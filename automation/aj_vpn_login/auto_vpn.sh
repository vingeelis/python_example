#!/usr/bin/env bash

COMM=/usr/bin/MotionPro
VPN_IP="180.167.70.86:10443"
USERNAME="sx"
PASSWORD="ajzq3301"


function vpn_start() {
    $COMM -h $VPN_IP -u $USERNAME -p $PASSWORD
}

function vpn_stop() {
    $COMM -s
}

function prompt_help() {
    cat << EOH >&2
1) start vpn :
    bash $0 start
2) stop vpn :
    bash $0 stop
EOH
}


if [[ $# -ne 1 ]]; then
    prompt_help
fi

case $1 in 
    start)
        vpn_start
        ;;
    stop)
        vpn_stop
        ;;
    *)
esac