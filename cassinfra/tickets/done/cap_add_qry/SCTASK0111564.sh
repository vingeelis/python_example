#!/usr/bin/env bash

## SCTASK0111564

## Short description : Add 1 Active Item P1EG7 row to traffic in SLC as part of 2020 feature growth

## description :

Add 1 Active Item P1EG7 row to traffic in SLC as part of 2020 feature growth:
TESS-29538: Add Cassini P1EG7 racks to SLCAZ02 Tess 14 to create an Active Item row
SLCAZ02:
# duplicate or no NodeServer/label : (ASSET00618758, ASSET00618884)
SLC03-01-0400-1318
# duplicate or no NodeServer/label : (ASSET00620436)
SLC03-01-0400-1012
# duplicate or no NodeServer/label : (ASSET00620495, ASSET00620747)
SLC03-01-0400-1312
# duplicate or no NodeServer/label : (ASSET00620816, ASSET00620663)
SLC03-01-0400-1213


## Business justification
capacity add

## Implementation plan
task_id=SCTASK0111564
# fill in this id after CR created
change_id=CHG3413363
zone=slc
mkdir -p /home/runzhao/tickets/$task_id
cd /home/runzhao/tickets/$task_id || echo "cd failed"


## tell Oy <owong@ebay.com> of the new SKU of the server.

## check computes of racks using following CMS query,
Rack[@location="SLC03-01-0400-1318"].assets[@assetType="Server"]{@resourceId}.asset!AssetServer{@resourceId,@isAllocated}.nodeServer{@resourceId,@label}.managementServer!AssetServer{*}.nodeServer{@resourceId,@label}.nodeServer!Compute
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
Rack[@location="SLC03-01-0400-1318"].assets{@resourceId}.asset!AssetServer.configuredTo{@resourceId}
# and make sure,
# SkuConfiguration/resourceId is the correct SKU


## pick hostname(field: server) of servers from cache rack into corresponding rack files
racks028=(
SLC03-01-0400-1318
SLC03-01-0400-1012
SLC03-01-0400-1312
SLC03-01-0400-1213
)

# check if there are enough nodes
wc -l SLC* | awk '{if($1<72) print}'
cat SLC* | sort | uniq -c | awk '{if($1>1) print}' | grep "*" && echo "duplicate" || echo "no duplicate"


## check tess_key in /ebay/search/lib/, request a new tess_key and put it here if not find
for rack in ${racks028[@]}; do
    /ebay/search/bin/getInfoFromRack.py -r $rack > $rack.info
done

tess_clusters=($(cat *.info | grep -P -o 'tess-node-\w+-tess\d+' | awk -F'-' '{print $NF}' | sort | uniq | grep -Po '\d+'))
echo ${tess_clusters[@]}
for t in ${tess_clusters[@]}; do
    test -f /ebay/search/lib/tess_key_$t | echo "no such /ebay/search/lib/tess_key_$t"
done


## pick hosts
# pick 240(60 * 4) hosts for qry of row 028
for rack in "${racks028[@]}"; do
    cat $rack | sed -n '1,60p'
done > racks028.qry
test $(wc -l racks028.qry | awk '{print $1}') -eq 240 && echo "hosts ready" || echo "not enough hosts"

# pick 12(3 * 4) hosts for lla of row 028
for rack in "${racks028[@]}"; do
    cat $rack | sed -n '61,63p'
done > racks028.lla
test $(wc -l racks028.lla | awk '{print $1}') -eq 12 && echo "hosts ready" || echo "not enough hosts"

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

test $(grep CLjeq3ygr5128f1t getClusterOfHost.qry | wc -l) -eq 240 || { echo "not all host were move to activeitem5-qry-$zone:"; diff <(cat racks*.qry | sort) <(grep '\-tess' getClusterOfHost.qry | sort); }

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

test $(grep CLjeq3zje2fj81q getClusterOfHost.lla | wc -l) -eq 12 || { echo "not all host were move to activeitem5-lla-${zone}:"; diff <(cat racks*.lla | sort) <(grep '\-tess' getClusterOfHost.lla | sort); }


## add rows
/ebay/git/search/bin/add_row.py --appsvc "activeitem5-qry-${zone}:ENVgo3rsvfa" --racks <(for rack in "${racks028[@]}"; do echo $rack; done) --cr "$change_id" --simulate
# good to proceed if no errors raise
/ebay/git/search/bin/add_row.py --appsvc "activeitem5-qry-${zone}:ENVgo3rsvfa" --racks <(for rack in "${racks028[@]}"; do echo $rack; done) --cr "$change_id"



# verify FQDN of svcinst
cols=$(seq -w 001 240)
rows=(028 )
for col in ${cols[@]}; do
    for row in ${rows[@]}; do
        host activeitem5-qry-${zone}-${col}-${row}
    done
