# Modul 3
## Praktikum Komunikasi Data & Jaringan Komputer

## Anggota Kelompok 
| Nama    | NRP  |
|---------|------|
| Imam Mahmud Dalil Fauzan  | 5027241100  |
| Zaenal Mustofa | 5027241018  |

## No. 1
```bash
auto eth0
iface eth0 inet dhcp
        up echo nameserver 192.168.122.1 > /etc/resolv.conf

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
	address 192.242.4.1
	netmask 255.255.255.0

auto eth5
iface eth5 inet static
	address 192.242.5.1
	netmask 255.255.255.0

sysctl -w net.ipv4.ip_forward=1
up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.242.1.0/16
up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.242.2.0/16
up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.242.3.0/16
up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.242.4.0/16
up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.242.5.0/16
iptables -A OUTPUT -o eth0 -j DROP
up apt install isc-dhcp-relay -y
up apt install systemctl -y
```

Karena sang Penghubung Antar Dunia tidak boleh terhubung ke internet, ditambahkan `iptables -A OUTPUT -o eth0 -j DROP`.

### Untuk Node **Static**
```bash
auto eth0
iface eth0 inet static
	address <ip>
	netmask 255.255.255.0
	gateway <gateway>

up echo nameserver 192.168.122.1 > /etc/resolv.conf
up apt update
```

### Untuk Node **Dynamic**
```bash
auto eth0
iface eth0 inet dhcp

up echo nameserver 192.168.122.1 > /etc/resolv.conf
up apt update
```

### List IP per-Node
| Node      | IP            | Gateway       |
| --------- | ------------- | ------------- |
| Elendil   | 192.242.1.2   | 192.242.1.1   |
| Isdilur   | 192.242.1.3   | 192.242.1.1   |
| Anarion   | 192.242.1.4   | 192.242.1.1   |
| Miriel    | 192.242.1.5   | 192.242.1.1   |
| Amandil   | Dynamic       | 192.242.1.1   |
| Elros     | 192.242.1.7   | 192.242.1.1   |
| Gilgalad  | Dynamic       | 192.242.2.1   |
| Celebrimor| 192.242.2.3   | 192.242.2.1   |
| Pharazom  | 192.242.2.4   | 192.242.2.1   |
| Galadriel | 192.242.2.5   | 192.242.2.1   |
| Celeborn  | 192.242.2.6   | 192.242.2.1   |
| Oropher   | 192.242.2.7   | 192.242.2.1   |
| Khamul    | 192.242.3.2   | 192.242.3.1   |
| Erendis   | 192.242.3.3   | 192.242.3.1   |
| Amdir     | 192.242.3.4   | 192.242.3.1   |
| Aldarion  | 192.242.4.2   | 192.242.4.1   |
| Palantir  | 192.242.4.3   | 192.242.4.1   |
| Narvi     | 192.242.4.4   | 192.242.4.1   |
| Minastir  | 192.242.5.2   | 192.242.5.1   |

Kemudian test `ping 192.168.122.1` atau `ping google.com` pada tiap node. 

## No. 2
Di Terminal Durin
```bash
nano /etc/default/isc-dhcp-relay
# isi dengan ini
SERVERS="192.242.4.2" # IP Aldarion
INTERFACES="eth1 eth2 eth3"
OPTIONS="-a -i eth4"
```

