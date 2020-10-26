#!/usr/bin/env bash

# Migrate cassinfra vips on slclb403.slc.ebay.com to slclb508.slc.ebay.com


## Implementation plan

# old LB
# ssh runzhao@slclb403.slc.ebay.com
# new LB
# ssh runzhao@slclb508.slc.ebay.com

## 0. F5 commands
# get virtual
list /ltm virtual cassinfra.vip.slc.ebay.com-22
list /ltm virtual cassinfra.vip.slc.ebay.com-80
list /ltm virtual cassinfra.vip.slc.ebay.com-443

# get pool
list /ltm pool cassinfra-u-22
list /ltm pool cassinfra-u-80

# get rule
list /ltm rule http_to_https

# get profile
list /ltm profile client-ssl cassinfra.vip.ebay.com.2019

## 1. create nodes in new LB using hostname and ip from cms query:

# LBVirtualIP[@label="cassinfra.vip.slc.ebay.com-22"].poolMaps.pool.services{@label,@resourceId}
create /ltm node slx05c-7aor { address 10.156.136.16 }

# LBVirtualIP[@label="cassinfra.vip.slc.ebay.com-443"].poolMaps.pool.services{@label,@resourceId}
create /ltm node slx05c-3ztu { address 10.156.140.50 }
create /ltm node slx05c-7aor { address 10.156.136.16 }

list /ltm node slx05c-3ztu
list /ltm node slx05c-7aor

## 2. create rule
# get rule name running following command from old LB
list /ltm rule http_to_https

# create rule in new LB
create /ltm rule http_to_https {
    when HTTP_REQUEST {
        set host [HTTP::host]
        HTTP::respond 301 Location "https://$host[HTTP::uri]"
    }
}

list /ltm rule http_to_https

## 3. create pool

# get load-balancing-mode from old LB running following commands, default is round-robin
list /ltm pool cassinfra-u-22 all-properties
list /ltm pool cassinfra-u-80 all-properties

# create pool in new LB
create /ltm pool cassinfra-u-22 load-balancing-mode round-robin members add { slx05c-7aor:22 }
list /ltm pool cassinfra-u-22
create /ltm pool cassinfra-u-80 load-balancing-mode least-connections-member members add { slx05c-7aor:80 slx05c-3ztu:80 } monitor cassinfra
list /ltm pool cassinfra-u-80

## 4. install certs on new LB

# create key and csr in local linux vm
openssl req -nodes -newkey rsa:2048 -sha256 -keyout cassinfra.vip.ebay.com.key -out cassinfra.vip.ebay.com.csr -subj "/C=US/ST=California/L=San Jose/O=eBay, Inc./OU=Site Operations/CN=cassinfra.vip.ebay.com"

# open https://mytools.corp.ebay.com/CertPortal/

# I have a CSR, Paste a Single certificate request into the textare using following command output,
cat cassinfra.vip.ebay.com.csr

# paste Additional SANs into textarea using following,
cassinfra.vip.ebay.com
cassinfra-slc.vip.ebay.com
cassinfra-lvs.vip.ebay.com
cassinfra-rno.vip.ebay.com
cassiopeia.vip.ebay.com
cassiopeia-slc.vip.ebay.com
cassiopeia-lvs.vip.ebay.com
jenga.vip.ebay.com

# select AppType from dropdown list using following,
Load Balancer

# paste Team DL Email address* into text using following,
DL-eBay-Ops-Search@ebay.com

# waiting to approve and download cert

# upload cert and key to new LB by web gui https://slclb508.slc.ebay.com

# check cert and key
list /sys crypto cert cassinfra.vip.ebay.com.2020.crt
list /sys crypto key cassinfra.vip.ebay.com.2020.key
bash
find /config -name '*cassinfra.vip.ebay.com.2020*'

## 5. get issuer (chain or intermediate) cert of cert
bash
openssl x509 -text -in /config/filestore/files_d/Common_d/certificate_d/:Common:cassinfra.vip.ebay.com.2020.crt_44259_1 | grep Issuer:
# get intermediate cert
list /sys crypto cert eBay-SSL-CA-v2-A-2023.crt

## 6. create profile in new LB
create /ltm profile tcp tcp-ssh { app-service none defaults-from tcp idle-timeout 86400000 }
list /ltm profile tcp tcp-ssh
create /ltm profile client-ssl cassinfra.vip.ebay.com.2020 { cert cassinfra.vip.ebay.com.2020.crt chain eBay-SSL-CA-v2-A-2023.crt key cassinfra.vip.ebay.com.2020.key }
list /ltm profile client-ssl cassinfra.vip.ebay.com.2020

## 7. create virtual
# find free ip of new LB from https://lb.vip.ebay.com/easylb/misc/lb_find_free_ip/

# create virtual, substitute following $free_ip:port with the real before run following
create /ltm virtual cassinfra.vip.slc.ebay.com-22 { destination 10.127.201.59:22 ip-protocol tcp pool cassinfra-u-22 profiles add { tcp-ssh } source-address-translation { type automap } }
list /ltm virtual cassinfra.vip.slc.ebay.com-22

create /ltm virtual cassinfra.vip.slc.ebay.com-80 { destination 10.127.201.59:80 ip-protocol tcp profiles add { http tcp } rules { http_to_https } source-address-translation { type automap } }
list /ltm virtual cassinfra.vip.slc.ebay.com-80

create /ltm virtual cassinfra.vip.slc.ebay.com-443 { destination 10.127.201.59:443 ip-protocol tcp pool cassinfra-u-80 profiles add { cassinfra.vip.ebay.com.2020 http tcp } source-address-translation { type automap } }
list /ltm virtual cassinfra.vip.slc.ebay.com-443

## 8. add A Record by https://easydns.vip.ebay.com



## rollback plan new LB

# delete virtual on new LB
delete /ltm virtual cassinfra.vip.slc.ebay.com-22
delete /ltm virtual cassinfra.vip.slc.ebay.com-80
delete /ltm virtual cassinfra.vip.slc.ebay.com-443

# delete pool on new LB
delete /ltm pool cassinfra-u-22
delete /ltm pool cassinfra-u-80

# delete nodes on new LB
delete /ltm node slx05c-7aor
delete /ltm node slx05c-3ztu


# verification plan

# list virtual on new LB
list /ltm virtual cassinfra.vip.slc.ebay.com-22
list /ltm virtual cassinfra.vip.slc.ebay.com-80
list /ltm virtual cassinfra.vip.slc.ebay.com-443

# POST a url request on new VIP
# POST a url request on https://cassinfra.vip.ebay.com
# resolve ip address of cassinfra.vip.ebay.com

# wait for days or a week, if ok then go next

# delete A Record by https://easydns.vip.ebay.com

# delete virtual on old LB
delete /ltm virtual cassinfra.vip.slc.ebay.com-22
delete /ltm virtual cassinfra.vip.slc.ebay.com-80
delete /ltm virtual cassinfra.vip.slc.ebay.com-443

# delete pool on old LB
delete /ltm pool cassinfra-u-22
delete /ltm pool cassinfra-u-80

# delete nodes on old LB
delete /ltm node slx05c-7aor
delete /ltm node slx05c-3ztu

