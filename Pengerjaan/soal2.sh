# di Terminal DURIN, Config relaynya

nano /etc/default/isc-dhcp-relay
# ubah jadi seperti ini
# IP Aldarion (DHCP Server)
SERVERS="192.242.5.2"
# Interface yang terhubung ke client
INTERFACES="eth1 eth2 eth3"

# simpan itu, lalu restart
systemctl restart isc-dhcp-relay
# atau
service isc-dhcp-relay

# di Terminal ALDARION
nano /etc/default/isc-dhcp-server
#ubah jadi ini:
INTERFACESv4="eth0"

rm /etc/dhcp/dhcpd.conf
nano /etc/dhcp/dhcpd.conf 
# isi dengan ini

# Opsi global
ddns-update-style none;
authoritative; # Server ini adalah satu-satunya DHCP di jaringan

# --- Subnet 1: Keluarga Manusia (dari Durin eth1) ---
subnet 192.242.1.0 netmask 255.255.255.0 {
    option routers 192.242.1.1; # Gateway (Durin eth1)
    
    # Range sesuai soal 
    range 192.242.1.6 192.242.1.34;
    range 192.242.1.68 192.242.1.94;
}

# --- Subnet 2: Keluarga Peri (dari Durin eth2) ---
subnet 192.242.2.0 netmask 255.255.255.0 {
    option routers 192.242.2.1; # Gateway (Durin eth2)

    # Range sesuai soal 
    range 192.242.2.35 192.242.2.67;
    range 192.242.2.96 192.242.2.121;
}

# --- Subnet 3: Khamul (dari Durin eth3) ---
subnet 192.242.3.0 netmask 255.255.255.0 {
    option routers 192.242.3.1; # Gateway (Durin eth3)
    # Tidak ada range dinamis di subnet ini
}

# --- Alokasi Tetap untuk Khamul  ---
# Kita perlu MAC Address dari Khamul
host Khamul {
    hardware ethernet 00:00:00:00:00:00; # <-- GANTI INI
    fixed-address 192.242.3.95;
}


# di Terminal KHAMUL
ip a
# Cari eth0 dan lihat alamat link/ether (Contoh: 0c:4d:7d:01:23:45).
# Salin MAC address tersebut.

# ke terminal ALDARION lagi
nano /etc/default/isc-dhcp-server
# di bagian bawah, paste MAC address itu, menggantikan 00:00:00:00:00:00 di dalam host Khamul { ... }.

# lalu restart server dhcp
systemctl restart isc-dhcp-server