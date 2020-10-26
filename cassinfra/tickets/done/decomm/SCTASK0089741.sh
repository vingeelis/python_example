#!/usr/bin/env bash


## Short description : Decom 13 nodes from search-tla7-slc and 6 nodes from completed1prod-lla-slc pool


## search-tla7-slc:ENVgo3rsvfa



## Implementation plan

task_id=SCTASK0089741
change_id=CHG3334044
mkdir -p ~runzhao/ticket/${task_id}/${change_id}
cd ~runzhao/ticket/${task_id}/${change_id}

#1 get DNS records
# get CNAME records
for svc in search-tla7-slc-001-{001..013}; do
    echo "$svc $(host $svc | awk '/alias/ {print $NF}')"
done > record.cname

# get A record
for svc in search-tla7-slc-001-{001..013}; do
    echo "$(host $svc | awk '/address/ {print $1}') $(host $svc | awk '/address/ {print $NF}')"
done > record.a

#2 remove service instances in application service and computes in vcluster

# simulate
/ebay/git/search/bin/remove_tos.py --appsvc 'search-tla7-slc:ENVgo3rsvfa' --to-vcls 'cassini-p1g5cache-lvs' --cr "$change_id" --simulate
# go ahead if no errors raised
/ebay/git/search/bin/remove_tos.py --appsvc 'search-tla7-slc:ENVgo3rsvfa' --to-vcls 'cassini-p1g5cache-lvs' --cr "$change_id"

while IFS= read -r line; do
    /ebay/git/search/bin/moveVcluster.py $(awk '{print $2}' <(echo "$line")) 'cassini-p1g5cache-lvs' 'cassini-p1g5cache-slc'
done < record.a

# check that no CNAME of service instances exists
for svc in search-tla7-slc-001-{001..013}; do
    host $svc
done | grep NXDOMAIN | wc -l

# check that A records exist for BMs
while IFS= read -r line; do
    host $(awk '{print $1}' <(echo "$line"))
done < record.a | grep address | wc -l

# check that PTR records exist for BMs
while IFS= read -r line; do
    host $(awk '{print $2}' <(echo "$line"))
done < record.a | grep pointer | wc -l

#3 remove application service

# make sure there are no query result of service instances of Application Service
https://cmsbrowser.vip.stratus.ebay.com/browser/repo/cmsdb/branch/main/query?query=ApplicationService[@nugget="search-tla7-slc"].serviceInstances

# make sure these are no query result of computes of VCluster
https://cmsbrowser.vip.stratus.ebay.com/browser/repo/cmsdb/branch/main/query?query=VCluster[@label="search-tla7-slc"].computes

# delete ApplicationService Object in cms change the service group to correct value if needed
/ebay/git/search/bin/deleteCMS.py --name search --type tla7 --colo slc --env SBE-Prod --svcgrp sbe_main_prod --simulate
/ebay/git/search/bin/deleteCMS.py --name search --type tla7 --colo slc --env SBE-Prod --svcgrp sbe_main_prod

# make sure that Application service is not exists
https://cmsbrowser.vip.stratus.ebay.com/browser/repo/cmsdb/branch/main/query?query=ApplicationService[@resourceId="search-tla7-slc:ENVgo3rsvfa"]

#4 check database
# make sure that there are no query result in database
source ~runzhao/.bash_runzhao
mysql-root -ns -d 'casswap' "select * from appsvc where name = 'search-tla7-slc:ENVgo3rsvfa';"
mysql-root -ns -d 'casswap' "select * from server where Svcinst like 'search-tla7-slc-%';"


## Rollback plan
#1 create the cluster using /ebay/git/search/bin/CassiniVcluster.py
#2 move cache over using /ebay/git/search/bin/moveVcluster.py
#3 add topology to pool using /ebay/git/search/bin/add_row.py
#4 sync db using /ebay/git/search/bin/casswap_db.py
#5 add to cass-mon


## Verification plan
# make sure the following CMS queries are none
https://cmsbrowser.vip.stratus.ebay.com/browser/repo/cmsdb/branch/main/query?query=ApplicationService[@resourceId="search-tla7-slc:ENVgo3rsvfa"]
https://cmsbrowser.vip.stratus.ebay.com/browser/repo/cmsdb/branch/main/query?query=ApplicationService[@resourceId="search-tla7-slc:ENVgo3rsvfa"].serviceInstances
https://cmsbrowser.vip.stratus.ebay.com/browser/repo/cmsdb/branch/main/query?query=VCluster[@label="search-tla7-slc"]
https://cmsbrowser.vip.stratus.ebay.com/browser/repo/cmsdb/branch/main/query?query=VCluster[@label="search-tla7-slc"].computes





### completed1prod-lla-slc:ENVgo3rsvfa
## Implementation plan

task_id=SCTASK0089741
change_id=CHG3439671
mkdir -p ~runzhao/ticket/${task_id}/${change_id}
cd ~runzhao/ticket/${task_id}/${change_id}

#1 make sure there is no traffic of that pool

#2 ask ID team to remove alerts from the pool to be decommed if needed

#3 flip the pools to decommed using updateCMSAttribute.py

#4 swap back if there are any node which is swapped

