#!/usr/bin/env bash

## SCTASK0110696

## Short description : Add 3 Active Item P1EG7 rows to traffic in LVS as part of 2020 feature growth

## description :
PLEASE WAIT UNTIL AFTER TESS CONVERSION FINISHES
Add 3 Active Item P1EG7 rows to traffic in LVS as part of 2020 feature growth. This will also help to remove 3 rows of Active Item if needed for Tess conversion:

TESS-29229: Add Cassini P1EG7 racks to Tess 89 in LVSAZ03 to create an Active Item row
LVSAZ03:
LVS01-01-400-3003
LVS01-01-400-2905
LVS01-01-400-2901
LVS01-01-400-3404


TESS-29226: Add Cassini P1EG7 racks to Tess 122 in LVSAZ02 to create an Active Item row
LVSAZ02:
LVS02-01-830-1805
LVS02-01-830-1806
LVS02-01-830-1807
LVS02-01-830-1808


TESS-29541: Add Cassini P1EG7 racks to LVSAZ03 Tess 89 to create an Active Item row
LVSAZ03:
LVS01-01-400-0208
LVS01-01-400-0109
LVS01-01-400-3306
LVS01-01-540-0202


## Business justification
capacity add

## Implementation plan
mkdir -p ~/tickets/SCTASK0110696
cd ~/tickets/SCTASK0110696


## tell Oy <owong@ebay.com> of the new SKU of the server.

## check computes of racks using following CMS query,
Rack[@location="LVS01-01-400-3003"].assets[@assetType="Server"]{@resourceId}.asset!AssetServer{@resourceId,@isAllocated}.nodeServer{@resourceId,@label}.managementServer!AssetServer{*}.nodeServer{@resourceId,@label}.nodeServer!Compute
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
Rack[@location="LVS01-01-400-3003"].assets{@resourceId}.asset!AssetServer.configuredTo{@resourceId}
# and make sure,
# SkuConfiguration/resourceId is the correct SKU

## pick hostname(field: server) of servers from cache rack into corresponding rack files
racks024=(
LVS01-01-400-3003
LVS01-01-400-2905
LVS01-01-400-2901
LVS01-01-400-3404
)

# AssetServer/resourceOwner in these racks is _tess_cmsprod which is not the same as the other racks's AssetServer/resourceOwner(_tess_master)
racks025=(
LVS02-01-830-1805
LVS02-01-830-1806
LVS02-01-830-1807
LVS02-01-830-1808
)

racks030=(
LVS01-01-400-0208
LVS01-01-400-0109
LVS01-01-400-3306
LVS01-01-540-0202
)

# integrity check
wc -l LVS* | awk '{if($1<72) print}'
cat LVS* | sort | uniq -c | awk '{if($1>1) print}' | grep "*" && echo "duplicate" || echo "no duplicate"



## pick hosts
# pick 240(60 * 4) hosts for qry of row 024
for rack in "${racks024[@]}"; do
    cat $rack | sed -n '1,60p'
done > racks024.qry
test $(wc -l racks024.qry | awk '{print $1}') -eq 240 && echo "hosts ready" || echo "not enough hosts"

# pick 240(60 * 4) hosts for qry of row 025
for rack in "${racks025[@]}"; do
    cat $rack | sed -n '1,60p'
done > racks025.qry
test $(wc -l racks025.qry | awk '{print $1}') -eq 240 && echo "hosts ready" || echo "not enough hosts"

# pick 240(60 * 4) hosts for qry of row 030
for rack in "${racks030[@]}"; do
    cat $rack | sed -n '1,60p'
done > racks030.qry
test $(wc -l racks030.qry | awk '{print $1}') -eq 240 && echo "hosts ready" || echo "not enough hosts"

# pick 12(3 * 4) hosts for lla of row 024
for rack in "${racks024[@]}"; do
    cat $rack | sed -n '61,63p'
done > racks024.lla
test $(wc -l racks024.lla | awk '{print $1}') -eq 12 && echo "hosts ready" || echo "not enough hosts"

# pick 12(3 * 4) hosts for lla of row 025
for rack in "${racks025[@]}"; do
    cat $rack | sed -n '61,63p'
done > racks025.lla
test $(wc -l racks025.lla | awk '{print $1}') -eq 12 && echo "hosts ready" || echo "not enough hosts"

