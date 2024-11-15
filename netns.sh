#!/bin/bash
#IF NAMESPACES ARE NOT CREATED USE home/nmap/vlan.sh!
#USE NMAP.sh FOR COMPLETE AUTOMATION/ ONLY USE TO RUN SCRIPT MANUALLY
#sudo ip netns exec Guest_wireless bash /home/nmap/csv.sh Guest_wireless > /home/nmap/log.txt
sudo ip netns exec VOIP bash /home/nmap/csv.sh VOIP >> /home/nmap/log.txt
sudo ip netns exec User bash /home/nmap/csv.sh User >> /home/nmap/log.txt
sudo ip netns exec IT bash /home/nmap/csv.sh IT >> /home/nmap/log.txt

#example: sudo ip netns exec <VLAN NAME> bash /home/nmap/csv.sh <VLAN NAME> >> /home/nmap/log.txt
