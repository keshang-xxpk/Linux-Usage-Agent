
psql_host=$1
port_host=$2
db_name=$3
user_name=$4
password=$5

timestamp=$(date "+%Y-%m-%d %H:%M:%S")
memory_free=$(cat /proc/meminfo|egrep MemFree | awk '{print $2}')
cpu_idel=$(vmstat -t | tail -n 1 | awk '{print $11}')
cpu_kernel=$(vmstat -t | tail -n 1 | awk '{print $7}')
disk_io=$(vmstat -d | tail -n 1 | awk '{print $10}')
disk_avaliable=$(df -BM / | tail -n 1 |awk '{print $4}' | sed "s/[^0-9]//g"
)
hostname=`hostname -f`

host_id=$(cat ~/host_id | xargs)

#Step2:construct INSERT statement
insert_stmt=$(cat <<-END
	INSERT INTO host_usage("timestamp",host_id,memory_free,cpu_idel,cpu_kernel,disk_io,disk_avaliable) VALUES('${timestamp}','${host_id}',${memory_free},${cpu_idel},${cpu_kernel},${disk_io},${disk_avaliable};
END)
echo $insert_stmt

export PGPASSWORD=$password
psql -h $psql_host -p $port_host -U $user_name -d $db_name -c "$insert_stmt"

