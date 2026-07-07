# #!/bin/bash

# # Check if nmap is installed
# if ! command -v nmap &> /dev/null; then
#     echo "nmap is not installed. Please install it for this script to work."
#     exit 1
# fi

# # Get the ARP table
# arp_output=$(arp -a)

# # Process each line of the ARP output
# echo "$arp_output" | while read -r line; do
#     ip=$(echo $line | awk '{print $2}' | tr -d '()')
#     mac=$(echo $line | awk '{print $4}')

#     # Skip broadcast addresses
#     if [[ $mac == "ff:ff:ff:ff:ff:ff" ]]; then
#         continue
#     fi

#     # Use nmap for device information
#     nmap_output=$(sudo nmap -sn $ip)

#     name=$(echo "$nmap_output" | awk '/Nmap scan report for/ {$1=$2=$3=$4=""; print $0}' | sed 's/^[ \t]*//')
#     manufacturer=$(echo "$nmap_output" | awk -F '(' '/MAC Address:/ {print $2}' | sed 's/)//')

#     if [ -z "$name" ]; then
#         name="Unknown"
#     fi

#     if [ -z "$manufacturer" ]; then
#         manufacturer="Unknown"
#     fi

#     echo "IP: $ip, MAC: $mac, Name: $name, Manufacturer: $manufacturer"
# done

#!/bin/bash

# Check if nmap is installed
if ! command -v nmap &> /dev/null; then
    echo "nmap is not installed. Please install it for this script to work."
    exit 1
fi

# Get the ARP table
arp_output=$(arp -a)

# Total number of devices for progress tracking
total_devices=$(echo "$arp_output" | wc -l)
current_device=0

echo "Scanning network devices. This may take a while..."

# Process each line of the ARP output
echo "$arp_output" | while read -r line; do
    ip=$(echo $line | awk '{print $2}' | tr -d '()')
    mac=$(echo $line | awk '{print $4}')

    # Skip broadcast addresses
    if [[ $mac == "ff:ff:ff:ff:ff:ff" ]]; then
        continue
    fi

    # Update progress
    current_device=$((current_device + 1))
    echo -ne "Progress: $current_device/$total_devices devices scanned\r"

    # Use nmap for detailed device information including OS detection
    nmap_output=$(sudo nmap -O -sV --osscan-guess $ip)

    name=$(echo "$nmap_output" | awk '/Nmap scan report for/ {$1=$2=$3=$4=""; print $0}' | sed 's/^[ \t]*//')
    manufacturer=$(echo "$nmap_output" | awk -F '(' '/MAC Address:/ {print $2}' | sed 's/)//')
    os_info=$(echo "$nmap_output" | awk '/OS details:/ {$1=$2=""; print $0}' | sed 's/^[ \t]*//')

    if [ -z "$name" ]; then
        name="Unknown"
    fi

    if [ -z "$manufacturer" ]; then
        manufacturer="Unknown"
    fi

    if [ -z "$os_info" ]; then
        os_info="OS detection failed"
    fi

    echo -e "\nIP: $ip"
    echo "MAC: $mac"
    echo "Name: $name"
    echo "Manufacturer: $manufacturer"
    echo "OS Info: $os_info"
    echo "-----------------------------------"
done

echo -e "\nScan completed."
