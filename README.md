# NordVPN Auto-Connect Service

A Linux systemd service that automatically connects to NordVPN on system boot with retry logic and comprehensive logging.

## Features

- ✅ Automatic VPN connection on system startup
- ✅ Retry mechanism with configurable attempts and delays
- ✅ Comprehensive logging to `/var/log/vpn-autoconnect.log`
- ✅ Status checking to avoid unnecessary reconnections
- ✅ Error handling and recovery
- ✅ Systemd integration for reliable service management

## Prerequisites

### 1. NordVPN CLI Installation

First, install the official NordVPN CLI client:

```bash
# Download and install NordVPN
sh <(wget -qO - https://downloads.nordcdn.com/apps/linux/install.sh)

# Add your user to the nordvpn group
sudo usermod -aG nordvpn $USER

# Reboot system for group changes to take effect
sudo reboot
```

**System Requirements:**
- Debian 10 or newer / Ubuntu 18.04 or newer / Linux Mint 19 or newer
- Fedora 32 or newer
- Any other Linux distribution with systemd support

### 2. NordVPN Account Setup

You'll need a NordVPN subscription and access token:

1. Log into your [NordVPN account](https://my.nordaccount.com/)
2. Navigate to Services → NordVPN → Manual setup
3. Generate an access token
4. Save the token securely - you'll need it for configuration

## Installation

### Step 1: Clone or Download

```bash
git clone <repository-url>
cd vpn-autoconnect-service
```

### Step 2: Configure the Script

Edit the configuration section in `usr/local/bin/vpn-connect.sh`:

```bash
# Edit the script to add your token and preferred location
nano usr/local/bin/vpn-connect.sh
```

**Required changes:**
- Replace `YOUR_TOKEN_HERE` with your actual NordVPN access token
- Update `NORDVPN_LOCATION` to your preferred connection location (e.g., "Melbourne", "United_States", "United_Kingdom")

**Optional configuration:**
- `MAX_RETRIES`: Number of connection attempts (default: 3)
- `RETRY_DELAY`: Seconds between retry attempts (default: 10)
- `LOG_FILE`: Location of log file (default: `/var/log/vpn-autoconnect.log`)

### Step 3: Install the Script

```bash
# Copy script to system location
sudo cp usr/local/bin/vpn-connect.sh /usr/local/bin/vpn-connect.sh

# Make executable
sudo chmod +x /usr/local/bin/vpn-connect.sh

# Create log directory and file
sudo mkdir -p /var/log
sudo touch /var/log/vpn-autoconnect.log
sudo chown $USER:$USER /var/log/vpn-autoconnect.log
```

### Step 4: Configure Systemd Service

```bash
# Edit the service file to set your username
nano etc/systemd/system/vpn-autoconnect.service
```

Replace `your-username` with your actual Linux username.

```bash
# Install systemd service
sudo cp etc/systemd/system/vpn-autoconnect.service /etc/systemd/system/

# Reload systemd and enable service
sudo systemctl daemon-reload
sudo systemctl enable vpn-autoconnect.service
```

### Step 5: Test and Start

```bash
# Test the script manually first
sudo /usr/local/bin/vpn-connect.sh

# If successful, start the service
sudo systemctl start vpn-autoconnect.service

# Check service status
sudo systemctl status vpn-autoconnect.service
```

## Usage

### Service Management

```bash
# Start the service
sudo systemctl start vpn-autoconnect.service

# Stop the service
sudo systemctl stop vpn-autoconnect.service

# Restart the service
sudo systemctl restart vpn-autoconnect.service

# Check service status
sudo systemctl status vpn-autoconnect.service

# Enable auto-start on boot
sudo systemctl enable vpn-autoconnect.service

# Disable auto-start on boot
sudo systemctl disable vpn-autoconnect.service
```

### Monitoring and Logs

```bash
# View service logs in real-time
tail -f /var/log/vpn-autoconnect.log

# View systemd journal logs
journalctl -u vpn-autoconnect.service -f

# Check current VPN status
nordvpn status

# Check available locations
nordvpn countries
nordvpn cities <country_name>
```

## Troubleshooting

### Common Issues

**1. "Permission denied" errors**
```bash
# Ensure user is in nordvpn group and reboot
sudo usermod -aG nordvpn $USER
sudo reboot
```

**2. "Token authentication failed"**
- Verify your access token is correct and active
- Generate a new token from your NordVPN account if needed
- Check for extra spaces or characters in the token

**3. "Location connection failed"**
```bash
# Check available locations
nordvpn countries
nordvpn cities <country_name>

# Try connecting manually to test location
nordvpn connect <location_name>
```

**4. Service fails to start**
```bash
# Check service logs
journalctl -u vpn-autoconnect.service -n 20

# Verify script permissions
ls -la /usr/local/bin/vpn-connect.sh

# Test script manually
sudo /usr/local/bin/vpn-connect.sh
```

**5. VPN connects but disconnects shortly after**
- Check your NordVPN subscription status
- Verify network connectivity is stable
- Review logs for specific error messages

### Log Analysis

The service logs all operations to `/var/log/vpn-autoconnect.log`. Common log patterns:

- `VPN already connected` - Service detected existing connection
- `Authentication successful` - Token login worked
- `VPN connection established successfully` - Connection completed
- `ERROR: Token authentication failed` - Check your token
- `ERROR: Location connection failed` - Check location name
- `All connection attempts failed` - Check network/credentials

## Configuration Options

### Available NordVPN Locations

```bash
# List all countries
nordvpn countries

# List cities in a specific country
nordvpn cities United_States
nordvpn cities Australia
nordvpn cities United_Kingdom
```

### Script Configuration Variables

Edit `/usr/local/bin/vpn-connect.sh` to modify:

| Variable | Description | Default |
|----------|-------------|---------|
| `NORDVPN_TOKEN` | Your NordVPN access token | `YOUR_TOKEN_HERE` |
| `NORDVPN_LOCATION` | Preferred connection location | `Melbourne` |
| `LOG_FILE` | Path to log file | `/var/log/vpn-autoconnect.log` |
| `MAX_RETRIES` | Number of connection attempts | `3` |
| `RETRY_DELAY` | Seconds between retry attempts | `10` |

## Security Notes

- Keep your NordVPN access token secure and never share it
- The script logs connection attempts but not sensitive information
- Consider restricting access to the log file if needed:
  ```bash
  sudo chmod 640 /var/log/vpn-autoconnect.log
  ```

## Uninstallation

```bash
# Stop and disable service
sudo systemctl stop vpn-autoconnect.service
sudo systemctl disable vpn-autoconnect.service

# Remove service files
sudo rm /etc/systemd/system/vpn-autoconnect.service
sudo rm /usr/local/bin/vpn-connect.sh

# Remove log file (optional)
sudo rm /var/log/vpn-autoconnect.log

# Reload systemd
sudo systemctl daemon-reload
```