done | tee svcinst_fqdn.qry
test $(wc -l svcinst_fqdn.qry | awk '{print $1}') -eq 480 || echo "not all svcinst have been added"

# verify FQDN of lla svcinst
rows=({325..336})
for row in ${rows[@]}; do
    host activeitem5-lla-${zone}-001-${row}
done | tee svcinst_fqdn.lla
test $(wc -l svcinst_fqdn.lla | awk '{print $1}') -eq 24 || echo "not all svcinst have been added"


## sync cassini database
/ebay/git/search/bin/casswap_db.py --sync-cache-vcluster "cassini-p1g7tesscache-${zone}"
/ebay/git/search/bin/casswap_db.py --sync-appsvc "activeitem5-qry-${zone}:ENVgo3rsvfa"
/ebay/git/search/bin/casswap_db.py --sync-appsvc "activeitem5-lla-${zone}:ENVgo3rsvfa"

source source ~runzhao/.bash_runzhao
mysql-root -ns -d 'casswap' "select count(1) from server s left join hosttype h on s.Hosttype = h.id where Svcinst like 'activeitem5-qry-${zone}-%-028';"   # should be 240
mysql-root -ns -d 'casswap' "select count(1) from server s left join hosttype h on s.Hosttype = h.id where Svcinst like 'activeitem5-lla-${zone}-001-%';"   # should be

mysql-root -ns -d 'casswap' "select distinct h.Name from server s left join hosttype h on s.Hosttype = h.id where Svcinst like 'activeitem5-qry-${zone}-%-028';"    # should be P1EG7
mysql-root -ns -d 'casswap' "select h.Name, count(hosttype) from server s left join hosttype h on s.Hosttype = h.id where Svcinst like 'activeitem5-lla-${zone}-001-%' group by hosttype;"    # P1EG7 should be 36


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
# extend row numbers: 27 --> 28
sed -n '/Group SLC Active Item5 Row \[1\-27\]/s|27|28|p' $conf
# to proceed if no errors raised
sed -i '/Group SLC Active Item5 Row \[1\-27\]/s|27|28|g' $conf
# check diffs between head and head^1
rcsdiff $conf
# check in
ci -wrunzhao -u $conf
# check diffs between latest 2 versions
new_v=$(rlog $conf | head | awk '/head:/ {print $2}') && echo $new_v
rcsdiff -r$new_v -r$old_v $conf
# ssh exit back to Cassinfra
exit


# add LLAs
row_id=028
LLAs_to=$((${row_id##+(0)} * 12))
LLAs_from=$((LLAs_to-11))
for row in $(seq $LLAs_from $LLAs_to); do
    /ebay/search/bin/mcManualAddForCassini "${zone^^} Active Item5 LLA" "activeitem5-lla-${zone}-001-${row}:9177" "leaf"
done

# add to columns
row_id=028      # new row id
for col in $(seq -w 001 240); do
    /ebay/git/search/bin/mcManualAddForCassini "${zone^^} Active Item5 ${col##+(0)} Query" "activeitem5-qry-${zone}-${col}-${row_id}:9177" "leaf"
done

# create new row[s]
/ebay/git/search/bin/mcManualAddForCassini "${zone^^} Active Item5 Row" "${zone^^} Active Item5 Row ${row_id##+(0)}"
/ebay/git/search/bin/mcManualAddForCassini "${zone^^} Active Item5 Row ${row_id##+(0)}" "${zone^^} Active Item5 Row ${row_id##+(0)} Query"
# add to new row[s]
for col in $(seq -w 001 240); do
    /ebay/git/search/bin/mcManualAddForCassini "${zone^^} Active Item5 Row ${row_id##+(0)} Query" "activeitem5-qry-${zone}-${col}-${row_id}" "leaf"
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

# verify FQDN of qry svcinst
cols=$(seq -w 001 240)
rows=(028 )
for col in ${cols[@]}; do
    for row in ${rows[@]}; do
        host activeitem5-qry-${zone}-${col}-${row}
    done
done | tee svcinst_fqdn.qry
test $(wc -l svcinst_fqdn.qry | awk '{print $1}') -eq 480 || echo "not all svcinst have been added"

# verify FQDN of lla svcinst
rows=({325..336})
for row in ${rows[@]}; do
    host activeitem5-lla-${zone}-001-${row}
done | tee svcinst_fqdn.lla
test $(wc -l svcinst_fqdn.lla | awk '{print $1}') -eq 24 || echo "not all svcinst have been added"

# and make sure above pods are serving traffic



/ebay/git/search/bin/ready_cassini_nodes.py -f <(for svc in activeitem5-qry-lvs-{001..240}-024; do echo $svc; done)
/ebay/git/search/bin/ready_cassini_nodes.py -f <(for svc in activeitem5-qry-lvs-{001..240}-030; do echo $svc; done)

