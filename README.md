# SSH Network Scan Script

## Purpose
This script scans the local network for SSH servers on common ports (22, 222, 443, 53, 2222).

## Required System Tools
- `nmap`

## Version
1.1

## Internal Changelog
- **Version 1.1**:
  - Added a function to dynamically determine the network subnet based on the default gateway.
  - Updated the script to use the dynamically determined network subnet for scanning.
  - Added comments for better understanding of the script.
- **Version 1.0**:
  - Initial release of the script.

## Usage
1. Ensure `nmap` is installed on your system.
2. Run the script:
   ```bash
   ./ssh_network_scan.sh
   ```

## Example Output
```
Scanning network 192.168.1.0/24 for SSH servers on ports 22,222,443,53,2222...
Nmap scan report for 192.168.1.10
Host is up (0.0002s latency).
PORT   STATE SERVICE
22/tcp open  ssh
```

## License
This script is released under the MIT License.
