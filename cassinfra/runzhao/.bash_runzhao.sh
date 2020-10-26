# this file should be sourced by ~/.bashrc

alias ltr='ls -ltr'
alias si='sudo -i'
alias t-l='tess login'
alias t-c='tess clusters'
alias k-cu='kubectl config use-context'
alias k-cc='kubectl config current-context'
alias k-getpods='kubectl get pod -n cassini-system -o wide'
alias ssh-runzhao='ssh -l runzhao'

dump_file=/home/runzhao/upload/runzhao/dump_file

UsageMysql() {
    func_name=$1
    cat <<-EOF
Usage:

SYNOPSISI
    $func_name      [options] [sql_stmt]

OPTIONS
    -h              print help(Usage) message
    -n              no header
    -s              silent mode
    -d database     connect to specified database

argument
    sql_stmt        sql statement
EOF
}

function ipmi-run() {
    bmc_ip="$1"
    command="$2"
    ipmitool -I lanplus -H "$bmc_ip" -U console -P 'Lghsf0k!' ${command}
}

function gssh() {
    local host=$1
    local command="$2"
    local timeout="${3:-15}"

    sshpass -p "sixie@WSX3edc4rfv" ssh -q -o StrictHostKeyChecking=no -o ConnectTimeout="$timeout" "$host" "${command}" </dev/null
}

function gssh-set-status() {
    host="$1"
    admin_status="$2"
    asset_status="${3:-prep}"
    admin_notes="${4:-__NO_ACTION__}"
    changeProdStatus=/ebay/git/search/bin/changeProdStatus.py
    sudo -u runzhao $changeProdStatus $host -a "$admin_status" -s "$asset_status" -n "$admin_notes"
}

