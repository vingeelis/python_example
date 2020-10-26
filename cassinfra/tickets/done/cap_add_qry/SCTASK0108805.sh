#!/usr/bin/env bash

## SCTASK0108805

## Short description : Add row of active item to RNO

## description :
Add row of activeitem to RNO using assets from racks provisioned under TESS-28503:
The 4 P1EG7 racks to be added are:

RNOAZ04:
# duplicate assets or wrong NodeServer/label: (ASSET00607050, ASSET00607211)
MCC10-01-0510-1706
# duplicate assets or wrong NodeServer/label: (ASSET00607004, ASSET00607218)
# tess-node-4fwsg-tess69 should be excluded
MCC10-01-0510-3607
# duplicate assets or wrong NodeServer/label: (ASSET00607031, ASSET00606854)
# tess-node-htzvt-tess69 should be excluded
MCC10-01-0510-3710
# duplicate assets or wrong NodeServer/label: (ASSET00617040, ASSET00617515)
# tess-node-6cxms-tess69 should be excluded
MCC10-01-0510-3704

node-pool-cassini-69-p1eg7


## Business justification
capacity add

## Implementation plan
task_id=SCTASK0108805
change_id=CHG3374782
zone=rno
mkdir -p /home/runzhao/tickets/$task_id
cd /home/runzhao/tickets/$task_id || echo "cd failed"


## tell Oy <owong@ebay.com> of the new SKU of the server.

## check computes of racks using following CMS query,
Rack[@location="MCC10-01-0510-1706"].assets[@assetType="Server"]{@resourceId}.asset!AssetServer{@resourceId,@isAllocated}.nodeServer{@resourceId,@label}.managementServer!AssetServer{*}.nodeServer{@resourceId,@label}.nodeServer!Compute
# and make sure,
# these are 72 nodes per rack
# Asset/resourceId is the correct format of Asset
# AssetServer/resourceId is the correct format of ip address
# AssetServer/isAllocated is "false"
# NodeServer/resourceId is the correct format of ip address
# AssetServer/domain is "ebay.com"
# AssetServer/faultDomain is $RACK_ID
# AssetServer/healthState is "healthy"
# AssetServer/managedBy	is "tess_models"
# AssetServer/resourceOwner is "_tess_master"
# AssetServer/type is "container"


## check sku of racks using following CMS query,
Rack[@location="MCC10-01-0510-1706"].assets{@resourceId}.asset!AssetServer.configuredTo{@resourceId}
# and make sure,
# SkuConfiguration/resourceId is the correct SKU


## pick hostname(field: server) of servers from cache rack into corresponding rack files
racks029=(
MCC10-01-0510-1706
MCC10-01-0510-3607
MCC10-01-0510-3710
MCC10-01-0510-3704
)

# integrity check
wc -l MCC* | awk '{if($1<72) print}'
cat MCC* | sort | uniq -c | awk '{if($1>1) print}' | grep "*" && echo "duplicate" || echo "no duplicate"


## pick hosts
# pick 240(60 * 4) hosts for qry of row 029
for rack in "${racks029[@]}"; do
    cat $rack | sed -n '1,60p'
done > racks029.qry
test $(wc -l racks029.qry | awk '{print $1}') -eq 240 && echo "hosts ready" || echo "not enough hosts"

# pick 12(3 * 4) hosts for lla of row 029
for rack in "${racks029[@]}"; do
    cat $rack | sed -n '61,63p'
done > racks029.lla
test $(wc -l racks029.lla | awk '{print $1}') -eq 12 && echo "hosts ready" || echo "not enough hosts"

# integrity  check
wc -l racks* | test $(awk '/total/{print $1}') -eq 252 && echo "hosts all ready" || echo "not enough hosts"
cat racks* | sort | uniq -c | awk '{if($1>1) print}' | grep "*" && echo "duplicate" || echo "no duplicate"


