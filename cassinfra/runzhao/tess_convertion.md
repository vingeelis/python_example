We are removing following pools and row from production, to be converted to Tess and put back in production.

- dsbe2-qry-slc-[001-008]-[002]
- dsbe2-lla-slc-001-[003-016]
- search-trs5-slc-001-[003-020]

See the list of services, nodeServers that are being converted under this CR at the bottom of this page.

We have sufficient capacity in Cassini Pools in slc after we remove these rows from production.

## Get the snapshot of lifecycle status of the nodes using lcState.py

	lcState.py -f <file with nodeServers>
	
	
## Take the services/nodes out of production.
 
If any nodes are hotswapped, swap them back to original nodes, even if they are unhealthy.
Remove Qry, LLAs in separate steps. 
Run with --simulate option first. If the output looks good, run without the --simulate option to actually remove the rows.
    
    sudo /ebay/search/bin/remove_row_no_lla.py --simulate --appsvc dsbe2-qry-slc:ENVgo3rsvfa --row 002 --no-strict --to-vcls cassini-decommed --cr <CR>
    sudo /ebay/search/bin/remove_row_no_lla.py --appsvc dsbe2-qry-slc:ENVgo3rsvfa --row 002 --no-strict --to-vcls cassini-decommed --cr <CR>
    
    sudo /ebay/search/bin/remove_tos.py --simulate --appsvc dsbe2-lla-slc:ENVgo3rsvfa --svc-num 003-016 --to-vcls cassini-decommed --cr <CR>
    sudo /ebay/search/bin/remove_tos.py --appsvc dsbe2-lla-slc:ENVgo3rsvfa --svc-num 003-016 --to-vcls cassini-decommed --cr <CR>
    
    sudo /ebay/search/bin/remove_tos.py --simulate --appsvc search-trs5-slc:ENVgo3rsvfa --svc-num 003-020 --to-vcls cassini-decommed --cr <CR> 
    sudo /ebay/search/bin/remove_tos.py --appsvc search-trs5-slc:ENVgo3rsvfa --svc-num 003-020 --to-vcls cassini-decommed --cr <CR> 

##  Sync swap db

    /ebay/search/bin/casswap_db.py --sync-appsvc dsbe2-qry-slc:ENVgo3rsvfa
    /ebay/search/bin/casswap_db.py --sync-appsvc dsbe2-lla-slc:ENVgo3rsvfa
    /ebay/search/bin/casswap_db.py --sync-appsvc search-trs5-slc:ENVgo3rsvfa

## Verify the nodes are in SACHECK and admin notes "__CAP_ADD__ __NO_ACTION__".

	/ebay/search/bin/lcState.py -f <file with nodeServers>

## If necessary, update admin state and admin notes

    /ebay/search/bin/changeProdStatus.py -s prep -a SACHECK -n '__CAP_ADD__ __NO_ACTION__ Converting to Tess' -f <file with nodeServers>
  
## Delete computes on the BM nodes on the above nodes we removed from production

    /ebay/search/bin/delete_compute_new.py <ip1 ip2 ...>

## Handover Assets to ES team to convert to Tess

    It may take 1-2 days to convert to Tess

## Once Tess nods are ready, add the new Tess nodes back into production

	*** Make sure SKU is correct when adding a row back
	*** For example, if row 1 SKU was previously P1BG5, make sure you put back P1BG5 in row 1 after Tess conversion. The same is true for SKUs P1G6 and P1G7 etc.

### make sure nodes are healthy

	/ebay/search/bin/sysHealth -f <file with nodeServers>
	
### move the nodes from cache vcluster to vclusters dsbe2-qry-slc, dsbe2-lla-slc, search-trs5-slc

    for i in `cat list_of_hosts.txt` ; do /ebay/search/bin/moveVcluster.py $i <cache vcluster> <pool name>; done
    examples:
    for i in `cat list_of_hosts.txt` ; do /ebay/search/bin/moveVcluster.py $i cassini-p1g5tesscache-slc <pool name>; done
    for i in `cat list_of_hosts.txt` ; do /ebay/search/bin/moveVcluster.py $i cassini-p1bg5tesscache-slc <pool name>; done
    for i in `cat list_of_hosts.txt` ; do /ebay/search/bin/moveVcluster.py $i cassini-p1g6tesscache-slc <pool name>; done
    for i in `cat list_of_hosts.txt` ; do /ebay/search/bin/moveVcluster.py $i cassini-p1eg6tesscache-slc <pool name>; done
    for i in `cat list_of_hosts.txt` ; do /ebay/search/bin/moveVcluster.py $i cassini-p1g7tesscache-slc <pool name>; done
    
### run add_tos.py with --simulate option and then without --simulate option. It will also run the ready script on the nodes.

    sudo /ebay/search/bin/add_tos.py --simulate --appsvc dsbe2-lla-slc:ENVgo3rsvfa --racks <file with racknames> --no-strict --cr <CR>
    sudo /ebay/search/bin/add_tos.py --appsvc dsbe2-lla-slc:ENVgo3rsvfa --racks <file with racknames> --no-strict --cr <CR>
    	
### run add_row_no_lla.py with --simulate option and then without --simulate option. It will also run the ready script on the nodes.

    sudo /ebay/search/bin/add_row_no_lla.py --simulate --appsvc dsbe2-qry-slc:ENVgo3rsvfa --racks <file with racknames> --no-strict --cr <CR>
    sudo /ebay/search/bin/add_row_no_lla.py --appsvc dsbe2-qry-slc:ENVgo3rsvfa --racks <file with racknames> --no-strict --cr <CR>
    
### run add_tos.py with --simulate option and then without --simulate option. It will also run the ready script on the nodes.

    sudo /ebay/search/bin/add_tos.py --simulate --appsvc search-trs5-slc:ENVgo3rsvfa --racks <file with racknames> --no-strict --cr <CR>
    sudo /ebay/search/bin/add_tos.py --appsvc search-trs5-slc:ENVgo3rsvfa --racks <file with racknames> --no-strict --cr <CR>


## Sync swap db

        /ebay/search/bin/casswap_db.py --sync-appsvc dsbe2-qry-slc:ENVgo3rsvfa
        /ebay/search/bin/casswap_db.py --sync-appsvc dsbe2-lla-slc:ENVgo3rsvfa
        /ebay/search/bin/casswap_db.py --sync-appsvc search-trs5-slc:ENVgo3rsvfa
        /ebay/search/bin/casswap_db.py --sync-cache-vcluster cassini-p1g5tesscache-slc
        /ebay/search/bin/casswap_db.py --sync-cache-vcluster cassini-p1bg5tesscache-slc
        /ebay/search/bin/casswap_db.py --sync-cache-vcluster cassini-p1g6tesscache-slc
        /ebay/search/bin/casswap_db.py --sync-cache-vcluster cassini-p1eg6tesscache-slc
        /ebay/search/bin/casswap_db.py --sync-cache-vcluster cassini-p1g7tesscache-slc

### Verify the nodes are in prep:NORMAL which is the state after ready_cassini_nodes.py is run. If necessary, update admin state and admin notes

    /ebay/search/bin/lcState.py -f <file with hostnames>
    /ebay/search/bin/changeProdStatus.py -s prep -a NORMAL -n 'Converted to Tess' -f <file with hostnames>

### Notify Cassini team (Oyland Wong) as an FYI

### LLAs will start taking traffic within couple hours

### Querynodes may take up to 1 day to start taking traffic

### Once nodes are in traffic, make sure the nodes are in live:NORMAL status

