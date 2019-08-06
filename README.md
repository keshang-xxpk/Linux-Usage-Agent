# Introduction
#### The project builds a cluster monitor to help us monitoring the cluster resources internal.It help us to know more about hows the cpu works,how many space we still have and lots of other details.


# Architechture and design
- ![image](http://github.com/itmyhome2013/readme_add_pic/raw/master/images/nongshalie.jpg)


- Create a database named"host_agent"and use its default schema "public"
- psql----host_agent
- schema---default public
- table----create table<pre>host_info,host_usage</pre>
- Using two tabels to storage all the information.
- Using Scripts to collect data from system and get connection
- Using crontab  to trigger host_usage.sh every minute

# Usage
- **database** <pre>host_agent</pre> in docker container and create two tables **host_info** and **host_usage** in it.
- **host_info**  <pre>id,hostname,cpu_number,cpu_architecture,cpu_model_cpu_mhz,L2-cache,timestamp</pre>
- **host_usage**  <pre>"timestamp,host_id,memory_free,cpu_idel,cpu_kernel,disk_io,disk_available</pre>
- crontab allow us to set up the frequency you want the scripts to excute.

# Improvements
- handle hardware update
- easier to extend the program later
- reduce heigh latency
