# Function to perform the SSH scan
perform_ssh_scan() {
    echo "Scanning network $NETWORK_RANGE for SSH servers on ports $PORTS..."
    nmap -p $PORTS --open $NETWORK_RANGE | grep -E "open\s+ssh" | awk '{print $1, $2, $3}'
}
