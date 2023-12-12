# Crea interfaccia di rete tap0
tunctl -g netdev -t tap0

# Configura l'interfaccia di rete tap0
ifconfig tap0 10.0.7.13
ifconfig tap0 netmask 255.255.255.252
ifconfig tap0 broadcast 10.0.3.15
ifconfig tap0 up

# Crea le regole di firewalling
# Attenzione: cambiare *wlan0* con il nome della propria scheda di rete attualmente connessa alla rete internet
iptables -t nat -F
iptables -t nat -X
iptables -F
iptables -X
iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
iptables -A FORWARD -i tap0 -j ACCEPT

#Abilita il forwarding su host locale
sysctl -w net.ipv4.ip_forward=1

#Aggiunge le rotte alle subnets
route add -net 10.0.0.0/21 gw 10.0.7.14 dev tap0