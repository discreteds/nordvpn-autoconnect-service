# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a NordVPN auto-connect service that automatically establishes VPN connections on system boot. The service is designed for Linux systems using systemd.

## Architecture

The project consists of three main components:

1. **Main Script** (`usr/local/bin/vpn-connect.sh`): Bash script that handles VPN authentication and connection logic with retry mechanisms
2. **Systemd Service** (`etc/systemd/system/vpn-autoconnect.service`): Service unit file that runs the script at boot
3. **Setup Documentation** (`setup.md`): Installation and configuration instructions

### Key Script Components

- **Configuration section**: NordVPN token, location, and service parameters
- **Status checking**: Verifies current VPN connection state  
- **Authentication**: Handles NordVPN token login with error handling
- **Connection logic**: Establishes VPN connection to specified location
- **Retry mechanism**: Attempts connection up to 3 times with delays
- **Logging**: All operations logged to `/var/log/vpn-autoconnect.log`

## Installation Process

The service follows the standard Linux service installation pattern:

1. Copy script to `/usr/local/bin/vpn-connect.sh` and make executable
2. Create log file with proper permissions
3. Install systemd service file to `/etc/systemd/system/`
4. Enable and start the service with systemctl

## Configuration Requirements

Before deployment:
- Replace `YOUR_TOKEN_HERE` with actual NordVPN token in `vpn-connect.sh`
- Update `your-username` in the systemd service file
- Modify `NORDVPN_LOCATION` if different location is preferred

## Testing and Debugging

- Test script manually: `sudo /usr/local/bin/vpn-connect.sh`
- Check service status: `sudo systemctl status vpn-autoconnect.service`
- View logs: `tail -f /var/log/vpn-autoconnect.log` or `journalctl -u vpn-autoconnect.service`