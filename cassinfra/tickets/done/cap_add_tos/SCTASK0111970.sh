# SCTASK0111970

# short description : Add capacity to TRS service for Holiday capacity as well as help with LVS memory upgrade

# description
We need a small amount of capacity add (24 nodes per DC) to the TRS5 pool for Holidays (will also help with LVS P1G7 memory upgrade). The LVS capadd is the highest priority due to planned memory upgrade:

P1G6:
search-trs5-rno-001-121/144
search-trs5-slc-001-121/144

P1G7:
search-trs5-lvs-001-121/144


## Business justification
capacity add


## Implementation plan


#1 tell Oy <owong@ebay.com> of the new SKU of the server.

#2 init
task_id=SCTASK0111970
change_id=CHG3457168
n_threshold_limit=$((144*20/100))
n_caches_required=24
mkdir -p /home/runzhao/tickets/$task_id
cd /home/runzhao/tickets/$task_id || echo "cd failed"
source ~runzhao/.bash_runzhao

#3 sync caches before pick caches
/ebay/git/search/bin/casswap_db.py --sync-cache-vcluster cassini-p1g6tesscache-rno
/ebay/git/search/bin/casswap_db.py --sync-cache-vcluster cassini-p1g6tesscache-slc
/ebay/git/search/bin/casswap_db.py --sync-cache-vcluster cassini-p1g7tesscache-lvs
/ebay/git/search/bin/casswap_db.py --sync-cache-vcluster cassini-p1g6cache-rno
/ebay/git/search/bin/casswap_db.py --sync-cache-vcluster cassini-p1g6cache-slc
/ebay/git/search/bin/casswap_db.py --sync-cache-vcluster cassini-p1g7cache-lvs

#4 pick caches
# pick 24 caches from cache page tab of https://cassinfra.vip.ebay.com/cassinfra/topology.html ,
# (Swapped is null or Swapped == 'N') and Available == 'Y' is required
# the field Swapped which contains Null string is not friendly to awk, so the fields Faultdomain and Vcluster which are in the behind should get like awk '{print $(NF-5)}' and -4
function get_cache() {
    file_cache=${1}.cache
    file_tmp=${1}.tmp
    echo $file_cache
    cat /dev/null > $file_cache
    while IFS= read -r line; do
    if [ $(cat $file_cache | wc -l) -eq $n_caches_required ]; then
        break
    fi
    hostname=$(echo "$line" | awk '{print $1}')
    vcluster=$(echo "$line" | awk '{print $(NF-4)}')
    vcluster=$(mysql-root -ns -d 'casswap' "select label from vcluster where name = '$vcluster';" 2>/dev/null)
    rack=$(echo "$line" | awk '{print $(NF-5)}')
    rack=${rack%-1}
    rack=${rack%-2}
    rack=${rack%-3}
    rack=${rack%-4}
    if [ $(grep "$rack" $file_cache | wc -l) -lt $n_threshold_limit ]; then
        echo "${hostname} ${vcluster} ${rack}" >> $file_cache
    fi
    done < $file_tmp
    awk '{count[$3]++}END{for (c in count) print count[c], c}' $file_cache | sort -nr
    echo "in total: " $(wc -l $file_cache)
}

# for rno, search keyword p1g6 rno and dump result into file rno.tmp
get_cache rno

# for slc, search keyword p1g6 slc and dump result into file slc.tmp
get_cache slc

# for lvs, search keyword p1g7 lvs and dump result into file tmp
get_cache lvs


#5 check tess_key in /ebay/search/lib/, request a new tess_key and put it here if tess_key not find
for rack in $(cat *.cache | awk '{print $3}' | sort | uniq); do
    /ebay/search/bin/getInfoFromRack.py -r $rack > $rack.info
done

mapfile -t tess_clusters < <(cat *.info | grep -Po 'tess-node-\w+-tess\d+' | awk -F'-' '{print $NF}' | sort | uniq | grep -Po '\d+')
echo ${tess_clusters[@]}

# /ebay/search/lib/tess_key_16 not found
for t in ${tess_clusters[@]}; do
    test -f /ebay/search/lib/tess_key_$t || echo "no such /ebay/search/lib/tess_key_$t"
done


#5 move vcluster
function moveVcluster() {
    colo=$1
    while IFS= read -r line; do
        /ebay/git/search/bin/moveVcluster.py "$(echo $line | awk '{print $1}')" "$(echo $line | awk '{print $2}')" "search-trs5-${colo}"
    done < ${colo}.cache | tee moveVcluster.$colo
    test $(grep OK moveVcluster.$colo | wc -l) -eq $n_caches_required || { echo "failed hosts of moveVcluster:"; diff <(cat ${colo}.cache | awk -F '{print $1}' | sort) <(grep '\-tess' moveVcluster.${colo} | sort); }
}

