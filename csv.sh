#!/bin/bash
#checks namespace
namespace=$1

#creates output directory using masterlist
file_path="/home/nmap/config/scannerinputfiles/masterlist.csv"

#takes the second line from the list and creates a variable
second_line=$(awk 'NR==2' "$file_path")

#prints date in YYYY-MM-DD
d=$(date +%Y-%m-%d)

#reads second line from masterlist file
IFS=',' read -r index location network category vlanname source_ip <<< "$second_line"

newdir="/home/nmap/scanneroutputfiles/${location}_Networkscans_${d}"

#creates/checks the newdir
mkdir -p "$newdir/scans/"

echo "directory created"

#takes inputlist from and defines outputdir using the newdir
csv="/home/nmap/config/scannerinputfiles/masterlist.csv"
output_dir="$newdir/scans/"

#skips header/define column heads and reads line by line
tail -n +2 "$csv" | while IFS="," read -r index location network category vlan_name
do
	if [[ $index == "index" ]]; then
		continue
 	fi

	#filepath changes with each line created using the index to title the file
	output_file="$output_dir/${namespace}output_${index}.txt"

	#Helps make the code more readable
	echo "Index, Namespace, Location, Network, Category, Vlan Name" > "$output_file"
	echo "$index, $namespace, $location, $network, $category, $vlan_name" >> "$output_file"
	echo " " >> "$output_file"

	#Nmap command w/ stored desired ports and stores it in variable
	outcome=$(nmap -v --max-retries 3 -T 4 -p 21,22,23,25,80,135,139,143,443,445,1433,1521,3306,3389,5432,8080 "$network" | grep "open")

	#prints nmap command in output file
	echo "$outcome" >> "$output_file"

	echo " " >> "$output_file"

	#creates an array with scanned ports and stores it in variable
	port_num=("21/tcp" "22/tcp" "23/tcp" "25/tcp" "80/tcp" "135/tcp" "139/tcp" "143/tcp" "443/tcp" "445/tcp" "1433/tcp" "1521/tcp" "3306/tcp" "3389/tcp" "5432/tcp" "8080/tcp")

	open_ports=""

	#for loop is created to scanned through the port array and prints any open on a singular line
	for string in "${port_num[@]}"; do

		open=$(cat "$output_file" | grep "$string" )

		if [ -n "$open" ]; then
			open_ports+="$string "
		fi

		done

	echo " " >> "$output_file"
	echo "OPEN PORTS: $open_ports" >> "$output_file"

done < "$csv"

#lets user know when the scan is done
echo " "
echo  "scan complete"

#creates file and stores it in the newly created directory
final_file="$newdir/masteroutput.csv"

touch "$final_file"

chmod +x "$final_file"


echo "Index, Namespace, location, Network, Category, Vlan-Name, Open-Ports" > "$final_file"

for file in "$output_dir"/*; do

	if [ -f "$file" ]; then

	network=$(cat "$file" | grep "network" )

	open=$(cat "$file" | grep "OPEN" )

	echo "output_$network, $open" >> "$final_file"

	fi
done

echo "placed output files in the masteroutput"

#creates zip file

zip_name="$newdir.zip"

zip_dir="$newdir"

zip -r "$zip_name" "$zip_dir"

echo "zip file created or updated"

