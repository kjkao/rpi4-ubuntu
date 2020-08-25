# rpi4-ubuntu
respberry pi 4 ubuntu setup scripts notes

## Install and Settings

### Boot Disk
[How to install Ubuntu on your Raspberry Pi](https://ubuntu.com/tutorials/how-to-install-ubuntu-on-your-raspberry-pi)

1. Download [Raspberry Pi Imager for Windows](https://downloads.raspberrypi.org/imager/imager.exe)
2. Execute imager.exe; Select OS(Ubuntu 64bit 20.04) and Disk(MicroSD) then Write
3. Insert Micro SD to Respberry Pi, then boot

### System

#### Timezone
- timedatectl set-timezone Asia/Taipei

### Networking

#### Network Bridge

1. vim /etc/netplan/50-cloud-init.conf
2. service networking restart

#### PPPoE

1. apt install pppoeconf
2. pppoeconf

#### Wireless AP

1. apt install hostapd
2. vim /etc/network/interfaces
3. vim /etc/hostapd/hostapd.conf
4. systemctl unmask hostapd
5. systemctl enable hostapd
6. service hostapd start

#### NAT

1. iptables -F -t nat
2. iptables -F
3. iptables --delete-chain
4. iptables --delete-chain -t nat
5. iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE

#### DHCP server

1. apt install isc-dhcp-server
2. vim /etc/dhcp/dhcpd.conf
3. service isc-dhcp-server restart

### LAMP (Linux Apache MySQL PHP)
[Raspberry Pi: Install Apache + MySQL + PHP (LAMP Server)](https://randomnerdtutorials.com/raspberry-pi-apache-mysql-php-lamp-server/)
#### Apache

1. apt install apache2

#### PHP

1. apt install php

#### MySQL

1. apt install mariadb-server php-mysql
2. mysql_secure_installation
3. mysql
    - CREATE USER 'admin'@'localhost' IDENTIFIED BY 'password';
    - GRANT ALL PRIVILEGES ON * . * TO 'admin'@'localhost' WITH GRANT OPTION;
    - FLUSH PRIVILEGES;

#### phpmyadmin

1. apt install phpmyadmin

### Services

#### Monitorix

1. apt install monitorix
2. vim /etc/monitorix/monitorix.conf
3. service monitorix restart
4. vim /etc/apache2/conf-available/monitorix.conf
5. a2enconf monitorix
6. a2enmod cgi
7. systemctl reload apache2

