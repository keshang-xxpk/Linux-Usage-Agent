psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5
export PGPASSWORD=$psql_password

vmstat=$(vmstat -t --unit M | tail -1)
vmstatD=$(vmstat -d | tail -1)

function getTimestamp {
        ts=$(echo $vmstat | awk '{print $18, $19}')
}

function getVmstatHelper {
	pattern=$1
	value=$(echo $vmstat | awk '{print '$pattern'}')
	echo $value
}

function getHostId {
	host_id=$(cat /home/centos/dev/jrvs/bootcamp/host_agent/scripts/host_id.txt)
}

function getMemFree {
	memFree=$(echo $vmstat | awk '{print $4}')
}

function getCpuIdel {
	cpuIdel=$(echo $vmstat | awk '{print $15}') 
}

function getCpuKernel {
	cpuKernel=$(echo $vmstat | awk '{print $14}')
}

function getDiskIO {
	diskIO=$(echo $vmstatD | awk '{print $10}')
}

function getDiskAvailable {
	diskAvailable=$(df -BM | egrep '/$' | awk '{print $4}' | sed 's/M//')
}
getTimestamp
getHostId
getMemFree
getCpuIdel
getCpuKernel
getDiskIO
getDiskAvailable

insert=$(cat <<-END
INSERT INTO PUBLIC.host_usage ("timestamp", host_id, memory_free, cpu_idel, cpu_kernel, disk_io, disk_available) 
VALUES ('$ts', $host_id, $memFree, $cpuIdel, $cpuKernel, $diskIO, $diskAvailable);
END
)

psql -h $psql_host -U $psql_user $db_name -c "$insert"