## move vcluster
# move cache hosts from cache to qry
for host in $(cat racks*.qry); do
    /ebay/git/search/bin/moveVcluster.py $host "cassini-p1g7tesscache-${zone}" "activeitem5-qry-${zone}"
done | tee moveVcluster.qry

# rerun moveVcluster.py for the failed ones
test $(grep OK moveVcluster.qry | wc -l) -eq 240 || { echo "failed hosts of moveVcluster:"; diff <(cat racks*.qry | sort) <(grep '\-tess' moveVcluster.qry | sort); }

for host in $(cat racks*.qry); do
    echo -n "$host "
    /ebay/git/search/bin/getClusterOfHost.py $host
done | tee getClusterOfHost.qry

test $(grep CLjdm9lhblevl3v getClusterOfHost.qry | wc -l) -eq 240 || { echo "not all host were move to activeitem5-qry-$zone:"; diff <(cat racks*.qry | sort) <(grep '\-tess' getClusterOfHost.qry | sort); }

# move cache hosts from cache to lla
for host in $(cat racks*.lla); do
    /ebay/git/search/bin/moveVcluster.py $host "cassini-p1g7tesscache-${zone}" "activeitem5-lla-${zone}"
done | tee moveVcluster.lla

# rerun moveVcluster.py for the failed ones
test $(grep OK moveVcluster.lla | wc -l) -eq 12 || { echo "moveVcluster failed, failed hosts:"; diff <(cat racks*.lla | sort) <(grep '\-tess' moveVcluster.lla | sort); }

for host in $(cat racks*.lla); do
    echo -n "$host "
    /ebay/git/search/bin/getClusterOfHost.py $host
done | tee getClusterOfHost.lla

test $(grep CLjdm9o9o3evk2i getClusterOfHost.lla | wc -l) -eq 12 || { echo "not all host were move to activeitem5-lla-${zone}:"; diff <(cat racks*.lla | sort) <(grep '\-tess' getClusterOfHost.lla | sort); }


## add rows
/ebay/git/search/bin/add_row.py --appsvc "activeitem5-qry-${zone}:ENVgo3rsvfa" --racks <(for rack in "${racks029[@]}"; do echo $rack; done) --cr "$change_id" --simulate
# good to proceed if no errors raise
/ebay/git/search/bin/add_row.py --appsvc "activeitem5-qry-${zone}:ENVgo3rsvfa" --racks <(for rack in "${racks029[@]}"; do echo $rack; done) --cr "$change_id"



# verify FQDN of qry svcinst
cols=($(seq -w 001 240))
rows=(029)
for col in "${cols[@]}"; do
    for row in "${rows[@]}"; do
        host activeitem5-qry-${zone}-${col}-${row}
    done
done | tee svcinst_fqdn.qry
test $(wc -l svcinst_fqdn.qry | awk '{print $1}') -eq 480 || echo "not all svcinst have been added"

# verify FQDN of lla svcinst
rows=({337..348})
for row in "${rows[@]}"; do
    host activeitem5-lla-${zone}-001-${row}
done | tee svcinst_fqdn.lla
test $(wc -l svcinst_fqdn.lla | awk '{print $1}') -eq 24 || echo "not all svcinst have been added"


## sync db
/ebay/git/search/bin/casswap_db.py --sync-cache-vcluster "cassini-p1g7tesscache-${zone}"
/ebay/git/search/bin/casswap_db.py --sync-appsvc "activeitem5-qry-${zone}:ENVgo3rsvfa"
/ebay/git/search/bin/casswap_db.py --sync-appsvc "activeitem5-lla-${zone}:ENVgo3rsvfa"

source source ~runzhao/.bash_runzhao
mysql-root -ns -d 'casswap' "select count(1) from server s left join hosttype h on s.Hosttype = h.id where Svcinst like 'activeitem5-qry-${zone}-%-029';"   # should be 240
mysql-root -ns -d 'casswap' "select count(1) from server s left join hosttype h on s.Hosttype = h.id where Svcinst like 'activeitem5-lla-${zone}-001-%';"   # should be 335 + 13

