#!/bin/bash

# Script Name: ssh_network_scan.sh
# Purpose: Scan the local network for SSH servers on common ports (22, 222, 443, 53, 2222).
# Required System Tools: nmap
# Version: 1.3

# Internal Changelog:
# Version 1.3:
# - Added a usage() function.
# - Encapsulated main logic in a main() function.
# - Added SCRIPT_NAME variable.
# Version 1.2:
# - Moved nmap check to a function.
# Version 1.1:
# - Added a function to dynamically determine the network subnet based on the default gateway.
# - Updated the script to use the dynamically determined network subnet for scanning.
# - Added comments for better understanding of the script.
# Version 1.0:
# - Initial release of the script.

SCRIPT_NAME="ssh_network_scan.sh"
VERSION="1.3"

# Function to display usage information
usage() {
    echo "Usage: $SCRIPT_NAME"
    echo "Scans the local network for SSH servers on common ports (22, 222, 443, 53, 2222)."
    echo "Required System Tools: nmap"
}

# Function to check if nmap is installed
check_nmap_installed() {
    if ! command -v nmap &> /dev/null; then
        echo "nmap could not be found. Please install nmap to use this script."
        exit 1
    fi
}

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

# Function to perform the SSH scan
perform_ssh_scan() {
    echo "Scanning network $NETWORK_RANGE for SSH servers on ports $PORTS..."
    nmap -p $PORTS --open $NETWORK_RANGE | grep -E "open\s+ssh"
}

# Main function to orchestrate the script's execution
main() {
    # Parse command-line options
    while getopts ":h" opt; do
        case ${opt} in
            h )
                usage
                exit 0
                ;;
            \? )
                echo "Invalid option: -$OPTARG" 1>&2
                usage
                exit 1
                ;;
        esac
    done
    shift $((OPTIND -1))

    # Check if nmap is installed
    check_nmap_installed

    # Get the network subnet
    NETWORK_RANGE=$(get_network_subnet)

    # Define the ports to scan
    PORTS="22,222,443,53,2222"

    # Perform the scan
    perform_ssh_scan
}

# Call the main function with all command-line arguments
main "$@"

