/sbin/iptables -F
/sbin/iptables -A INPUT -p tcp --dport 22 -s 192.168.1.0/24 -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport 22 -j DROP
