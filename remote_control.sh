function check_and_install {
    # Function to check and install necessary applications
    if ! command -v $1 &> /dev/null; then
        echo "$1 is not installed. Installing..."
        sudo apt-get install -y $1
    else
        echo "$1 is already installed."
    fi
}

# Install necessary tools
check_and_install "sshpass"
check_and_install "tor"
check_and_install "nmap"
check_and_install "whois"
check_and_install "torsocks"

# Start Tor service
echo "Starting Tor service..."
sudo systemctl start tor

# Function to confirm_anonymity
function confirm_anonymity {
    echo "Verifying anonymity..."
    if ! torsocks curl -s https://check.torproject.org | grep -q "Congratulations"; then
        echo "Anonymity verification failed. Not connected via Tor. Exiting..."
        exit 1
    else
        echo "Confirmation of anonymous!."
        spoofed_country=$(torsocks curl -s https://ipinfo.io/country)
        echo "Your current spoofed location: $spoofed_country"
    fi
}

# Verifying network anonymity
confirm_anonymity

# User input for target address
echo "Enter the IP address or domain to scan:"
read target_ip_or_domain

# Prompt user for SSH credentials
echo "Enter your SSH username:"
read SSH_USER
echo "Enter your SSH password:"
read -s SSH_PASSWORD  
echo "Enter the remote server IP:"
read SSH_SERVER

# Connect to remote server and execute commands
function execute_remote_commands {
    echo "Connecting to $SSH_SERVER via Tor..."
    torsocks sshpass -p "$SSH_PASSWORD" ssh -o StrictHostKeyChecking=no "$SSH_USER@$SSH_SERVER" << EOF
        echo "Connected to server. Spoofed server location: \$(torsocks curl -s https://ipinfo.io/country)"
        echo "Server IP: \$(torsocks curl -s https://ipinfo.io/ip)"
        echo "Server Uptime: \$(uptime -p)"
EOF
}

# Execute remote commands
execute_remote_commands

# Local WHOIS information retrieval
echo "Retrieving WHOIS data for $target_ip_or_domain..."
torsocks whois "$target_ip_or_domain" > whois_report_$target_ip_or_domain.txt
echo "WHOIS data saved to whois_report_$target_ip_or_domain.txt."

# Nmap scan with root privileges (using sudo)
if command -v nmap &> /dev/null; then
    echo "Running Nmap scan on $target_ip_or_domain through Tor..."
    sudo torsocks nmap -sS "$target_ip_or_domain" -oN nmap_report_$target_ip_or_domain.txt

    # Check if Nmap output is empty
    if [ ! -s nmap_report_$target_ip_or_domain.txt ]; then
        echo "Error: Nmap scan produced no output. Please verify the target's reachability or potential network restrictions."
    else
        echo "Nmap scan completed. Results saved to nmap_report_$target_ip_or_domain.txt."
    fi
else
    echo "Nmap is not available. Please install it."
    exit 1
fi

# Create audit log for records
function generate_audit_log {
    echo "Generating audit log..."
    echo "Target: $target_ip_or_domain" > audit_log_$target_ip_or_domain.txt
    echo "Scan Date: $(date)" >> audit_log_$target_ip_or_domain.txt
    echo "Collected WHOIS and Nmap data." >> audit_log_$target_ip_or_domain.txt
}

# Generate audit log this is a file
generate_audit_log

# Completion message
echo "Automation task successfully completed. Data and log files have been saved."
