#!/bin/bash
#ONLY USE IF INTERFACES ARE NOT CREATED SINCE IT COULD CAUSE ISSUES! IF INTERFACES ALREADY CREATED USE /home/nmap/netns.sh
#Each line in theory should be able to be ran on the command line so any possible issues should be tested on the command line to troubleshoot.

#creates interface with proper ip and subnet

#< example:
ip link add link <interface> <interface name> type vlan id <vlan #>
ip addr add <ip address> brd < broadcast ip address> dev <interface name>
ip link set dev <interface name> up   >#

#ip link add link eth0 intf type vlan id 100
#ip link set dev intf up
ip link add link eth0 intf type vlan id 100
ip addr add 192.168.0.0/24 brd 192.168.0.255 dev intf
ip link set dev intf up
ip link add link eth0 intf type vlan id 100
ip addr add 192.168.0.0/24 brd 192.168.0.255 dev intf
ip link set dev intf up
ip link add link eth0 intf type vlan id 100
ip addr add 192.168.0.0/24 brd 192.168.0.255 dev intf
ip link set dev intf up

echo "interfaces <interface name> created" > /home/nmap/log.txt

#creates namespaces
#example: ip netns add <vlan name>
#ip netns add Guest

ip netns add User
ip netns add VOIP
ip netns add IT

echo "namespaces User, VOIP, IT created" >> /home/nmap/log.txt

#connects interface to namespace
#example: ip link set dev <interface name> netns <vlan name> 
#ip link set dev intf netns Guest_wireless
ip link set dev intf netns User
ip link set dev intf netns IT
ip link set dev intf netns VOIP

echo "interfaces attached to proper namespaces" >> /home/nmap/log.txt

#enables dhcp for namespace
#example: sudo ip netns exec <vlan name> dhclient <interface name>
#sudo ip netns exec Guest_wireless dhclient intf
sudo ip netns exec User dhclient intf
sudo ip netns exec IT dhclient intf
sudo ip netns exec VOIP dhclient intf

echo "dhcp enabled for all interfaces in namespaces" >> /home/nmap/log.txt

#runs script for each namespace
#example: sudo ip netns exec <vlan name> bash /home/nmap/csv.sh <vlan name> > /home/nmap/log.txt
#sudo ip netns exec Guest_wireless bash /home/nmap/csv.sh Guest_wireless >> /home/nmap/log.txt
sudo ip netns exec VOIP bash /home/nmap/csv.sh VOIP > /home/nmap/log.txt
sudo ip netns exec User bash /home/nmap/csv.sh User >> /home/nmap/log.txt
sudo ip netns exec IT bash /home/nmap/csv.sh IT >> /home/nmap/log.txt



