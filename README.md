# It is the shell script for access point configuration for Raspberry Pi

There are default parameters in file:

ssid=RaspberryPi_AP

wpa_passphrase=qwertyrpi

static ip_address=10.20.1.1/24

dhcp-range=10.20.1.2,10.20.1.100,255.255.255.0,24h


## Disable NetworkManager if it gets in the way of dnsmasq

sudo systemctl stop NetworkManager

sudo systemctl disable NetworkManager

sudo systemctl mask NetworkManager

sudo reboot
