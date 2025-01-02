# Remote Control Automation Script

A bash script that automates cybersecurity and network research tasks using Tor, Nmap, and WHOIS, ensuring anonymity, retrieving network details, and executing secure remote commands.

---

## Features

- Installs required tools (`sshpass`, `tor`, `torsocks`, `nmap`, `whois`).
- Verifies network anonymity and retrieves spoofed location.
- Executes remote commands securely via Tor.
- Retrieves WHOIS data and performs Nmap scans.
- Logs target details, scan dates, and performed tasks.

---

## Prerequisites

- Linux-based OS (e.g., Ubuntu)
- Root or sudo privileges
- Active internet connection

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/remote-control-script.git
   cd remote-control-script
2. Make the script executable:
  ```bash
chmod +x remote_control.sh

Usage
Run the script:

bash
Copy code
./remote_control.sh
Follow prompts to:

Verify anonymity.
Input target IP/domain.
Provide SSH credentials.
Retrieve WHOIS data and perform Nmap scans.
Generated Files
The script generates the following files:

whois_report_<target>.txt: Contains WHOIS data.
nmap_report_<target>.txt: Contains Nmap scan results.
audit_log_<target>.txt: Logs target details and tasks performed.
Example Output
Anonymity Verification: Displays spoofed location via Tor.
WHOIS Data Retrieval: Saves WHOIS information to a text file.
Nmap Scan Results: Saves scan results to a text file.
Security Notes
All connections are routed through Tor for privacy.
SSH credentials are securely handled during execution.
Root access is required for Nmap scans.
License
This project is licensed under the MIT License.

Contact
Developed by SHEJA MANENE Junior
For questions or feedback, contact: juniormanene@gmail.com