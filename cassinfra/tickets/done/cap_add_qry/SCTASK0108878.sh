#!/usr/bin/env bash

## SCTASK0108878

## Short description : Add 2 Active Item P1EG7 rows to traffic in SLC as part of 2020 feature growth

## description :
Add 2 Active Item P1EG7 rows to traffic in SLC as part of 2020 feature growth. This will also help to remove 3 rows of Active Item if needed for Tess conversion:

TESS-29231: Add Cassini P1EG7 racks to Tess 14 in SLCAZ02 to create an Active Item row
SLCAZ02:
SLC03-01-0400-1015
SLC03-01-0400-1117
SLC03-01-0400-1218 # (ASSET00618889:Unprovisioned ASSET00619242:nopod)
SLC03-01-0400-1113 # (ASSET00618872:Unprovisioned)

TESS-29230: Add Cassini P1EG7 racks to Tess 72 in SLCAZ01 to create an Active Item row
SLCAZ01:
SLC03-01-0300-1405
SLC03-01-0300-1303
SLC03-01-0300-1304
SLC03-01-0300-1403

## Business justification
capacity add

## Implementation plan
mkdir -p ~/tickets/SCTASK0108878
cd ~/tickets/SCTASK0108878


## tell Oy <owong@ebay.com> of the new SKU of the server.

## pick hostname(field: server) of servers from cache rack into corresponding rack files
racks26=(
    SLC03-01-0400-1015
    SLC03-01-0400-1117
    SLC03-01-0400-1218
    SLC03-01-0400-1113
)

racks27=(
    SLC03-01-0300-1405
    SLC03-01-0300-1303
    SLC03-01-0300-1304
    SLC03-01-0300-1403
)

# duplicate entries in SLC03-01-0400-1015: (ASSET00613886 * 2, ASSET00614057 * 2)
# Rack[@location="SLC03-01-0400-1015"].assets[@assetType="Server"]{@resourceId}.asset!AssetServer{@resourceId,@isAllocated}.nodeServer{@resourceId,@label}.managementServer!AssetServer{*}.nodeServer{@resourceId,@label}.nodeServer!Compute

# duplicate entries in SLC03-01-0400-1117: (ASSET00614061 * 3,)
# Rack[@location="SLC03-01-0400-1117"].assets[@assetType="Server"]{@resourceId}.asset!AssetServer{@resourceId,@isAllocated}.nodeServer{@resourceId,@label}.managementServer!AssetServer{*}.nodeServer{@resourceId,@label}.nodeServer!Compute

# duplicate entries in SLC03-01-0400-1218: (ASSET00619201 * 2, ASSET00619408 * 2)
# Rack[@location="SLC03-01-0400-1218"].assets[@assetType="Server"]{@resourceId}.asset!AssetServer{@resourceId,@isAllocated}.nodeServer{@resourceId,@label}.managementServer!AssetServer{*}.nodeServer{@resourceId,@label}.nodeServer!Compute

# duplicate entries in SLC03-01-0400-1113: (ASSET00619460 * 2, ASSET00619210 * 2)
# Rack[@location="SLC03-01-0400-1113"].assets[@assetType="Server"]{@resourceId}.asset!AssetServer{@resourceId,@isAllocated}.nodeServer{@resourceId,@label}.managementServer!AssetServer{*}.nodeServer{@resourceId,@label}.nodeServer!Compute


## pick hosts
# pick 240(60 * 4) host for qry of row 26
for rack in "${racks26[@]}"; do
    cat $rack | sed -n '1,60p'
done > racks26.qry
test $(wc -l racks26.qry | awk '{print $1}') -eq 240 && echo "hosts ready" || echo "not enough hosts"

# pick 240(60 * 4) host for qry of row 27
for rack in "${racks27[@]}"; do
    cat $rack | sed -n '1,60p'
