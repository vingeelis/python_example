# source env
source ~runzhao/.bash_runzhao

# backup date only
mysqldump -uroot -hsbe-dbrokar-phx-001.vip.ebay.com -p --no-create-info --single-transaction --skip-triggers casswap server >casswap.server.sql

# casswap
mysql_root -ns -d "casswap" "show tables;"
mysql_root -ns -d "casswap" "select * from appsvc;" | awk -F' +|:' '/ENVgo3rsvfa/ {print $2}' | sort >appsvcs.txt
mysql_root -d "casswap" "select * from server where svcinst like 'completed-%'"

mysql_root -n -s -d "casswap" "select count(s.name), substring_index(a.name, ':', 1) from server s left join appsvc a on s.appsvc = a.id
where substring_index(s.name, '-', -1) like 'tess%'
group by a.name
;"

# casswap dump structure only (without data and triggers)
password=
table=
mysqldump \
    -u speedy \
    -h sbe-dbrokar-phx-001.vip.ebay.com \
    -p${password} \
    --no-data --routines --events --single-transaction --skip-triggers --lock-tables=false \
    cassfix ${table} >/home/runzhao/upload/runzhao/cassifx.${table}.sql.no-data.$(date -Iseconds)

# casswap dump data only
password=
table=
mysqldump \
    -u speedy \
    -h sbe-dbrokar-phx-001.vip.ebay.com \
    -p${password} \
    --no-create-info --single-transaction --skip-triggers --lock-tables=false \
    cassfix ${table} >/home/runzhao/upload/runzhao/cassfix.${table}.sql.data-only.$(date -Iseconds)

# casswap restore
mysql -u ${user} -h ${host} -p${password} ${database} <dump.sql

# get the Belongs To if a service instance in cass-mon
mapfile -t group_name < <(mysql-root -ns -d 'dbrokar' 'select name from `service entity` where uid = (select `Belongs To` from `service entity` where name like "search-tla6-chd-001-001\\:9177");')
echo "${group_name[@]}"

sql_stmt="select count(c.name), f.Name, v.Label rack
from cache c
         join vcluster v on c.Vcluster = v.Id
         join faultdomain f on c.Faultdomain = f.Id
         join hosttype h on c.Hosttype = h.id
             and h.Name = 'P1G7'
where v.Label in ('cassini-p1g7cache-lvs', 'cassini-p1g7tesscache-lvs')
group by f.Name, v.Label
having count(c.name) >= 2
order by 1 desc;"
mysql-root -ns -d 'casswap' "$sql_stmt"

sql_stmt="select count(c.name), f.Name, v.Label rack
from cache c
         join vcluster v on c.Vcluster = v.Id
         join faultdomain f on c.Faultdomain = f.Id
         join hosttype h on c.Hosttype = h.id
    and h.Name = 'P1G6'
where v.Label in ('cassini-p1g6cache-slc', 'cassini-p1g6tesscache-slc')
group by f.Name, v.Label
having count(c.name) >= 20
order by 1 desc;"
mysql-root -ns -d 'casswap' "$sql_stmt"

sql_stmt="select count(c.name), f.Name, v.Label rack
from cache c
         join vcluster v on c.Vcluster = v.Id
         join faultdomain f on c.Faultdomain = f.Id
         join hosttype h on c.Hosttype = h.id
    and h.Name = 'P1G6'
where v.Label in ('cassini-p1g6cache-rno', 'cassini-p1g6tesscache-rno')
group by f.Name, v.Label
having count(c.Name) >1
order by 1 desc;"
mysql-root -ns -d 'casswap' "$sql_stmt"

# caches that are mismatch sku between hosttype and vcluster
sql_stmt="select c.*, v.Label
from cache c
         join vcluster v on c.Vcluster = v.Id
         join faultdomain f on c.Faultdomain = f.Id
         join hosttype h on c.Hosttype = h.id
    and h.Name = 'P1G6'
where v.Label in ('cassini-p1g5cache-lvs', 'cassini-p1g3cache-lvs');"
mysql-root -ns -d 'casswap' "$sql_stmt"
