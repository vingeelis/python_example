#!/usr/bin/env bash

# Migrate LB virtual sbesre.vip.lvs.ebay.com & sbesre.vip.lvs.ebay.com-ssl from lvslb01 to lvslb100 or another LB

## 0. F5 commands
# get virtual
list /ltm virtual sbesre.vip.lvs.ebay.com
list /ltm virtual sbesre.vip.lvs.ebay.com-ssl

# get pool
list /ltm pool sbesre-lvs-http
list /ltm pool sbesre-lvs-http all-properties

# get rule
list /ltm rule sbesre_redirect

# get profile
list /ltm profile client-ssl sbesre.vip.lvs.ebay.com2020


## 1. copy key and cert from old LB to new LB
# old LB = ssh runzhao@lvslb01.lvs.ebay.com
# new LB = ssh runzhao@lvslb108.lvs.ebay.com
ssh runzhao@lvslb01.lvs.ebay.com
# get profile name running following command
list /ltm virtual sbesre.vip.lvs.ebay.com-ssl
# find profiles and copy them to new LB
bash
for ff in $(find /config -name '*sbesre.vip.lvs.ebay.com2020*'); do
    scp "$ff" runzhao@lvslb108.lvs.ebay.com:/tmp/
done


## 2. create nodes in new LB using hostname and ip from cmsquery: LBVirtualIP[@label="sbesre.vip.lvs.ebay.com-ssl"].poolMaps.pool.services{@label,@resourceId}
create /ltm node watchdog-qry-lvs-001-001-1 { address 10.170.3.125 }
create /ltm node watchdog-qry-lvs-001-002 { address 10.123.75.80 }
create /ltm node watchdog-qry-lvs-001-003 { address 10.196.137.96 }
create /ltm node watchdog-qry-lvs-001-004 { address 10.212.71.80 }
create /ltm node watchdog-qry-lvs-001-005 { address 10.123.77.13 }


## 3. create rule
# get rule name running following command from old LB
list /ltm virtual sbesre.vip.lvs.ebay.com
# get rule running following command from old LB
list /ltm rule sbesre_redirect
# create rule in new LB
create /ltm rule sbesre_redirect
    when HTTP_REQUEST {
        switch -glob [string tolower [HTTP::uri]] {
            "/static/*" {
                #log local0. "received request from [IP::remote_addr].  Redirecting to http://[getfield [HTTP::host] ":" 1][HTTP::uri]"
                # Exit if uri contains static
                return
            }
            default {
                HTTP::redirect "https://[HTTP::host]/[HTTP::uri]"
            }
        }
    }

## 4. create pool
# get load-balancing-mode from old LB running following commands, default is round-robin
list /ltm pool sbesre-lvs-http all-properties
# get pool name from old LB running following commands
list /ltm virtual sbesre.vip.lvs.ebay.com
list /ltm virtual sbesre.vip.lvs.ebay.com-ssl
# create pool in new LB
create /ltm pool sbesre-lvs-http members add { watchdog-qry-lvs-001-001-1:9094 watchdog-qry-lvs-001-002:9094 watchdog-qry-lvs-001-003:9094 watchdog-qry-lvs-001-004:9094 watchdog-qry-lvs-001-005:9094 }
list /ltm pool sbesre-lvs-http

## 5. install certs
# get profile name running following command
list /ltm virtual sbesre.vip.lvs.ebay.com-ssl
# get cert name from old LB running following commands
list /ltm profile client-ssl sbesre.vip.lvs.ebay.com2020
# install cert
install /sys crypto cert sbesre.vip.lvs.ebay.com2020 from-local-file /tmp/:Common:sbesre.vip.lvs.ebay.com2020.crt_47851_1
list /sys crypto cert sbesre.vip.lvs.ebay.com2020.crt
# install key
install /sys crypto key sbesre.vip.lvs.ebay.com2020 from-local-file /tmp/:Common:sbesre.vip.lvs.ebay.com2020.key_47847_1
list /sys crypto key sbesre.vip.lvs.ebay.com2020.key

