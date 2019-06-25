1.Select * from host_usage group by CPU_number order by total_mem decs


select u.host_id,i.hostname,i.total_mem,Avg(i.total_mem - u.memory_free) over(partition by u.host_id order by u.”timestamp” desc rows between 5 preceding and current row) from host_usage u inner join host_info I on u.host_id=I.id
