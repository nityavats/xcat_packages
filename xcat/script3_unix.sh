#PART 3


#!/bin/bash


#wget http://mirrors.nxtgen.com/centos-mirror/7.9.2009/isos/x86_64/CentOS-7-x86_64-DVD-2009.iso
copycds CentOS-7-x86_64-DVD-2009.iso
genimage centos7.9-x86_64-netboot-compute

touch /install/netboot/compute.synclists
echo "/etc/passwd -> /etc/passwd" >> /install/netboot/compute.synclist
echo "/etc/group -> /etc/group" >> /install/netboot/compute.synclist
echo "/etc/shadow -> /etc/shadow" >> /install/netboot/compute.synclist

path_of_computelist="\"/install/netboot/compute.synclists\""
compute_list="chdef -t osimage centos7.9-x86_64-netboot-compute synclists=$path_of_computelist"
eval "$compute_list"

#chdef -t osimage centos7.9-x86_64-netboot-compute synclists="/install/netboot/compute.synclists" #This does not run in bash
packimage centos7.9-x86_64-netboot-compute


###############################################################################################

#PART 4


#!/bin/bash

domain_name=`cat /root/inputs/domain_name`
hostname_master=`cat /root/inputs/hostname_master`
private_interface=`cat /root/inputs/private_interface`
private_ip=`cat /root/inputs/private_ip`

chdef -t site domain=$domain_name
dhcpinterfaces="chdef -t site dhcpinterfaces='$hostname_master|$private_interface'"
eval "$dhcpinterfaces"
worker_password=$(zenity --entry --title="Password" --text="Provide a common password for all worker nodes : ")
#read -p "Provide Password for worker node : " worker_password
passwd="chtab key=system passwd.username=root passwd.password=$worker_password"
eval "$passwd"
#chtab key=system passwd.username=root passwd.password=$worker_password
makedhcp -n
makedns -n
makentp
systemctl restart dhcpd


###############################################################################################


#PART 5

#!/bin/bash

name_of_node=$(zenity --entry --title="Node name required" --text="Please provide a name to your node : ")
#read -p "Please provide a name to your node : " name_of_node
ip_of_node=$(zenity --entry --title="ip required" --text="Please provide the ip which you want it to be assigned to $name_of_node1 : ")
#read -p "Please provide the ip which you want it to be assigned to $name_of_node1 : " ip_of_node
mac_of_node=$(zenity --entry --title="ip required" --text="Please mention the mac address of $name_of_node in colon-hexadecimal notation : ")
#read -p "Please mention the mac address in of $name_of_node1 in colon-hexadecimal notation : " mac_of_node


mkdef -t node -o $name_of_node groups=all netboot=pxe ip=$ip_of_node mac=$mac_of_node provmethod=centos7.9-x86_64-netboot-compute

#echo "$ip_of_node $name_of_node $name_of_node.$domain_name" >> /etc/hosts        
#echo "nameserver $master_privateip" >> /etc/resolv.conf


makehosts
makenetworks
makedhcp -n
makedns -n
makentp
systemctl restart dhcpd

nodeset $name_of_node osimage=centos7.9-x86_64-netboot-compute

whiptail --msgbox " $name_of_node is ready, please start the machine . Press Enter to continue." 10 50