# pick 12(3 * 4) hosts for lla of row 030
for rack in "${racks030[@]}"; do
    cat $rack | sed -n '61,63p'
done > racks030.lla
test $(wc -l racks030.lla | awk '{print $1}') -eq 12 && echo "hosts ready" || echo "not enough hosts"

# integrity  check
wc -l racks* | test $(awk '/total/{print $1}') -eq 756 && echo "hosts all ready" || echo "not enough hosts"
cat racks* | sort | uniq -c | awk '{if($1>1) print}' | grep "*" && echo "duplicate" || echo "no duplicate"


## move vcluster
# move cache hosts from cache to qry
for host in $(cat racks*.qry); do
    /ebay/git/search/bin/moveVcluster.py $host "cassini-p1g7tesscache-lvs" "activeitem5-qry-lvs"
done | tee moveVcluster.qry

# rerun moveVcluster.py for the failed ones
test $(grep OK moveVcluster.qry | wc -l) -eq 720 || { echo "failed hosts of moveVcluster:"; diff <(cat racks*.qry | sort) <(grep '\-tess' moveVcluster.qry | sort); }

for host in $(cat racks*.qry); do
    echo -n "$host "
    /ebay/git/search/bin/getClusterOfHost.py $host
done | tee getClusterOfHost.qry

test $(grep CLjb6ogryn128f3r getClusterOfHost.qry | wc -l) -eq 720 || { echo "not all host were move to activeitem5-qry-lvs:"; diff <(cat racks*.qry | sort) <(grep *-tess* getClusterOfHost.qry | sort); }

# move cache hosts from cache to lla
for host in $(cat racks*.lla); do
    /ebay/git/search/bin/moveVcluster.py $host "cassini-p1g7tesscache-lvs" "activeitem5-lla-lvs"
done | tee moveVcluster.lla

# rerun moveVcluster.py for the failed ones
test $(grep OK moveVcluster.lla | wc -l) -eq 36 || { echo "moveVcluster failed, failed hosts:"; diff <(cat racks*.lla | sort) <(grep '\-tess' moveVcluster.lla | sort); }

for host in $(cat racks*.lla); do
    echo -n "$host "
    /ebay/git/search/bin/getClusterOfHost.py $host
done | tee getClusterOfHost.lla

test $(grep CLjb6oifd712jj3k getClusterOfHost.lla | wc -l) -eq 36 || { echo "not all host were move to activeitem5-lla-lvs:"; diff <(cat racks*.lla | sort) <(grep *-tess* getClusterOfHost.lla | sort); }


## add rows
/ebay/git/search/bin/add_row.py --appsvc "activeitem5-qry-lvs:ENVgo3rsvfa" --racks <(for rack in "${racks024[@]}"; do echo $rack; done) --cr "SCTASK0110696" --simulate
# good to proceed if no errors raise
/ebay/git/search/bin/add_row.py --appsvc "activeitem5-qry-lvs:ENVgo3rsvfa" --racks <(for rack in "${racks024[@]}"; do echo $rack; done) --cr "SCTASK0110696"

/ebay/git/search/bin/add_row.py --appsvc "activeitem5-qry-lvs:ENVgo3rsvfa" --racks <(for rack in "${racks025[@]}"; do echo $rack; done) --cr "SCTASK0110696" --simulate
# good to proceed if no errors raise
/ebay/git/search/bin/add_row.py --appsvc "activeitem5-qry-lvs:ENVgo3rsvfa" --racks <(for rack in "${racks025[@]}"; do echo $rack; done) --cr "SCTASK0110696"

/ebay/git/search/bin/add_row.py --appsvc "activeitem5-qry-lvs:ENVgo3rsvfa" --racks <(for rack in "${racks030[@]}"; do echo $rack; done) --cr "SCTASK0110696" --simulate
# good to proceed if no errors raise
/ebay/git/search/bin/add_row.py --appsvc "activeitem5-qry-lvs:ENVgo3rsvfa" --racks <(for rack in "${racks030[@]}"; do echo $rack; done) --cr "SCTASK0110696"

# verify FQDN of qry svcinst
cols=$(seq -w 001 240)
rows=(024 025 030)
for col in ${cols[@]}; do
    for row in ${rows[@]}; do
        host activeitem5-qry-lvs-${col}-${row}
    done
