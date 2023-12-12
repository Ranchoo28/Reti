#!/bin/sh

# Pulizia del buffer
iptables -F

# Rimozione vecchie catene del fw
iptables -X

# Impostazione delle policies di default (con questa blocca tutto)
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Creazione nuove catene
iptables -N greenAll
iptables -N allGreen

# Agganciamo le catene (Metodo 2 e 3 sono più sicuri in caso di attacco Man in the middle)
# Metodo 1
iptables -A FORWARD -s 10.0.6.0/24 -j greenAll
# Metodo 2
iptables -A FORWARD -i eth1 -j greenAll 
# Metodo 3
iptables -A FORWARD -i eth1 -s 10.0.6.0/24 -j greenAll

# Accetta qualsiasi connessione (sono identidici i due metodi)
iptables -A greenAll -j ACCEPT
iptables -A greenAll --state NEW,ESTABLISHED,RELATED -j ACCEPT 

# Ogni due secondi fa vedere lo stato della iptable
watch iptables -nvL