## 6. install intermediate cert
# get profile name in old LB running following command
list /ltm virtual sbesre.vip.lvs.ebay.com-ssl
# get chain name in old LB running following commands
list /ltm profile client-ssl sbesre.vip.lvs.ebay.com2020
# check Serial Number on both old and new LB running following commands, go next if not found
list /sys crypto cert DigiCert-intermediate.crt
# check 'Serial Number' on both old and new LB running following commands, make sure they are equal
bash
find /config/ -name '*DigiCert-intermediate*' | grep -v '\-EV'
openssl x509 -text -in /config/filestore/files_d/Common_d/certificate_d/:Common:DigiCert-intermediate.crt_43095_6 | grep -A1 'Serial Number'
openssl x509 -text -in /config/filestore/files_d/Common_d/certificate_d/:Common:DigiCert-intermediate.crt_39630_1 | grep -A1 'Serial Number'
# install intermediate cert in new LB
install /sys crypto cert DigiCert-intermediate from-local-file /config/filestore/files_d/Common_d/certificate_d/:Common:DigiCert-intermediate.crt_39630_1
list /sys crypto cert DigiCert-intermediate.crt

## 7. create profile in new LB
create /ltm profile client-ssl sbesre.vip.lvs.ebay.com2020 { cert sbesre.vip.lvs.ebay.com2020.crt chain DigiCert-intermediate.crt key sbesre.vip.lvs.ebay.com2020.key }
list /ltm profile client-ssl sbesre.vip.lvs.ebay.com2020

## 8. create virtual
# find free ip from https://lb.vip.ebay.com/easylb/misc/lb_find_free_ip/
# create virtual
create /ltm virtual sbesre.vip.lvs.ebay.com { destination 10.135.227.194:80 ip-protocol tcp pool sbesre-lvs-http profiles add { http tcp } rules { sbesre_redirect } source-address-translation { type automap } }
list /ltm virtual sbesre.vip.lvs.ebay.com
create /ltm virtual sbesre.vip.lvs.ebay.com-ssl { destination 10.135.227.194:443 ip-protocol tcp pool sbesre-lvs-http profiles add { sbesre.vip.lvs.ebay.com2020 tcp } source-address-translation { type automap } }
list /ltm virtual sbesre.vip.lvs.ebay.com-ssl



## rollback plan lvs108
ssh runzhao@lvslb108.lvs.ebay.com

# delete virtual
delete /ltm virtual sbesre.vip.lvs.ebay.com
delete /ltm virtual sbesre.vip.lvs.ebay.com-ssl

# delete pool
delete /ltm pool sbesre-lvs-http

# delete nodes
delete /ltm node watchdog-qry-lvs-001-001-1
delete /ltm node watchdog-qry-lvs-001-002
delete /ltm node watchdog-qry-lvs-001-003
delete /ltm node watchdog-qry-lvs-001-004
delete /ltm node watchdog-qry-lvs-001-005



# verification plan

# list virtual
ssh runzhao@lvslb108.lvs.ebay.com
list /ltm virtual sbesre.vip.lvs.ebay.com
list /ltm virtual sbesre.vip.lvs.ebay.com-ssl

# post a url request on https://sbesre.vip.lvs.ebay.com

# resolve ip address of sbesre.vip.lvs.ebay.com

# wait for days or a week if ok, then go next
ssh runzhao@lvslb01.lvs.ebay.com

# delete virtual
delete /ltm virtual sbesre.vip.lvs.ebay.com
delete /ltm virtual sbesre.vip.lvs.ebay.com-ssl

# delete pool
delete /ltm pool sbesre-lvs-http

# delete nodes
delete /ltm node watchdog-qry-lvs-001-001-1
delete /ltm node watchdog-qry-lvs-001-002
delete /ltm node watchdog-qry-lvs-001-003
delete /ltm node watchdog-qry-lvs-001-004
delete /ltm node watchdog-qry-lvs-001-005