done | tee svcinst_fqdn.qry
test $(wc -l svcinst_fqdn.qry | awk '{print $1}') -eq 1440 || echo "not all svcinst have been added"

# verify FQDN of lla svcinst
rows=({277..288} {289..300} {349..360})
for row in ${rows[@]}; do
    host activeitem5-lla-lvs-001-${row}
done | tee svcinst_fqdn.lla
test $(wc -l svcinst_fqdn.lla | awk '{print $1}') -eq 72 || echo "not all svcinst have been added"


## sync db
/ebay/git/search/bin/casswap_db.py --sync-cache-vcluster "cassini-p1g7tesscache-lvs"
/ebay/git/search/bin/casswap_db.py --sync-appsvc "activeitem5-qry-lvs:ENVgo3rsvfa"
/ebay/git/search/bin/casswap_db.py --sync-appsvc "activeitem5-lla-lvs:ENVgo3rsvfa"

source source ~runzhao/.bash_runzhao
mysql-root -ns -d 'casswap' "select count(1) from server s left join hosttype h on s.Hosttype = h.id where Svcinst like 'activeitem5-qry-lvs-%-024';"   # should be 240
mysql-root -ns -d 'casswap' "select count(1) from server s left join hosttype h on s.Hosttype = h.id where Svcinst like 'activeitem5-qry-lvs-%-025';"   # should be 240
mysql-root -ns -d 'casswap' "select count(1) from server s left join hosttype h on s.Hosttype = h.id where Svcinst like 'activeitem5-qry-lvs-%-030';"   # should be 240
mysql-root -ns -d 'casswap' "select * from server s left join hosttype h on s.Hosttype = h.id where Svcinst like 'activeitem5-lla-lvs-001-%';"   # should be 312 + 36

mysql-root -ns -d 'casswap' "select distinct h.Name from server s left join hosttype h on s.Hosttype = h.id where Svcinst like 'activeitem5-qry-lvs-%-024';"    # should be P1EG7
mysql-root -ns -d 'casswap' "select distinct h.Name from server s left join hosttype h on s.Hosttype = h.id where Svcinst like 'activeitem5-qry-lvs-%-025';"    # should be P1EG7
mysql-root -ns -d 'casswap' "select distinct h.Name from server s left join hosttype h on s.Hosttype = h.id where Svcinst like 'activeitem5-qry-lvs-%-030';"    # should be P1EG7
mysql-root -ns -d 'casswap' "select h.Name, count(hosttype) from server s left join hosttype h on s.Hosttype = h.id where Svcinst like 'activeitem5-lla-lvs-001-%' group by hosttype;"    # P1EG7 should be 36



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
# extend row numbers: 29 --> 30
sed -n '/Group LVS Active Item5 Row \[1\-29\]/s|29|30|p' $conf
# to proceed if no errors raised
sed -i '/Group LVS Active Item5 Row \[1\-29\]/s|29|30|g' $conf
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
row_id=030      # new row id
for col in $(seq -w 001 240); do
    /ebay/git/search/bin/mcManualAddForCassini "LVS Active Item5 ${col##+(0)} Query" "activeitem5-qry-lvs-${col}-${row_id}:9177" "leaf"
done
# create new row service
/ebay/git/search/bin/mcManualAddForCassini "LVS Active Item5 Row" "LVS Active Item5 Row ${row_id##+(0)}"
/ebay/git/search/bin/mcManualAddForCassini "LVS Active Item5 Row ${row_id##+(0)}" "LVS Active Item5 Row ${row_id##+(0)} Query"
# add new rows service instance
for col in $(seq -w 001 240); do
    /ebay/git/search/bin/mcManualAddForCassini "LVS Active Item5 Row ${row_id##+(0)} Query" "activeitem5-qry-lvs-${col}-${row_id}" "leaf"
done
# add LLAs
row_id=030
LLAs_to=$((${row_id##+(0)} * 12))
LLAs_from=$((LLAs_to-11))
for row in $(seq $LLAs_from $LLAs_to); do
    /ebay/search/bin/mcManualAddForCassini "LVS Active Item5 LLA" "activeitem5-lla-lvs-001-${row}:9177" "leaf"
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
activeitem5-qry-lvs-*-${new_row_id}
activeitem5-lla-lvs-001-${new_row_id}