done > racks27.qry
test $(wc -l racks27.qry | awk '{print $1}') -eq 240 && echo "hosts ready" || echo "not enough hosts"

# pick 12(3 * 4) host for lla of row 26
for rack in "${racks26[@]}"; do
    cat $rack | sed -n '61,63p'
done > racks26.lla
test $(wc -l racks26.lla | awk '{print $1}') -eq 12 && echo "hosts ready" || echo "not enough hosts"

# pick 12(3 * 4) host for lla of row 27
for rack in "${racks27[@]}"; do
    cat $rack | sed -n '61,63p'
done > racks27.lla
test $(wc -l racks27.lla | awk '{print $1}') -eq 12 && echo "hosts ready" || echo "not enough hosts"

# duplication check
cat racks* | sort | uniq -c | awk '{if($1>1) print}' | grep "*" && echo "duplicate" || echo "no duplicate"


## move vcluster

# move cache hosts from cache to qry
for host in $(cat racks26.qry racks27.qry); do
    /ebay/git/search/bin/moveVcluster.py $host "cassini-p1g7tesscache-slc" "activeitem5-qry-slc"
done &> moveVcluster.log

test $(grep OK moveVcluster.log | wc -l) -eq 480 || { echo "failed hosts of moveVcluster:"; diff <(cat racks26.qry racks27.qry | sort) <(grep *-tess* moveVcluster.log | sort); }

for host in $(cat racks26.qry racks27.qry); do
    /ebay/git/search/bin/getClusterOfHost.py $host
done &> getClusterOfHost.log

test $(grep CLjeq3ygr5128f1t getClusterOfHost.log | wc -l) -eq 480 || echo "not all host were move to activeitem5-qry-slc"


# move cache hosts from cache to lla
for host in $(cat racks26.lla racks27.lla); do
    /ebay/git/search/bin/moveVcluster.py $host "activeitem5-qry-slc" "activeitem5-lla-slc"
done &> moveVcluster.log

test $(grep OK moveVcluster.log | wc -l) -eq 24 || { echo "moveVcluster failed, failed hosts:"; diff <(cat racks26.lla racks27.lla | sort) <(grep *-tess* moveVcluster.log | sort); }

for host in $(cat racks26.lla racks27.lla); do
    /ebay/git/search/bin/getClusterOfHost.py $host
done &> getClusterOfHost.log

test $(grep CLjeq3zje2fj81q getClusterOfHost.log | wc -l) -eq 24 || echo "not all host were move to activeitem5-lla-slc"


## add rows

/ebay/git/search/bin/add_row.py --appsvc "activeitem5-qry-slc:ENVgo3rsvfa" --racks <(for rack in "${racks26[@]}"; do echo $rack; done) --cr "SCTASK0108878" --simulate
# good to proceed if no errors raise
/ebay/git/search/bin/add_row.py --appsvc "activeitem5-qry-slc:ENVgo3rsvfa" --racks <(for rack in "${racks26[@]}"; do echo $rack; done) --cr "SCTASK0108878"

/ebay/git/search/bin/add_row.py --appsvc "activeitem5-qry-slc:ENVgo3rsvfa" --racks <(for rack in "${racks27[@]}"; do echo $rack; done) --cr "SCTASK0108878" --simulate
# good to proceed if no errors raise
/ebay/git/search/bin/add_row.py --appsvc "activeitem5-qry-slc:ENVgo3rsvfa" --racks <(for rack in "${racks27[@]}"; do echo $rack; done) --cr "SCTASK0108878"


## sync db
/ebay/git/search/bin/casswap_db.py --sync-cache-vcluster "cassini-p1g7tesscache-slc"
/ebay/git/search/bin/casswap_db.py --sync-appsvc "activeitem5-qry-slc:ENVgo3rsvfa"
/ebay/git/search/bin/casswap_db.py --sync-appsvc "activeitem5-lla-slc:ENVgo3rsvfa"

