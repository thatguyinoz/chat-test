#!/bin/bash

# Script Name: ssh_network_scan.sh
# Purpose: Scan the local network for SSH servers on common ports (22, 222, 443, 53, 2222).
# Required System Tools: nmap
# Version: 1.2

# Internal Changelog:
# Version 1.2:
# - moved nmap check to a function.
# - Removed duplicate function definition for `check_nmap_installed`.
# Version 1.1:
# - Added a function to dynamically determine the network subnet based on the default gateway.
# - Updated the script to use the dynamically determined network subnet for scanning.
# - Added comments for better understanding of the script.
# Version 1.0:
# - Initial release of the script.

# Function to check if nmap is installed
check_nmap_installed() {
    if ! command -v nmap &> /dev/null; then
        echo "nmap could not be found. Please install nmap to use this script."
        exit 1
    fi
}

# Check if nmap is installed
check_nmap_installed

# Function to get the default gateway and determine the network subnet
get_network_subnet() {
    # Get the default gateway
    DEFAULT_GATEWAY=$(ip route | grep default | awk '{print $3}')
    
    # Determine the network subnet based on the default gateway
    if [[ -n $DEFAULT_GATEWAY ]]; then
        # Extract the network part of the IP address
        NETWORK_SUBNET=$(echo $DEFAULT_GATEWAY | awk -F. '{print $1"."$2"."$3".0/24"}')
        echo $NETWORK_SUBNET
    else
        echo "Could not determine the default gateway."
        exit 1
    fi
}

# Get the network subnet
NETWORK_RANGE=$(get_network_subnet)

# Define the ports to scan
PORTS="22,222,443,53,2222"

# Function to perform the SSH scan
perform_ssh_scan() {
    echo "Scanning network $NETWORK_RANGE for SSH servers on ports $PORTS..."
    nmap -p $PORTS --open $NETWORK_RANGE | grep -E "open\s+ssh"
}

# Perform the scan
perform_ssh_scan

