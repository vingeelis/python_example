-- error : appsvc missing DC part
select *
from appsvc
where substring_index(substring_index(name, ':', 1), '-', -1) not in ('lvs', 'slc', 'rno', 'chd');

-- error : caches that may having mismatched sku between hosttype and vcluster
select count(h.Name), h.Name hosttype, v.Label vcluster
from cache c
         join vcluster v on c.Vcluster = v.Id
         join faultdomain f on c.Faultdomain = f.Id
         join hosttype h on c.Hosttype = h.id
where v.Label not like concat('cassini-', lower(h.Name), '%')
group by h.Name, v.Label
order by 1 desc;

-- count up the number of servers group by appsvc
select count(s.name), substring_index(a.name, ':', 1)
from server s
         left join appsvc a on s.appsvc = a.id
where substring_index(s.name, '-', -1) like 'tess%'
group by a.name;


-- get cache name and its vcluster label and its faultdomain name of a vcluster
select c.Name,v.Label,f.Name
from cache c
         left join vcluster v on c.Vcluster = v.Id
        left join faultdomain f on c.Faultdomain = f.Id
where v.Label = 'cassini-p1g6tesscache-rno'
and (c.Swapped = 'N' or c.Swapped is null)
and c.Available = 'Y'
order by f.Name;


select count(1) from cache
where Swapped = 'N' ;

select count(1) from cache
where Swapped != 'Y';

select count(1) from cache
where Swapped is null;