source source ~runzhao/.bash_runzhao
mysql-root -nd -d 'casswap' "select count(1) from server s left join hosttype h on s.Hosttype = h.id where Svcinst like 'activeitem5-qry-slc-%-014';"   # should be 240
mysql-root -nd -d 'casswap' "select count(1) from server s left join hosttype h on s.Hosttype = h.id where Svcinst like 'activeitem5-qry-slc-%-026';"   # should be 240
mysql-root -nd -d 'casswap' "select distinct h.Name from server s left join hosttype h on s.Hosttype = h.id where Svcinst like 'activeitem5-qry-slc-%-014';"    # should be P1EG7
mysql-root -nd -d 'casswap' "select distinct h.Name from server s left join hosttype h on s.Hosttype = h.id where Svcinst like 'activeitem5-qry-slc-%-026';"    # should be P1EG7



## add to cass-mon

# sed conf and restart service
# perform on cass-mon-1.stratus.slc.ebay.com
# 1 hour or few days later on cass-mon-2.stratus.slc.ebay.com
ssh cass-mon-1.stratus.slc.ebay.com
# backup conf file
conf=/ebay/monitor/conf/MonitorSource.conf
bak=/ebay/monitor/conf/MonitorSource.conf.$(date +%s)
cp /ebay/monitor/conf/MonitorSource.conf /ebay/monitor/conf/MonitorSource.conf.bak
# row numbers: 25 --> 26
sed -n '/Group SLC Active Item5 Row \[1\-25\]/s|25|26|p' $conf
# to proceed if no errors raised
sed -i '/Group SLC Active Item5 Row \[1\-25\]/s|25|26|g' $conf
# lla numbers: 300 --> 312
sed -n '/Group SLC Active Item \[1\-300\]/s|300|312|p' $conf
# to proceed if no errors raised
sed -i '/Group SLC Active Item \[1\-300\]/s|300|312|g' $conf
# check diffs
diff $bak $conf
# remove back file if diffs OK
test -f $bak && rm -rf $bak
# restart service
sudo -u hoot /ebay/monitor/bin/restartSNMon.sh


# add row in columns
row_id=      # new row id
for col in $(seq -w 001 240); do
    /ebay/git/search/bin/mcManualAddForCassini "SLC Active Item5 ${col##+(0)} Query" "activeitem5-qry-slc-${col}-${row_id}:9177" "leaf"
done
# create new row service
/ebay/git/search/bin/mcManualAddForCassini "SLC Active Item5 Row" "SLC Active Item5 Row ${row_id##+(0)}"
/ebay/git/search/bin/mcManualAddForCassini "SLC Active Item5 Row ${row_id##+(0)}" "SLC Active Item5 Row ${row_id##+(0)} Query"
# add new rows service instance
for col in $(seq -w 001 240); do
    /ebay/git/search/bin/mcManualAddForCassini "SLC Active Item5 Row ${row_id##+(0)} Query" "activeitem5-qry-slc-${col}-${row_id}" "leaf"
done
# add LLAs
LLAs_to=$((${row_id##+(0)} * 12))
LLAs_from=$((LLAs_to-11))
for row in $(seq $LLAs_from $LLAs_to); do
    echo /ebay/search/bin/mcManualAddForCassini "SLC Active Item5 LLA" "activeitem5-lla-slc-001-${row}:9177" "leaf"
done

# restart cass-mon
ssh cass-mon-1.stratus.slc.ebay.com
sudo -u hoot /ebay/monitor/bin/restartSNMon.sh


# verify cass-mon.vip.ebay.com


## mail to topology-change and Oy
# DL-eBay-Cassini-Topology-Change
# owong@ebay.com



## Rollback plan
# delete rows
# sync db
# move hosts from lla && qry to corresponding cache


# Verification plan

## make sure there are corresponding amount of hosts are serving traffic in following rows:
activeitem5-qry-slc-*-${new_row_id}
