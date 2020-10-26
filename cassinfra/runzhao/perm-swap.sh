#!/usr/bin/env bash

## host
host="$1"
host_ip=$(host -4 ${host} | awk '/address/{print $NF}')
host_rack=$(/ebay/search/bin/getFaultDomainOfHost.py ${host})
host_cluster=$(/ebay/search/bin/getClusterOfHost.py ${host} | awk '{print $1}')
host_appsvc=$(/ebay/search/bin/getApplicationServiceOfHost.py ${host})

## cache
# search Vcluster from page:{cassinfra.cache} of ${rack}
# make sure the Hosttype and DC are the same.
cache="$2"
cache_ip=$(host -4 ${cache} | awk '/address/{print $NF}')
cache_rack=$(/ebay/search/bin/getFaultDomainOfHost.py ${cache})
cache_vcluster="$(/ebay/search/bin/getClusterOfHost.py ${cache} | awk '{print $1}')"

if grep '\-tess' <(echo $host) &>/dev/null; then
    if grep 'tesscache\-' <(echo $cache_vcluster) &>/dev/null; then
        recommed_vcluster=${cache_vcluster}
    elif grep 'cache\-' <(echo $cache_vcluster) &>/dev/null; then
        recommed_vcluster=${cache_vcluster/cache/tesscache}
    fi
else
    if grep 'tesscache\-' <(echo $cache_vcluster) &>/dev/null; then
        recommed_vcluster=${cache_vcluster/tesscache/cache}
    elif grep 'cache\-' <(echo $cache_vcluster) &>/dev/null; then
        recommed_vcluster=${cache_vcluster}
    fi
fi

## sure to proceed?
function print_host_cache() {
    cat <<EOF
type host cache
hostname $host $cache
ip $host_ip $cache_ip
rack $host_rack $cache_rack
cluster $host_cluster $cache_vcluster
appsvc $host_appsvc
recommed_vcluster $recommed_vcluster
EOF
}

print_host_cache | column -t

read -p 'are you sure to proceed [y]: ' sure_to_proceed
if [ -n "$sure_to_proceed" ] && [ "$sure_to_proceed" != 'Y' ] && [ "$sure_to_proceed" != 'y' ]; then
    echo "you choose <$sure_to_proceed>, exiting..."
    exit
fi

## sync appsvc and cache vcluster
echo "sync appsvc and cache vcluster"
/ebay/search/bin/casswap_db.py --sync-appsvc ${host_appsvc}
/ebay/search/bin/casswap_db.py --sync-cache-vcluster ${cache_vcluster}

## perm-swap
echo "perm-swap from ${host} to ${cache}"
if ! /ebay/git/search/bin/perm-swap.py --host ${host} --with ${cache} --to-vcls auto; then
    echo "perm-swap failed"
    exit
fi

## sync appsvc and cache vcluster
echo "sync appsvc and cache vcluster"
/ebay/search/bin/casswap_db.py --sync-appsvc ${host_appsvc}
/ebay/search/bin/casswap_db.py --sync-cache-vcluster ${recommed_vcluster}

## verify_swap
function verify_swap() {
    cat <<EOF
type cache host
hostname $cache $host
ip $cache_ip $host_ip
rack $cache_rack $host_rack
cluster $(/ebay/search/bin/getClusterOfHost.py ${cache} | awk '{print $1}') $(/ebay/search/bin/getClusterOfHost.py ${host} | awk '{print $1}')
appsvc $(/ebay/search/bin/getApplicationServiceOfHost.py ${cache})
EOF
}

echo "check vcluster"
verify_swap | column -t

# generate fd_col report
sql_stmt="select * from view_percent_host_of_col_in_faultdomain where svc_cnt_in_total >= 6 and percentage > 20.0000 union
select * from view_percent_host_of_col_in_faultdomain where svc_cnt_in_total >= 4 and svc_cnt_in_total <= 5 and percentage > 45.00 union
select * from view_percent_host_of_col_in_faultdomain where svc_cnt_in_total >= 2 and svc_cnt_in_total <= 3 and percentage > 66.00;"

source ~runzhao/.bash_runzhao
mysql_root -n -s -d 'casswap' "$sql_stmt" 2>/dev/null | awk 'BEGIN{print "column\tfaultdomain\tsvc_cnt_in_fd\tsvc_cnt_in_total\tpercentage"}{ print $0 }' | column -t >/home/runzhao/upload/runzhao/columns_has_many_hosts_in_a_faultdomain
