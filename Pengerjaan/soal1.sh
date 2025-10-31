# Membuat topologi seperti perintah soal

# Config Durin
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.242.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.242.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 192.242.3.1
	netmask 255.255.255.0

auto eth4
iface eth4 inet static
	address 192.242.5.1
	netmask 255.255.255.0

up apt update && apt install iptables -y
up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.242.0.0/16
up echo nameserver 192.168.122.1 > /etc/resolv.conf
up echo net.ipv4.ip_forward=1 > /etc/sysctl.conf
up apt install isc-dhcp-relay -y
up apt install systemctl -y

# Config Aldarion

auto eth0
iface eth0 inet static
	address 192.242.5.2
	netmask 255.255.255.0
	gateway 192.242.5.1
	dns-nameserver 192.168.122.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf
up apt update && apt install isc-dhcp-server -y

# Config Khamul

auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

up echo nameserver 192.168.122.1 > /etc/resolv.conf
up apt update
