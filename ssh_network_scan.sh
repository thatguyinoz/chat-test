#!/bin/bash

# Script Name: ssh_network_scan.sh
# Purpose: Scan the local network for SSH servers on common ports (22, 222, 443, 53).
# Required System Tools: nmap
# Version: 1.0

# Check if nmap is installed
if ! command -v nmap &> /dev/null
then
    echo "nmap could not be found. Please install nmap to use this script."
    exit 1
fi

# Define the local network range
# You can modify this to match your network range
NETWORK_RANGE="192.168.0.0/24"

# Define the ports to scan
PORTS="22,222,443,53,2222"

# Perform the scan
perform_ssh_scan