Di Terminal Aldarion
```bash
nano /etc/dhcp/dhcpd.conf
# isi dengan ini

option domain-name "numenor.lab";
option domain-name-servers 192.242.3.2, 192.242.4.2;
default-lease-time 600;
max-lease-time 7200;
authoritative;

subnet 192.242.1.0 netmask 255.255.255.0 {
    range 192.242.1.6 192.242.1.34;
    range 192.242.1.68 192.242.1.94;
    option routers 192.242.1.1;
    option broadcast-address 192.242.1.255;
    option domain-name-servers 192.242.3.2, 192.242.4.2;
    default-lease-time 1800;
    max-lease-time 3600;
}

subnet 192.242.2.0 netmask 255.255.255.0 {
    range 192.242.2.35 192.242.2.67;
    range 192.242.2.96 192.242.2.121;
    option routers 192.242.2.1;
    option broadcast-address 192.242.2.255;
    option domain-name-servers 192.242.3.2, 192.242.4.2;
    default-lease-time 600;
    max-lease-time 3600;
}

subnet 192.242.4.0 netmask 255.255.255.0 {
    range 192.242.4.10 192.242.4.20;
    option routers 192.242.4.1;
    option broadcast-address 192.242.4.255;
    option domain-name-servers 192.242.3.2, 192.242.4.2;
}

host khamul {
    hardware ethernet 02:42:ab:01:c2:00; # didapatkan dari command "ip link show eth0 | grep ether" di Khamul
    fixed-address 192.242.3.95;
    option routers 192.242.3.1;
    option domain-name-servers 192.242.3.2, 192.242.4.2;
}
```

Kemudian Restart dan cek Status:
```bash
service isc-dhcp-server restart
# cek status nya (Harus running):
service isc-dhcp-server status

# cek apakah berhasil
cat /var/lib/dhcp/dhcpd.leases
```
### No. 4
Di Terminal Erendis
```bash
nano /etc/bind/named.conf.local
# isi dengan ini:
zone "K62.com" {
    type master;
    file "/etc/bind/db.K62";
    allow-transfer { 192.242.3.4; }; # IP Amdir (Slave)
    notify yes; 
};
```

```bash
nano /etc/bind/db.K62
# isi dengan ini:
$TTL    604800
@       IN      SOA     ns1.K62.com. root.K62.com. (
                     2025103101 ; Serial
                      604800     ; Refresh
                       86400     ; Retry
                     2419200     ; Expire
                      604800 )   ; Negative Cache TTL
;
@       IN      NS      ns1.K62.com.
@       IN      NS      ns2.K62.com.

ns1     IN      A       192.242.3.3
ns2     IN      A       192.242.3.4

; Record-record klien:
Palantir IN      A       192.242.4.3
Elros    IN      A       192.242.1.7
Pharazon IN      A       192.242.2.4
Elendil  IN      A       192.242.1.2
Isildur  IN      A       192.242.1.3
Anarion  IN      A       192.242.1.4
Galadriel IN     A       192.242.2.5
Celeborn IN      A       192.242.2.6
Oropher  IN      A       192.242.2.7
```
Cek apakah memiliki serial.
```bash
named-checkzone K62.com /etc/bind/db.K62

# -- Expected output --
# zone K62.com/IN: loaded serial 2025103102
# OK
```
Kemudian Restart Bind9
```bash
/etc/init.d/named restart
```
Konfigurasi Di Terminal Amdir:
```bash
nano /etc/bind/named.conf.local
# isi dengan ini
zone "K62.com" {
    type slave;
    file "/var/lib/bind/db.K62";
    masters { 192.242.3.3; };
};

# Lalu Restart
/etc/init.d/named restart
```

