#!/usr/bin/env bash

# https://ebayinc.service-now.com/sc_task.do?sys_id=8675f3e1dbce985470a045e813961948&sysparm_record_list=active%3dtrue%5eassigned_toDYNAMIC90d1921e5f510100a9ad2572f2b477fe%5eORDERBYDESCnumber&sysparm_record_row=3&sysparm_record_rows=5&sysparm_record_target=task&sysparm_view=sec_catalog_task&sysparm_view_forced=true

VCluster[@label="cassini-p1bg5tesscache-lvs"]{@resourceId}==CLjyqc3nqc60a1u
VCluster[@label="cassini-p1g5tesscache-lvs"]{@resourceId}==CLk3s1f2rifj81h
VCluster[@label="cassini-p1g6tesscache-lvs"]{@resourceId}==CLk8uiasdl60a1u
VCluster[@label="cassini-p1g7tesscache-lvs"]{@resourceId}==CLk8uhzkhbfj825


# 1511
#noSI lva04c-8ahd.stratus.lvs.ebay.com 10.196.157.87 P1G6-SMC-6029TP-CFG LVS04-01-0300-0203-1 asset00527561 tess120

# 1519
#noSI lva06c-8kzq.stratus.lvs.ebay.com 10.197.23.44 P1G7-SMC-6029TP-CFG LVS04-01-0300-2809-1 asset00593032 tess120
#noSI lva06c-8naj.stratus.lvs.ebay.com 10.197.16.63 P1G7-SMC-6029TP-CFG LVS04-01-0300-2808-1 asset00593374 tess120

# 1512: retry
# step: VALIDATE_COMPUTENODE, For input string: "8E18"
#noSI lvb04c-8gjl.stratus.lvs.ebay.com 10.33.216.101 P1G5-Hyve-T41S-2U-CFG LVS02-01-810-2904-2 asset00463974 tess122

# 1513: retry
# step: VALIDATE_COMPUTENODE, For input string: ""
#noSI lvb05c-8qin.stratus.lvs.ebay.com 10.123.89.71 P1G7-SMC-6029TP-CFG LVS02-01-830-1601-1 asset00592583 tess122

# 1514: running
#noSI lvc03c-3tms.stratus.lvs.ebay.com 10.78.231.75 P1BG5-Hyve-T41S-2U-CFG LVS01-01-400-1008-1 asset00479851 tess48 fireflydb-log-lvs-001-009
#noSI lvc03c-5etc.stratus.lvs.ebay.com 10.78.203.42 P1BG5-Hyve-T41S-2U-CFG LVS01-01-400-0608-1 asset00478519 tess48 fireflydb-log-lvs-001-005
# 1567: ASSET_UNHEALTHY
# 1633
noSI lvc03c-8lim.stratus.lvs.ebay.com 10.78.231.33 P1BG5-Hyve-T41S-2U-CFG LVS01-01-400-1008-1 asset00479881 tess48 fireflydb-log-lvs-001-010

# 1515
#noSI lvt06c-4lth.stratus.lvs.ebay.com 10.166.116.37 P1G5-Hyve-T41S-2U-CFG LVS03-01-0200-1605-2 asset00452927 tess50

# 1518
#noSI lvt11c-0bkh.stratus.lvs.ebay.com 10.212.48.25 P1BG5-Hyve-T41S-2U-CFG LVS03-01-0200-1408-1 asset00486696 tess50 # 1090
# 1535 IRIONIC_ASSET
#noSI lvt11c-1chk.stratus.lvs.ebay.com 10.212.58.34 P1BG5-Hyve-T41S-2U-CFG LVS03-01-0200-0905-1 asset00488600 tess50
#noSI lvt11c-3gps.stratus.lvs.ebay.com 10.212.49.25 P1BG5-Hyve-T41S-2U-CFG LVS03-01-0200-0705-1 asset00486784 tess50 fireflydb-log-lvs-001-002

# 1520
#noSI lvt11c-3spv.stratus.lvs.ebay.com 10.212.5.117 P1G5-Hyve-T41S-2U-CFG LVS03-01-0200-0601-1 asset00472368 tess50 fireflydb-log-lvs-001-001
#noSI lvt11c-3ynq.stratus.lvs.ebay.com 10.212.5.11 P1G5-Hyve-T41S-2U-CFG LVS03-01-0200-0601-1 asset00472334 tess50

# 1521
#noSI lvt11c-4hbe.stratus.lvs.ebay.com 10.212.50.37 P1G6-HPE-XL170R-CFG LVS03-01-0200-0301-1 asset00489836 tess50
# 1536 IRIONIC_ASSET
#noSI lvt11c-4tsq.stratus.lvs.ebay.com 10.212.41.37 P1G6-SMC-6029TP-CFG LVS03-01-0200-0302-1 asset00487375 tess50
#noSI lvt11c-4vcp.stratus.lvs.ebay.com 10.212.74.71 P1G6-Dell-C6420-CFG LVS03-01-0200-0201-1 asset00510456 tess50
#noSI lvt11c-4vsj.stratus.lvs.ebay.com 10.212.72.45 P1G6-Dell-C6420-CFG LVS03-01-0200-0502-1 asset00510526 tess50
#noSI lvt11c-5ixx.stratus.lvs.ebay.com 10.212.72.70 P1G6-Dell-C6420-CFG LVS03-01-0200-0502-1 asset00510306 tess50
#noSI lvt11c-5jpq.stratus.lvs.ebay.com 10.212.50.24 P1G6-HPE-XL170R-CF LVS03-01-0200-0301-1 asset00489839 tess50
#noSI lvt11c-5oyw.stratus.lvs.ebay.com 10.212.50.27 P1G6-HPE-XL170R-CFG LVS03-01-0200-0301-1 asset00489832 tess50 fireflydb-log-lvs-001-006
#noSI lvt11c-5qmd.stratus.lvs.ebay.com 10.212.50.15 P1G6-HPE-XL170R-CFG LVS03-01-0200-0301-1 asset00489822 tess50 fireflydb-log-lvs-001-007
# 1536 IRIONIC_ASSET
#noSI lvt11c-5rvb.stratus.lvs.ebay.com 10.212.41.36 P1G6-SMC-6029TP-CFG LVS03-01-0200-0302-1 asset00487374 tess50 fireflydb-log-lvs-001-004

