#!/bin/bash

# System update
sudo apt update && sudo apt upgrade -y

# Installation of the necessary packages
sudo apt install -y dhcpcd hostapd dnsmasq

# hostapd and dnsmasq stop before setting up
sudo systemctl stop hostapd
sudo systemctl stop dnsmasq

# Setting up static IP for wlan0
sudo bash -c 'cat >> /etc/dhcpcd.conf << EOF
interface wlan0
    static ip_address=10.20.1.1/24
    nohook wpa_supplicant
EOF'

# Setting up hostapd
sudo bash -c 'cat > /etc/hostapd/hostapd.conf << EOF
interface=wlan0
ssid=RaspberryPi_AP
hw_mode=g
channel=7
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=qwertyrpi
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF'

# Setting up hostapd's config file
sudo sed -i "s|#DAEMON_CONF=\"\"|DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"|" /etc/default/hostapd

# Backup and setting up dnsmasq
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
sudo bash -c 'cat > /etc/dnsmasq.conf << EOF
interface=wlan0
dhcp-range=10.20.1.2,10.20.1.100,255.255.255.0,24h
EOF'

# Unlock and enable of hostapd и dnsmasq
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl enable dnsmasq

# Restart of services
sudo systemctl restart dhcpcd
sudo systemctl restart hostapd
sudo systemctl restart dnsmasq

echo "Setting up of your Raspberry Pi is complete. Please reboot."
