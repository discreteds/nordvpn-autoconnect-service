# 1. Create the script
sudo nano /usr/local/bin/vpn-connect.sh

# 2. Make it executable
sudo chmod +x /usr/local/bin/vpn-connect.sh

# 3. Create log directory if needed
sudo mkdir -p /var/log
sudo touch /var/log/vpn-autoconnect.log
sudo chown your-username:your-username /var/log/vpn-autoconnect.log

# 4. Test the script manually
sudo /usr/local/bin/vpn-connect.sh

# 5. Create and enable the systemd service
sudo systemctl daemon-reload
sudo systemctl enable vpn-autoconnect.service
sudo systemctl start vpn-autoconnect.service
