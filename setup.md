## Simple Setup Instructions for VPN Auto-Connect Service

### 1. Create the script
```bash
sudo nano /usr/local/bin/vpn-connect.sh
```
### 2. Make it executable
```bash
sudo chmod +x /usr/local/bin/vpn-connect.sh
```
### 3. Create log directory if needed
```bash
sudo mkdir -p /var/log
sudo touch /var/log/vpn-autoconnect.log
sudo chown your-username:your-username /var/log/vpn-autoconnect.log
```
### 4. Test the script manually
```bash
sudo /usr/local/bin/vpn-connect.sh
```
### 5. Create and enable the systemd service
```bash
sudo systemctl daemon-reload
sudo systemctl enable vpn-autoconnect.service
sudo systemctl start vpn-autoconnect.service
```
