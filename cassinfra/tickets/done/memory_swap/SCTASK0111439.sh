#!/usr/bin/env bash

# SCTASK0111439

# functions

function create_swap() {
    sudo dd if=/dev/zero of=/var/ebay/swap bs=4k count=5242880
    sudo chmod 600 /var/ebay/swap
    sudo mkswap /var/ebay/swap
    if ! file /var/ebay/swap | grep -E -o "$((5242880 - 1))"; then
        echo "swap count size error"
        return 1
    fi
    sudo swapon /var/ebay/swap
    if [[ $(free -m | grep Swap | awk '{print $2}') -eq 0 ]]; then
        echo "swap created failed"
        return 1
    fi
    if [[ "$(sudo swapon --show | grep '/var/ebay/swap' | awk '{print $3}')" != "20G" ]]; then
        echo "swap size error"
    fi
    if ! grep '/var/ebay/swap' /etc/fstab; then
        cat <<EOF | sudo tee -a /etc/fstab
/var/ebay/swap   swap    swap    sw    0   0
EOF
    fi
    if ! grep '/var/ebay/swap' /etc/fstab; then
        echo "fstab entry appended failed"
        return 1
    fi
    echo "all success"
}


function set-hugepages-47000-tess() {
    h=$1
    gssh-set-hugepages-tess $h 47000
}

function set-hugepages-47000-bm() {
    h=$1
    gssh-set-hugepages-bm $h 47000
}

function set-hugepages-140000-tess() {
    h=$1
    gssh-set-hugepages-tess $h 140000
}

function set-hugepages-140000-bm() {
    h=$1
    gssh-set-hugepages-bm $h 140000
}


function verify() {
    command="$1"
    shift
    hosts="$*"
    for h in $hosts; do
        if ! host $h &>/dev/null; then
            echo "$h error: host not found"
            continue
        fi
        if ! ping -c3 -W3 $h &>/dev/null; then
            echo "$h error: host not pingable"
            continue
        fi
        echo -n "$h "
        ssh -q -o ConnectTimeout=15 $h "$command"
    done
}



# create memory swap
sibe3-qry-rno-001-00{1..8}
sibe3-qry-lvs-001-00{1..8}
sibe3-qry-slc-001-00{1..8}

# verify
verify "free -m | grep --color Swap" sibe3-qry-rno-001-00{1..8}
verify "free -m | grep --color Swap" sibe3-qry-lvs-001-00{1..8}
verify "free -m | grep --color Swap" sibe3-qry-slc-001-00{1..8}



# set hugepages
sibe3-qry-rno-001-00{1..8}
sibe3-qry-lvs-001-00{1..8}
sibe3-qry-slc-001-00{1..8}
sibe3brn-qry-rno-001-00{1..3}
sibe3prep-qry-lvs-001-00{1..3}

# verify
verify "sysctl -n vm.nr_hugepages" sibe3-qry-rno-001-00{1..8}
verify "sysctl -n vm.nr_hugepages" sibe3-qry-lvs-001-00{1..8}
verify "sysctl -n vm.nr_hugepages" sibe3-qry-slc-001-00{1..8}
verify "sysctl -n vm.nr_hugepages" sibe3brn-qry-rno-001-00{1..3}
verify "sysctl -n vm.nr_hugepages" sibe3prep-qry-lvs-001-00{1..3}