function checkVcluster() {
    colo=$1
    vcluster=$2
    for host in $(cat ${colo}.cache | awk '{print $1}'); do
        echo -n "$host "
        /ebay/git/search/bin/getClusterOfHost.py $host
    done | tee getClusterOfHost.${colo}
    test $(grep "search-trs5-${colo}" getClusterOfHost.${colo} | wc -l) -eq $n_caches_required
    if [ $? -ne 0 ]; then
        echo "not all caches were move to search-trs5-${colo}:"
        diff -y <(cat ${colo}.cache | awk '{print $1}' | sort) <(grep -v "search-trs5-${colo}" getClusterOfHost.${colo} | awk '{print $1}' | sort);
    else
        echo "caches were all moved search-trs5-${colo}"
    fi
}

moveVcluster rno
checkVcluster rno

moveVcluster slc
checkVcluster slc

moveVcluster lvs
checkVcluster lvs


#7 add nodes
# rno
/ebay/git/search/bin/add_tos.py --appsvc "search-trs5-rno:ENVgo3rsvfa" --racks <(cat rno.cache | awk '{print $3}') --cr "$change_id" --simulate
# good to proceed if no errors raise
/ebay/git/search/bin/add_tos.py --appsvc "search-trs5-rno:ENVgo3rsvfa" --racks <(cat rno.cache | awk '{print $3}') --cr "$change_id"

# slc
/ebay/git/search/bin/add_tos.py --appsvc "search-trs5-slc:ENVgo3rsvfa" --racks <(cat slc.cache | awk '{print $3}') --cr "$change_id" --simulate
# good to proceed if no errors raise
/ebay/git/search/bin/add_tos.py --appsvc "search-trs5-slc:ENVgo3rsvfa" --racks <(cat slc.cache | awk '{print $3}') --cr "$change_id"

# lvs
/ebay/git/search/bin/add_tos.py --appsvc "search-trs5-lvs:ENVgo3rsvfa" --racks <(cat lvs.cache | awk '{print $3}') --cr "$change_id" --simulate
# good to proceed if no errors raise
/ebay/git/search/bin/add_tos.py --appsvc "search-trs5-lvs:ENVgo3rsvfa" --racks <(cat lvs.cache | awk '{print $3}') --cr "$change_id"

# verify FQDNs of svcinst
# rno -eq 48
rows=({120..143})
for row in ${rows[@]}; do
    host search-trs5-rno-001-${row}
done | grep -e 'alias' -e 'address' | wc -l

# slc -eq 48
rows=({121..144})
for row in ${rows[@]}; do
    host search-trs5-slc-001-${row}
done | grep -e 'alias' -e 'address' | wc -l

# lvs -eq 48
rows=({121..144})
for row in ${rows[@]}; do
    host search-trs5-lvs-001-${row}
done | grep -e 'alias' -e 'address' | wc -l


#8 sync cassini database
function sync_db() {
    /ebay/git/search/bin/casswap_db.py --sync-cache-vcluster cassini-p1g6tesscache-rno
    /ebay/git/search/bin/casswap_db.py --sync-cache-vcluster cassini-p1g6tesscache-slc
    /ebay/git/search/bin/casswap_db.py --sync-cache-vcluster cassini-p1g7tesscache-lvs
    /ebay/git/search/bin/casswap_db.py --sync-cache-vcluster cassini-p1g6cache-rno
    /ebay/git/search/bin/casswap_db.py --sync-cache-vcluster cassini-p1g6cache-slc
    /ebay/git/search/bin/casswap_db.py --sync-cache-vcluster cassini-p1g7cache-lvs
    /ebay/git/search/bin/casswap_db.py --sync-appsvc "search-trs5-rno:ENVgo3rsvfa"
    /ebay/git/search/bin/casswap_db.py --sync-appsvc "search-trs5-slc:ENVgo3rsvfa"
    /ebay/git/search/bin/casswap_db.py --sync-appsvc "search-trs5-lvs:ENVgo3rsvfa"
}

sync_db

source ~runzhao/.bash_runzhao
mysql-root -ns -d 'casswap' "select count(1) from server where Svcinst like 'search-trs5-rno-%';"  # should be 144
mysql-root -ns -d 'casswap' "select count(1) from server where Svcinst like 'search-trs5-slc-%';"  # should be 144
mysql-root -ns -d 'casswap' "select count(1) from server where Svcinst like 'search-trs5-lvs-%';"  # should be 144


#9 add to cass-mon
# rno
for row in $(seq 120 143); do
    /ebay/search/bin/mcManualAddForCassini "RNO TRS5" "search-trs5-rno-001-${row}:9177" "leaf"
done

# slc
for row in $(seq 121 144); do
    /ebay/search/bin/mcManualAddForCassini "SLC TRS5" "search-trs5-slc-001-${row}:9177" "leaf"
done

# lvs
for row in $(seq 121 144); do
    /ebay/search/bin/mcManualAddForCassini "LVS TRS5" "search-trs5-lvs-001-${row}:9177" "leaf"
done

#10 mail to topology-change and Oy
# DL-eBay-Cassini-Topology-Change
# owong@ebay.com


## Rollback plan
# delete rows
# sync db
# move hosts from lla && qry to corresponding cache


# Verification plan
# make sure above pods are serving traffic



