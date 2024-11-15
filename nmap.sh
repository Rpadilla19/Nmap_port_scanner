#!/bin/bash
#the purpose of this script is to be used by cron to create the vlans in the event of a system reset

target_vlan="IT" #you can switch all cases of "IT" with your wanted namespace or vlan 

current_vlans=$(ip netns list | grep "IT" | grep -oP '\bIT\b' )

d=$(date +%Y-%m-%d)

#echo "$current_vlans"

if [ "$current_vlans" = "$target_vlan" ]; then
        echo "running netns.sh"
	bash "/home/nmap/netns.sh"
else
        echo "running Vlan.sh"
	bash "/home/nmap/vlan.sh"
fi


sendemail -f nmapscanner@raspberrypi.com -t <email address> -cc <email address>  -u "ESCnmap ${d}" -m "Scans are ready for pickup in /home/nmap/scanneroutputfi/Networkscans_${d}.zip" -s <smtp server>
