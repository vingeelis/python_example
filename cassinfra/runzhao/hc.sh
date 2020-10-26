#!/usr/bin/env bash
#echo 1 >>/var/tmp/log.txt
/bin/ping -q -c 1 "$1" >/dev/null
if [ $? -eq 0 ]; then
    /var/tmp/test-ssh-hung.pl "$1" >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo '{'
        echo '"OverallSystemHealth": "Unhealthy",'
        echo '"Unhealthy": {'
        echo '"SSH_Failure": "SSH Failure-Hung-20sec_timeout"'
        echo '}'
        echo '}'
        ssh-agent -k >/dev/null 2>&1
        exit
    fi
    eval "$(ssh-agent)" >/dev/null 2>&1
    trap 'kill "${SSH_AGENT_PID}"' 0
    cd /var/tmp || exit
    ssh-add ./id_dsa >/dev/null 2>&1
    #echo 2 >>/var/tmp/log.txt
    /usr/bin/ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no root@"$1" 'exit'
    #echo 'return was' $?
    if [ $? -eq 0 ]; then #status=$(/usr/bin/ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no root@$1 echo OK 2>&1)
        #echo $status
        #if [[ $status == OK ]]
        /usr/bin/scp -o StrictHostKeyChecking=no /ebay/search/www/html/casshealthchk.pl root@"$1":/var/tmp/
        /usr/bin/ssh -o StrictHostKeyChecking=no root@"$1" '/var/tmp/casshealthchk.pl -j'
        ssh-agent -k >/dev/null 2>&1
    else
        echo '{'
        echo '"OverallSystemHealth": "Unhealthy",'
        echo '"Unhealthy": {'
        echo '"SSH_Failure": "SSH Failure"'
        echo '}'
        echo '}'
        ssh-agent -k >/dev/null 2>&1
        #/usr/bin/scp -o StrictHostKeyChecking=no /var/www/html/casshealthchk.pl root@$1:/var/tmp/
        #echo 3 >>/var/tmp/log.txt
        #/usr/bin/ssh -o StrictHostKeyChecking=no root@$1 '/var/tmp/casshealthchk.pl -j'
    fi
else
    echo '{'
    echo '"OverallSystemHealth": "Unhealthy",'
    echo '"Unhealthy": {'
    echo '"Ping_Failure": "Host Down"'
    echo '}'
    echo '}'
fi