function mysql-root() {
    local comm="mysql -u root -h sbe-dbrokar-phx-001.vip.ebay.com -pdura5x"
    local SHORT=hnsd:
    local OPTS
    if ! OPTS=$(getopt --option $SHORT --name "$0" -- "$@"); then
        echo "Failed to parse options...terminating..."
        return 1
    fi

    eval set -- "${OPTS}"

    while true; do
        case "$1" in
        -h | --help)
            UsageMysql $FUNCNAME
            shift
            return
            ;;
        -n | --no-header)
            comm="$comm -N "
            shift
            ;;
        -s | --silent)
            comm="$comm -s "
            shift
            ;;
        -d | --database)
            comm="$comm -D$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Internal error!"
            UsageMysql $FUNCNAME
            return 1
            ;;
        esac
    done

    if [[ ($# -gt 1) || ($# -lt 0) ]]; then
        UsageMysql $FUNCNAME
        return 1
    fi

    local sql_stmt="$1"

    if [[ -z "$sql_stmt" ]]; then
        sudo $comm
    else
        sudo $comm -e "$sql_stmt" | column -t
    fi
}

gssh-get-env() {
    local host=$1
    gssh "$host" "find /ebay/cronus/software/service_nodes/ -maxdepth 1 -mindepth 1 | xargs -I{} du -sh {}"
}

gssh-get-metricdumpd() {
    local host=$1
    local command="find /ebay/cronus/software/cronusapp_home/services/metricdumpd/heartbeat.txt -mtime -1 2>/dev/null | grep heartbeat.txt &>/dev/null"
    gssh "$host" "$command"
    local ret_code=$?
    [[ $ret_code -eq 0 ]] && echo "metricdumpd OK" || echo "metricdumpd failed"
    return $ret_code
}

gssh-reset-metricdumpd() {
    local host=$1
    if gssh-get-metricdumpd "$host" &>/dev/null; then
        echo "metricdumpd OK"
        return
    fi
    local command="cd /ebay/cronus/software/cronusapp_home/; chown cronus.app services/; systemctl stop metricdumpd.service && test -f /ebay/cronus/software/cronusapp_home/services/metricdumpd/metricdumpd.pid && rm -rf /ebay/cronus/software/cronusapp_home/services/metricdumpd/metricdumpd.pid"
    echo "shutting down metricdumpd"
    gssh "$host" "$command"
    sleep 3
    local command="systemctl start metricdumpd.service"
    echo "starting metricdumpd"
    gssh "$host" "$command"
    local retv=1
    local round=0
    while [[ $retv -ne 0 && round -le 10 ]]; do
        gssh-get-metricdumpd "$host" &>/dev/null
        retv=$?
        echo "has beeen waiting for $((round * 3)) second, returned $retv"
        sleep 3
        ((round++))
    done
    if [[ $round -ge 10 ]]; then
        echo "max time tried, fixing metricdumpd failed"
    fi
}

gssh-stop-container() {
    local host=$1
    gssh "$host" "cassinictl stop"
}

gssh-status-container() {
    local host=$1
    local timeout="${2:-15}"
    if ! gssh "$host" "cassinictl status" "$timeout"; then
        echo "container is down"
        return 1
    fi
}

gssh-reboot() {
    local host=$1
    gssh "$host" "systemctl reboot"
}

gssh-get-hugepages() {
    local host=$1
    local nr_hugepages_expected=$2
    local nr_hugepages_conf=$(gssh "$host" "sysctl -n vm.nr_hugepages")
    if [ -z "$nr_hugepages_expected" ]; then
        echo $nr_hugepages_conf
    elif [ "$nr_hugepages_expected" != "$nr_hugepages_conf" ]; then
        echo "nr_hugepages_expected ($nr_hugepages_expected) not equal to nr_hugepages_conf ($nr_hugepages_conf)"
        return 1
    fi
}

gssh-set-hugepages() {
    local nr_hugepages=$1
    local host=$2

    if [[ -z "$host" || -z "$nr_hugepages" ]]; then
        echo "host or nr_hugepages must not be none"
        return 1
    fi

    if gssh-get-hugepages $host $nr_hugepages; then
        echo "hugepages is correct, nothing need to do"
        return
    fi

    if ! gssh-stop-container $host; then
        echo "warning: stop container failed or container is not running"
    fi

    if ! gssh-set-status $host "SACHECK"; then
        echo "warning: changeProdStatus to prep/SACHECK failed"
    fi

    if gssh $host 'grep nr_hugepages /etc/sysctl.conf' &>/dev/null; then
        if ! gssh $host "grep nr_hugepages /etc/sysctl.conf | grep $nr_hugepages" &>/dev/null; then
            local command="sed '{s/^vm\.nr_hugepages.*$/vm.nr_hugepages = $nr_hugepages/g}' /etc/sysctl.conf"
            gssh $host "echo '$(gssh "$host" "$command")' > /etc/sysctl.conf" &>/dev/null
        fi
    else
        gssh $host "echo 'vm.nr_hugepages = $nr_hugepages' >> /etc/sysctl.conf"
    fi

    if gssh $host "grep nr_hugepages /etc/sysctl.conf | grep $nr_hugepages"; then
        echo "set nr_hugepages to $nr_hugepages successfully"
    else
        echo "set nr_hugepages to $nr_hugepages failed, exting"
        return 1
    fi

    if [ $? -eq 0 ]; then
        echo "sleep 30 for system reboot"
        sleep 30
    fi

    local is_host_down=1
    local is_ssh_down=1
    local is_container_down=1
    while true; do
        if [ $is_host_down -eq 1 ]; then
            if ! ping -c2 -W2 "$host" &>/dev/null; then
                echo "host is down"
            else
                echo "host is up"
                is_host_down=0
            fi
        else
            echo "host is up"
        fi

        if [ $is_ssh_down -eq 1 ]; then
            if ! ssh -o ConnectTimeout=5 -T "$host" </dev/null &>/dev/null; then
                echo "ssh is down"
            else
                echo "ssh is up"
                is_ssh_down=0
            fi
        else
            echo "ssh is up"
        fi

        if [ $is_container_down -eq 1 ]; then
            if ! gssh-status-container "$host" &>/dev/null; then
                echo "container is down"
            else
                echo "container is up"
                is_container_down=0
            fi
        else
            echo "container is up"
        fi

        if [[ $is_host_down -eq 0 && $is_ssh_down -eq 0 && $is_container_down -eq 0 ]]; then
            echo "host is up"
            echo "ssh is up"
            echo "container is up"
            break
        fi

        sleep 3
    done

    if gssh-set-status $host "NORMAL"; then
        echo "$changeProdStatus $host to prep/NORMAL success"
    else
        echo "$changeProdStatus $host to prep/NORMAL failed"
    fi

    if gssh-get-hugepages $host $nr_hugepages; then
        echo "set hugepages to $nr_hugepages successfully"
    else
        echo "set hugepages to $nr_hugepages failed"
        return 1
    fi
}

gssh-set-hugepages-47000() {
    gssh-set-hugepages 47000 $1
}

gssh-get-disk-errors() {
    local host=$1
    if gssh "$host" "mdadm -D /dev/md?* | egrep '\bdegraded\b|\bfaulty\b'"; then
        {
            echo "$host"
            echo ""
            gssh "$host" "dmesg | grep -Ei '\berror\b|\bfail\b|\bexcept'"
            echo ""
            gssh "$host" "parted -l"
        } >$dump_file
    fi
}

gssh-get-memory-errors() {
    local host=$1
    {
        echo "$host"
        echo ""
        gssh $host "grep -E -e Error -e MCE /var/log/kern.log"
        echo ""
        gssh $host 'dmesg | egrep --color -i -e "\berror\b" -e "\bmce\b" -e "\bexception\b"'
    } >$dump_file
}

gssh-get-sudo() {
    local host=$1
    local user=$2
    if grep 'not allowed' <(gssh "$host" "sudo -lU $user"); then
        return 1
    else
        echo "user $user already have sudo privilege"
    fi
}

gssh-set-sudo() {
    local host=$1
    local user=$2
    if gssh-get-sudo $host $user; then
        return
    fi
    if gssh $host "grep $user /etc/sudoers" &>/dev/null; then
        echo "user $user already in /etc/sudoers"
    else
        gssh $host "echo '$user ALL = (ALL) ALL' >> /etc/sudoers"
    fi
}

gssh-clear-logs() {
    local host=$1
    gssh $host 'find /ebay/cronus/software/cronusapp_home/cassini/logs/ -type f -name "server_container.log.*" | xargs -I{} rm -rf {}'
    gssh $host '/ebay/cronus/software/service_nodes/logpusher-core/manifests/active/cassini_logpusher_config/cronus/scripts/deactivate'
    gssh $host '/ebay/cronus/software/service_nodes/logpusher-core/manifests/active/cassini_logpusher_config/cronus/scripts/activate'
    gssh $host '/ebay/cronus/software/service_nodes/logpusher-core/manifests/active/cassini_logpusher/cronus/scripts/deactivate'
    gssh $host '/ebay/cronus/software/service_nodes/logpusher-core/manifests/active/cassini_logpusher/cronus/scripts/activate'
    gssh $host '/ebay/cronus/software/service_nodes/logpusher-core/manifests/active/cassini_logpusher/cronus/scripts/startup'
    gssh $host "ps -u cronusapp -o user,ppid,pid,comm,args | awk '{if(\$4==\"java\" && \$(NF-1)~/logpusher\.jar/) print}'"
}