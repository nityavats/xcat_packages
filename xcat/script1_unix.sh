#!/bin/bash

#user=`whoami`
#$user ALL=(ALL) NOPASSWD: /home/part0.sh | sudo tee -a /usr/sbin/visudo


####################################################################################################################################################################################################


#PART 1
ifup ens33

whiptail --msgbox "Welcome to Setup wizard of xCAT. Press Enter to continue." 10 50
yum install zenity -y


#Disable Firewall
systemctl stop firewalld.service; systemctl stop firewalld
systemctl disable firewalld.service; systemctl disable firewalld

#Disable SELINUX
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux

#Disable DHCP on the interface
private_interface=$(zenity --entry --title="Private network's interface required" --text="Please mention the interface of private network : ")
mkdir -p /root/inputs
touch /root/inputs/private_interface
echo "$private_interface" > /root/inputs/private_interface


#read -p "Please mention the interface of private network : " private_interface
#sed -i '/BOOTPROTO/d' /etc/sysconfig/network-scripts/ifcfg-$private_interface
#echo "BOOTPROTO=none" >> /etc/sysconfig/network-scripts/ifcfg-$private_interface

#Taking inputs Hostname, IP, Domain name

hostname_master=$(zenity --entry --title="Hostname required" --text="Provide a hostname to your master.")
touch /root/inputs/hostname_master
echo "$hostname_master" > /root/inputs/hostname_master
#read -p "Provide a hostname to your master : " hostname_master


privateip_network=$(ip a show dev $private_interface | grep -oP 'inet \K[\d.]+')
echo "nameserver $privateip_network" >> /etc/resolv.conf    #this command not running in bash
touch /root/inputs/private_ip
echo "$privateip_network" > /root/inputs/private_ip

zenity \
--info \
--text="current ip is $privateip_network.\n DO NOT CHANGE THE IP" \
--title="xCAT setup" \
--ok-label="OK"
                                   
#whiptail --msgbox "Your current Private ip is $privateip_network. Press Enter & retype the same ip LOL." 10 50
#read -p "Retype Private ip of your Master Node : " master_privateip
       
domain_name=$(zenity --entry --title="Domain name required" --text="Please provide a domain name.")
touch /root/inputs/domain_name
echo "$domain_name" > /root/inputs/domain_name
                          
#read -p "Please provide a domain name --Example 'avicii.in' -- : " domain_name               
hostnamectl set-hostname $hostname_master.$domain_name		                                                   

#Changing network
#privateip_network=$(ip a show dev $private_interface | grep -oP 'inet \K[\d.]+')
#read -p "Provide Private ip to your Master Node : " master_privateip
#ip addr add $master_privateip/255.255.255.0 dev ens34
#sed -i 's/IPADDR=$privateip_network/IPADDR=$master_privateip/g' /etc/sysconfig/network-scripts/ifcfg-$private_interface
#echo "BOOTPROTO=none" >> /etc/sysconfig/network-scripts/ifcfg-$private_interface
#ifdown $private_interface
#ifup $private_interface

#Assigning values
echo "$privateip_network $hostname_master $hostname_master.$domain_name" >> /etc/hosts
#echo "nameserver $privateip_network" >> /etc/resolv.conf    #this command not running in bash
#echo "nameserver $privateip_network" | sudo tee -a /etc/resolv.conf      #This runs but you need to enter password

whiptail --msgbox "Machine needs a reboot, please press Enter to continue." 10 50

exec bash | bash script2_unix.sh 