```bash
$TTL    604800
@       IN      SOA     ns1.K62.com. root.K62.com. (
                     2025103102 ; Serial (Wajib diubah saat update)
                      604800     ; Refresh
                       86400     ; Retry
                     2419200     ; Expire
                      604800 )   ; Negative Cache TTL
;
@       IN      NS      ns1.K62.com.
@       IN      NS      ns2.K62.com.

ns1     IN      A       192.242.3.3  ; Erendis
ns2     IN      A       192.242.3.4  ; Amdir

; Record Klien yang Diberi Nama Domain Unik:
Palantir IN      A       192.242.4.3
Elros    IN      A       192.242.1.7
Pharazon IN      A       192.242.2.99
Elendil  IN      A       192.242.1.2
Isildur  IN      A       192.242.1.3
Anarion  IN      A       192.242.1.4
Galadriel IN     A       192.242.2.5
Celeborn IN      A       192.242.2.6
Oropher  IN      A       192.242.2.7
```
Uji coba Di Terminal Amdir
```bash
dig @192.242.3.4 Pharazon.K62.com

# -- Expected Output:
# 1 server found
```
Coba di Terminal Erendis
```bash
rm /etc/bind/db.K62
nano /etc/bind/db.K62
# isi dengan ini:
$TTL    604800
@       IN      SOA     ns1.K62.com. root.K62.com. (
                     2025103102 ; Serial
                      604800     ; Refresh
                       86400     ; Retry
                     2419200     ; Expire
                      604800 )   ; Negative Cache TTL
;
@       IN      NS      ns1.K62.com.
@       IN      NS      ns2.K62.com.

ns1     IN      A       192.242.3.3  ; Erendis
ns2     IN      A       192.242.3.4  ; Amdir

; Record Klien yang Diberi Nama Domain Unik:
Palantir IN      A       192.242.4.3
Elros    IN      A       192.242.1.7
Pharazon IN      A       192.242.2.99
Elendil  IN      A       192.242.1.2
Isildur  IN      A       192.242.1.3
Anarion  IN      A       192.242.1.4
Galadriel IN     A       192.242.2.5
Celeborn IN      A       192.242.2.6
Oropher  IN      A       192.242.2.7
```
Lalu Restart bind9 dengan:
```bash
killall named 2>/dev/null
```
Kembali ke Terminal Amdir
```bash
dig @192.242.3.4 Pharazon.K62.com

# --Expected Output--
# 1 server found
```
### No. 5
Di Terminal Erendis
```bash
nano /etc/bind/named.conf.local
# tambahkan ini di paling bawah

zone "3.242.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.242.3";
    allow-transfer { 192.242.3.4; };
    notify yes;
};
```
Cari forward lookup:
```bash
rm /etc/bind/db.K62
nano /etc/bind/db.K62
# isi dengan ini:

$TTL    604800
@       IN      SOA     ns1.K62.com. root.K62.com. (
                     2025103109 ; Serial
                      604800     ; Refresh
                       86400     ; Retry
                     2419200     ; Expire
                      604800 )   ; Negative Cache TTL
;

; =====================
; NS Records (Name Servers)
; =====================
@       IN      NS      ns1.K62.com.
@       IN      NS      ns2.K62.com.

; =====================
; A Records (Address)
; =====================
ns1     IN      A       192.242.3.3
ns2     IN      A       192.242.3.4
@       IN      A       192.242.3.3

; =====================
; Aliases & TXT
; =====================
www     IN      CNAME   K62.com.
Elros   IN      TXT     "Cincin Sauron"
Pharazon        IN      TXT     "Aliansi Terakhir"
```
Lakukan reverse lookup
```bash
nano /etc/bind/db.192.242
# isi dengan ini:

$TTL    604800
@       IN      SOA     ns1.K62.com. root.K62.com. (
                     2025103107 ; Serial
                      604800     ; Refresh
                       86400     ; Retry
                     2419200     ; Expire
                      604800 )   ; Negative Cache TTL
;
@       IN      NS      ns1.K62.com.
@       IN      NS      ns2.K62.com.

; Reverse PTR records
3       IN      PTR     Erendis.K62.com.
4       IN      PTR     Amdir.K62.com.
```
Restart bind9:
```bash
pkill named # jika tdk bisa, install dulu: apt install procps
named -u bind
```
Di Terminal Amdir
```bash
nano /etc/bind/named.conf.local
# tambahkan di bawahnya:

zone "192.242.in-addr.arpa" {
    type slave;
    masters { 192.242.3.3; };   # IP Erendis (master)
    file "db.192.242";
};
```
Restart bind9:
```bash
pkill named # jika tdk bisa, install dulu: apt install procps
named -u bind
```
Pengujian, dengan 5 command:
```bash
dig @192.242.3.3 K62.com
dig @192.242.3.4 K62.com
dig -x 192.242.3.3 @192.242.3.3
dig -x 192.242.3.4 @192.242.3.3
dig TXT Elros.K62.com @192.242.3.3
dig TXT Pharazon.K62.com @192.242.3.3
```
### Nomor 6
Di terminal aldarion
```bash
#!/bin/bash
# Node: Aldarion (DHCP Server)
# Tujuan: Mengatur Lease Time, Rentang IP, dan Fixed Address sesuai Soal 2 & 6.

# --- Variabel Konfigurasi ---
ALDARION_IP="192.242.4.2"
DURIN_GATEWAY="192.242.4.1"
KHAMUL_MAC="02:42:9b:4a:8f:00" # MAC Khamul yang sudah diverifikasi
DNS_SERVERS="192.242.5.2, 192.242.3.3" # Minastir (Fwd), Erendis (Master)

# --- 1. KONFIGURASI JARINGAN & INSTALASI (Untuk memastikan IP statik terpasang) ---
echo "1. Menetapkan IP Statik dan memastikan instalasi DHCP Server..."
ip address add ${ALDARION_IP}/24 dev eth0
ip route add default via ${DURIN_GATEWAY}

# Note: Anda perlu memastikan isc-dhcp-server terinstal sebelum langkah ini.

# --- 2. KONFIGURASI DEFAULT INTERFACE ---
echo "2. Mengatur interface default DHCP..."
echo 'INTERFACESv4="eth0"' > /etc/default/isc-dhcp-server

# --- 3. KONFIGURASI dhcpd.conf (Integrasi Soal 2 & 6) ---
echo "3. Menulis ulang /etc/dhcp/dhcpd.conf dengan pengaturan lease time..."
cat << EOF > /etc/dhcp/dhcpd.conf
ddns-update-style none;
default-lease-time 300;
max-lease-time 3600;        # Batas Waktu Maksimal (1 jam)

authoritative;
log-facility local7;

# Subnet 1: Keluarga Manusia (Lease 30 menit)
subnet 192.242.1.0 netmask 255.255.255.0 {
    range 192.242.1.6 192.242.1.34;
    range 192.242.1.68 192.242.1.94;
    option routers 192.242.1.1;
    option domain-name-servers ${DNS_SERVERS}; 
    default-lease-time 1800;       # Setengah jam (30 menit)
    max-lease-time 3600;
}

# Subnet 2: Keluarga Peri (Lease 10 menit)
subnet 192.242.2.0 netmask 255.255.255.0 {
    range 192.242.2.35 192.242.2.67;
    range 192.242.2.96 192.242.2.121;
    option routers 192.242.2.1;
    option domain-name-servers ${DNS_SERVERS};
    default-lease-time 600;          # Seperenam jam (10 menit)
    max-lease-time 3600;
}

# Fixed Address: Khamul
host khamul {
    hardware ethernet ${KHAMUL_MAC};
    fixed-address 192.242.3.95;
    option routers 192.242.3.1;
    max-lease-time 3600;
}

# Subnet 3, 4, 5 (Static)
subnet 192.242.3.0 netmask 255.255.255.0 { option routers 192.242.3.1; }
subnet 192.242.4.0 netmask 255.255.255.0 { option routers 192.242.4.1; }
subnet 192.242.5.0 netmask 255.255.255.0 { option routers 192.242.5.1; }
EOF

# --- 4. RESTART LAYANAN ---
echo "4. Membersihkan PID dan me-restart DHCP Server..."
rm -f /var/run/dhcpd.pid
service isc-dhcp-server restart
```
setelah menjalankan, verifikasi.  
```bash
cat /var/lib/dhcp/dhclient.leases
```
