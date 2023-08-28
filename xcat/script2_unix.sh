#PART 2


#!/bin/bash


#Updating yum and Utilities
yum install zenity -y
yum install xterm -y
yum install ntp -y
yum update -y
yum install yum-utils -y
wget -P /etc/yum.repos.d https://xcat.org/files/xcat/repos/yum/latest/xcat-core/xcat-core.repo --no-check-certificate
wget -P /etc/yum.repos.d https://xcat.org/files/xcat/repos/yum/xcat-dep/rh7/x86_64/xcat-dep.repo --no-check-certificate
yum install epel-release -y
yum clean all
yum makecache
yum install xCAT -y
#chmod 777 /etc/profile.d/xcat.sh


#SOURCE
source /etc/profile.d/xcat.sh
cat /etc/profile.d/xcat.sh | bash script3_unix.sh


