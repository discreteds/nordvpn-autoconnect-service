#!/bin/bash

# NordVPN Auto-connect Script
# Location: /usr/local/bin/vpn-connect.sh

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Configuration
NORDVPN_TOKEN="YOUR_TOKEN_HERE"  # Replace with your actual NordVPN token
NORDVPN_LOCATION="Melbourne"     # Change to your preferred location
LOG_FILE="/var/log/vpn-autoconnect.log"
MAX_RETRIES=3
RETRY_DELAY=10

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to check current VPN status
check_vpn_status() {
    local status_output
    status_output=$(nordvpn status 2>&1)

    if echo "$status_output" | grep -qi "Status: Connected"; then
        log "VPN already connected - $(echo "$status_output" | grep "Server:" | cut -d: -f2 | xargs)"
        return 0  # Already connected
    elif echo "$status_output" | grep -qi "Status: Disconnected"; then
        log "VPN currently disconnected"
        return 1  # Need to connect
    else
        log "Unknown VPN status: $status_output"
        return 1  # Assume need to connect
    fi
}

# Function to attempt VPN connection
connect_vpn() {
    log "Starting VPN connection process..."

    # Step 1: Login with token (handle already logged in case)
    log "Authenticating with token..."
    login_output=$(nordvpn login --token "$NORDVPN_TOKEN" 2>&1)
    login_exit_code=$?

    if [ $login_exit_code -eq 0 ]; then
        log "Authentication successful"
    elif echo "$login_output" | grep -qi "already logged in\|You are already logged in"; then
        log "Already authenticated - continuing..."
    else
        log "ERROR: Token authentication failed - $login_output"
        return 1
    fi

    # Brief pause between commands
    sleep 2

    # Step 2: Connect to location
    log "Connecting to VPN location: $NORDVPN_LOCATION"
    connect_output=$(nordvpn connect "$NORDVPN_LOCATION" 2>&1)
    connect_exit_code=$?

    if [ $connect_exit_code -eq 0 ]; then
        log "VPN connection established successfully"
        # Show final status
        sleep 2
        nordvpn status | grep -E "Server:|Country:|City:" | while read -r line; do
            log "Status: $line"
        done
        return 0
    else
        log "ERROR: Location connection failed - $connect_output"
        return 1
    fi
}

# Main execution with retry logic
main() {
    log "NordVPN auto-connect service starting..."

    # First, check if we're already connected
    if check_vpn_status; then
        log "VPN already connected - no action needed"
        exit 0
    fi

    # If not connected, attempt connection with retries
    for attempt in $(seq 1 $MAX_RETRIES); do
        log "Connection attempt $attempt of $MAX_RETRIES"

        if connect_vpn; then
            log "VPN connection successful on attempt $attempt"
            exit 0
        else
            log "Attempt $attempt failed"
            if [ $attempt -lt $MAX_RETRIES ]; then
                log "Retrying in $RETRY_DELAY seconds..."
                sleep $RETRY_DELAY
            fi
        fi
    done

    log "ERROR: All connection attempts failed"
    exit 1
}

# Execute main function
main "$@"