mysql-root -ns -d 'casswap' "select distinct h.Name from server s left join hosttype h on s.Hosttype = h.id where Svcinst like 'activeitem5-qry-${zone}-%-029';"    # should be P1EG7
mysql-root -ns -d 'casswap' "select h.Name, count(hosttype) from server s left join hosttype h on s.Hosttype = h.id where Svcinst like 'activeitem5-lla-${zone}-001-%' group by hosttype;"    # P1EG7 should be 12


## add to cass-mon

# perform on cass-mon-1.stratus.slc.ebay.com

# sed conf and restart service
ssh cass-mon-1.stratus.slc.ebay.com
cd /ebay/monitor/conf/
conf=./MonitorSource.conf
# get the latest version of conf
old_v=$(rlog $conf | head | awk '/head:/ {print $2}') && echo $old_v
# check out conf with write permission
co -l $conf
# extend rno row number: 26 --> 29
sed -n '/Group RNO Active Item5 Row \[1\-26\]/s|26|29|p' $conf
# to proceed if no errors raised
sed -i '/Group RNO Active Item5 Row \[1\-26\]/s|26|29|g' $conf
# check diffs between head and head^1
rcsdiff $conf
# check in
ci -wrunzhao -u $conf
# check diffs between latest 2 versions
new_v=$(rlog $conf | head | awk '/head:/ {print $2}') && echo $new_v
rcsdiff -r$new_v -r$old_v $conf
# ssh exit back to Cassinfra
exit

# add row in columns
row_id=029      # new row id
for col in $(seq -w 001 240); do
    /ebay/git/search/bin/mcManualAddForCassini "${zone^^} Active Item5 ${col##+(0)} Query" "activeitem5-qry-${zone}-${col}-${row_id}:9177" "leaf"
done
# create new row service
/ebay/git/search/bin/mcManualAddForCassini "${zone^^} Active Item5 Row" "${zone^^} Active Item5 Row ${row_id##+(0)}"
/ebay/git/search/bin/mcManualAddForCassini "${zone^^} Active Item5 Row ${row_id##+(0)}" "${zone^^} Active Item5 Row ${row_id##+(0)} Query"
# add new rows service instance
for col in $(seq -w 001 240); do
    /ebay/git/search/bin/mcManualAddForCassini "${zone^^} Active Item5 Row ${row_id##+(0)} Query" "activeitem5-qry-${zone}-${col}-${row_id}" "leaf"
done
# add LLAs
row_id=029
LLAs_to=$((${row_id##+(0)} * 12))
LLAs_from=$((LLAs_to-11))
for row in $(seq $LLAs_from $LLAs_to); do
    /ebay/search/bin/mcManualAddForCassini "${zone^^} Active Item5 LLA" "activeitem5-lla-${zone}-001-${row}:9177" "leaf"
done


# restart cass-mon
ssh cass-mon-1.stratus.slc.ebay.com
# comment 2 crontab jobs (/ebay/monitor/bin/monitor-check-restart.sh, /ebay/monitor/bin/getdata-check-restart.sh) in case Monitor processes are not restarted by these cron jobs
crontab -e -u hoot
crontab -l -u hoot | tail -3
sudo -u hoot /ebay/monitor/bin/restartSNMon.sh

# uncomment 2 crontab jobs (/ebay/monitor/bin/monitor-check-restart.sh, /ebay/monitor/bin/getdata-check-restart.sh)
crontab -e -u hoot
crontab -l -u hoot | tail -3

# verify cass-mon.vip.ebay.com

# perform on cass-mon-2.stratus.slc.ebay.com 2 hour or few days later



## mail to topology-change and Oy
# DL-eBay-Cassini-Topology-Change
# owong@ebay.com



## Rollback plan
# delete rows
# sync db
# move hosts from lla && qry to corresponding cache


# Verification plan

## make sure there are corresponding amount of hosts are serving traffic in following rows:
activeitem5-qry-${zone}-{001..240}-029
activeitem5-lla-${zone}-001-{337..348}
