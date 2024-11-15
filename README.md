# Nmap_port_scanner
The purpose of the project is to scan ports from multiple vlans and generate a zip file containing reports from each individual scan.

Basic info

  To tailor to your scenario input your data in ./masterlist.csv

  ports scanned:
  (21,22,23,25,80,135,139,143,443,445,1433,1521,3306,3389,5432,8080) you can change or add desired ports in ./csv.sh

  Vlans can be changed in ./vlan.sh
  
  If vlans are already created run ./ netns.sh
  
  In the event of a system reset or a shutdown all namespaces will dissapear to remediate, a cronjob can be used with ./nmap.sh. It has a check condition to make sure a namespace is created and will run ./netns.sh or ./vlan.sh depending on the outcome.

  The output of a file will look like [namespace]output_network001.txt
  To change the name do so in ./csv.sh aswell with the namespace portion being in vlan.sh.

How to run:

  In order for the script to be ran properly use a ./masterlist.csv list which contains (index location network category vlanname source_ip) as the headers and nmap must be installed. csv.sh can be ran as a 
  standalone script but to run with namespaces you must check they are created beforehand and then run ./netns.sh.
  
  how to check for vlans and intf:
  
  #sudo su
  
  response: should be no response
  
  #ip netns list
  
  response: IT/VOIP/User
  
  #ip netns exec IT bash
  
  response: there should be no response with this command if any does appear most likely a misinput or the vlan name is not correct
  
  #ifconfig
  
  response: should be the interface and the corresponding IP address given through dhcp.
  
  #exit 

  once everything appears to be set up you can either run ./netns.sh if you have the namespaces created, ./vlan.sh if they are not created, or nmap.sh to see what you are missing.
  
  In csv.sh the script will check namespace and create a output file representing each line of masterlist list. 
  

Common errors:

  If you happen to run vlan.sh while the desired vlans are already created than there will be an issue of creating a interface and connecting it to the proper namespace. The way to resolve the issue is to reset the server entirely. 
  To prevent this from future events delete the interface from within the wanted namespace using:
  
  #ip link delete (interface name) #refer to ./vlan.sh if unsure of name
  
  Once it is deleted you can remove the namespace from the system
  
  #ip netns delete (namespace) #refer to ./vlan.sh if unsure of name
  