# 1525
#noSI lvt11c-6ssq.stratus.lvs.ebay.com 10.212.49.60 P1BG5-Hyve-T41S-2U-CFG LVS03-01-0200-0705-1 asset00486801 tess50 fireflydb-log-lvs-001-003
#noSI lvt11c-9gie.stratus.lvs.ebay.com 10.212.48.54 P1BG5-Hyve-T41S-2U-CFG LVS03-01-0200-1408-1 asset00486701 tess50
#noSI lvt11c-9hjp.stratus.lvs.ebay.com 10.212.26.79 P1BG5-Hyve-T41S-2U-CFG LVS03-01-0200-0207-1 asset00480936 tess50

# 1537 IRIONIC_ASSET
#noSI lvt11c-9hrj.stratus.lvs.ebay.com 10.212.59.34 P1BG5-Hyve-T41S-2U-CFG LVS03-01-0200-0706-1 asset00488349 tess50 fireflydb-log-lvs-001-008

# 1526
#noSI lvt11c-6wjp.stratus.lvs.ebay.com 10.212.5.13 P1G5-Hyve-T41S-2U-CFG LVS03-01-0200-0601-1 asset00472333 tess50

# 1527 NODESERVER_EXISTS, 1568, in breakfix
# 1632
#noSI lvt11c-6zdq.stratus.lvs.ebay.com 10.212.74.65 P1G6-Dell-C6420-CFG LVS03-01-0200-0201-1 asset00510292 tess50
# 1536 IRIONIC_ASSET
#noSI lvt11c-8hwr.stratus.lvs.ebay.com 10.212.41.34 P1G6-SMC-6029TP-CFG LVS03-01-0200-0302-1 asset00487368 tess50


# onboard failed
ASSET00479881

# onboard OK
ASSET00527561
ASSET00593032
ASSET00593374
ASSET00463974
ASSET00592583
ASSET00479851
ASSET00478519
ASSET00452927
ASSET00486696
ASSET00488600
ASSET00486784
ASSET00472368
ASSET00472334
ASSET00489836
ASSET00487375
ASSET00510456
ASSET00510526
ASSET00510306
ASSET00489839
ASSET00489832
ASSET00489822
ASSET00487374
ASSET00486801
ASSET00472333
ASSET00510292
ASSET00487368
ASSET00486701
ASSET00480936
ASSET00488349




## delete computes

# put FQDNs into following parenthesis
hosts=(
lvt11c-4tsq.stratus.lvs.ebay.com
lvt11c-4vcp.stratus.lvs.ebay.com
lvt11c-4vsj.stratus.lvs.ebay.com
)

/home/runzhao/bin/delete_computes_keystone.py <(for h in "${hosts[@]}"; do echo $h; done)

# verify deletion
for h in "${hosts[@]}"; do
    echo https://cmsbrowser.vip.stratus.ebay.com/browser/repo/cmsdb/branch/main/query?query=FQDN[@resourceId=\"$h\"'].hostName!NodeServer.nodeServer!Compute'
done


## clean iPXE
# open https://lvs-github-admin01.lvs.ebay.com/server_list/
# => press button: ENTER LIST OF ASSETS
# => input following assets
ASSET00479851


# => select all
# => click button: ACTION
# => select menu item: Provisioning: Clean iPXE for Selected Assets
# => click button: START
# => check the Result in new https://lvs-github-admin01.lvs.ebay.com/ipxe_clean/ make sure all are 200



## onboard assets following step below
# https://wiki.vip.corp.ebay.com/display/IEO/Cassini+TQM


## get SKU, AZ and Tess Clusterof asset

# put assets into following parenthesis
assets=(
ASSET00488395
ASSET00488549
ASSET00618781
)

# get rack of asset
for asset in "${assets[@]}"; do
    rack=$(/ebay/home/jaliang/getFQDNFromAsset.py $asset | awk '{print $2}')
    echo "$asset" "$rack"
done | sort -k2,2 > asset_rask

# get info from rack
while read -r line; do
    asset=$(echo $line | awk '{print $1}')
    rack=$(echo $line | awk '{print $2}')
    /ebay/search/bin/getInfoFromRack.py -r $rack > rack.${asset}
done < asset_rask

# get sku, vcluster, provision_tess_vcluster from info
for asset in "${assets[@]}"; do
    pod_name=$(grep "$asset" rack.${asset} | awk -F'|' '{print $5}' | tr -d ' ')
    info=$(/ebay/git/search/bin/getServInstSkuFqdnFromHost.py $pod_name)
    sku=$(echo $info | awk '{print $3}')
    vcluster=$(echo $info | awk '{print $7}')
    provision_tess_vcluster=$(grep 'tess-node' rack.${asset} | awk -F'|' '{print $3}' | grep -o -E '[0-9]+\.' | tr -d '.' | sort | uniq | xargs)
    echo "$asset : $sku : $vcluster : $provision_tess_vcluster"
done > asset_sku_vcluster_tess

