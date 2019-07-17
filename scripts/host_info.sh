#!/bin/bash

function getHostname {
	hostname=$(hostname -f)
}

function helperLSCPU (){
	value=$(lscpu | egrep '$1' | awk '{print $2}')
}

function getCPU { 
	cpu=$(lscpu | egrep '^CPU\(s\)' | awk '{print $2}')
}

function getArchitecture {
	architecture=$(lscpu | egrep '^Architecture' | awk '{print $2}')	
}

function getCpuModel {
	cpuModel=$(lscpu | egrep '^Model name' | awk '{ for(i=3; i < NF; i++) n = n $i " "; n= n $NF; print n}')
}

function getCpuMhz {
	cpuMhz=$(lscpu | egrep '^CPU MHz' | awk '{print $3}')
}

function getL2Cache {
	l2Cache=$(lscpu | egrep '^L2 cache' | awk '{print $3}' | sed 's/K//')
}

function getTimestamp {
	ts=$(date '+%Y-%m-%d %H:%M:%S')
}

function getMem {
	totalMem=$(cat /proc/meminfo | egrep '^MemTotal' | awk '{print $2}')
}

getHostname
getCPU
getArchitecture
getCpuModel
getCpuMhz
getL2Cache
getTimestamp
getMem

insert=$(cat <<-END
INSERT INTO PUBLIC.host_info (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, "timestamp", total_mem) 
VALUES ('$hostname', $cpu, '$architecture', '$cpuModel', $cpuMhz, $l2Cache, '$ts', $totalMem);
END
)

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5
export PGPASSWORD=$psql_password
 
psql -h $psql_host -U $psql_user $db_name -c "$insert"

psql -h $psql_host -U $psql_user $db_name -c "SELECT id FROM PUBLIC.host_info WHERE hostname='$hostname'" | head -3 | tail -1 | xargs > host_id.txt