#5 get DNS records
# get CNAME records
for svc in completed1prod-lla-slc-001-{001..006}; do
    echo "$svc $(host $svc | awk '/alias/ {print $NF}')"
done > record.cname

# get A record
for svc in completed1prod-lla-slc-001-{001..006}; do
    echo "$(host $svc | awk '/address/ {print $1}') $(host $svc | awk '/address/ {print $NF}')"
done > record.a


#6 remove service instances in application service and computes in vcluster
# get the sku of computes
https://cmsbrowser.vip.stratus.ebay.com/browser/repo/cmsdb/branch/main/query?query=VCluster[@label="completed1prod-lla-slc"].computes.nodeServer.nodeServer!AssetServer.configuredTo{@resourceId}

# simulate
/ebay/git/search/bin/remove_tos.py --appsvc 'completed1prod-lla-slc:ENVgo3rsvfa' --to-vcls 'cassini-p1g6cache-slc' --cr "$change_id" --simulate
echo $? && echo "all OK" || echo "not all OK, something wrong"
# go ahead if "ServiceInstance could not be found in casswap" error raised or go next
/ebay/git/search/bin/casswap_db.py --sync-appsvc 'completed1prod-lla-slc:ENVgo3rsvfa'
# go ahead if no errors raised
/ebay/git/search/bin/remove_tos.py --appsvc 'completed1prod-lla-slc:ENVgo3rsvfa' --to-vcls 'cassini-p1g6cache-slc' --cr "$change_id"
echo $? && echo "all OK" || echo "not all OK, something wrong"

# check that all CNAME lookup of service instances will return NXDOMAIN
for svc in completed1prod-lla-slc-001{001..006}; do
    host $svc
done | grep NXDOMAIN | wc -l

# check that A records exist for BMs
while IFS= read -r line; do
    host $(awk '{print $1}' <(echo "$line"))
done < record.a | grep address | wc -l

# check that PTR records exist for BMs
while IFS= read -r line; do
    host $(awk '{print $2}' <(echo "$line"))
done < record.a | grep pointer | wc -l

#7 remove application service

# make sure there are no query result of service instances of Application Service
https://cmsbrowser.vip.stratus.ebay.com/browser/repo/cmsdb/branch/main/query?query=ApplicationService[@resourceId="completed1prod-lla-slc:ENVgo3rsvfa"].serviceInstances

# delete ApplicationService Object in cms, change the service group to correct value if default one is not correct
/ebay/git/search/bin/deleteCMS.py --name completed1prod --type lla --colo slc --env SBE-Prod --simulate
/ebay/git/search/bin/deleteCMS.py --name completed1prod --type lla --colo slc --env SBE-Prod

# make sure that Application service is not exists
https://cmsbrowser.vip.stratus.ebay.com/browser/repo/cmsdb/branch/main/query?query=ApplicationService[@resourceId="completed1prod-lla-slc:ENVgo3rsvfa"]

# sync cassini databasae
mysql-root -ns -d 'casswap' "select * from appsvc where name = 'completed1prod-lla-slc:ENVgo3rsvfa';"
/ebay/git/search/bin/casswap_db.py --delete-appsvc 'completed1prod-lla-slc:ENVgo3rsvfa'
mysql-root -ns -d 'casswap' "select * from appsvc where name = 'completed1prod-lla-slc:ENVgo3rsvfa';"

#8 remove VCluster

# make sure there are no query result of computes of VCluster
https://cmsbrowser.vip.stratus.ebay.com/browser/repo/cmsdb/branch/main/query?query=VCluster[@label="completed1prod-lla-slc"].computes

# delete VCluster Object in cms
/ebay/git/search/bin/deleteCluster.py --cls completed1prod-lla-slc --env SBE-Prod


## Rollback plan
#1 create the cluster using /ebay/git/search/bin/CassiniVcluster.py
#2 move cache over using /ebay/git/search/bin/moveVcluster.py
#3 add topology to pool using /ebay/git/search/bin/add_row.py
#4 sync db using /ebay/git/search/bin/casswap_db.py
#5 add to cass-mon


## Verification plan
# make sure the following CMS and cassini sql queries are all none
https://cmsbrowser.vip.stratus.ebay.com/browser/repo/cmsdb/branch/main/query?query=ApplicationService[@resourceId="completed1prod-lla-slc:ENVgo3rsvfa"]
https://cmsbrowser.vip.stratus.ebay.com/browser/repo/cmsdb/branch/main/query?query=ApplicationService[@resourceId="completed1prod-lla-slc:ENVgo3rsvfa"].serviceInstances
https://cmsbrowser.vip.stratus.ebay.com/browser/repo/cmsdb/branch/main/query?query=VCluster[@label="completed1prod-lla-slc"]
https://cmsbrowser.vip.stratus.ebay.com/browser/repo/cmsdb/branch/main/query?query=VCluster[@label="completed1prod-lla-slc"].computes
source ~runzhao/.bash_runzhao
mysql-root -ns -d 'casswap' "select * from appsvc where name = 'completed1prod-lla-slc:ENVgo3rsvfa';"
mysql-root -ns -d 'casswap' "select * from server where Svcinst like 'completed1prod-lla-slc-%';"
