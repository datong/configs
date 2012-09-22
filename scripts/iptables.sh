#!/bin/sh
###################################KUST0M IPTABLES FOR DEBIAN/UBUNTU,+ADVANCED proc/sys/* addins !
# Loopback interface
LO_IF="lo"

# Network card connected to Internet
NET_IF="eth1"

# DMZ interface, if any
DMZ_IF=""

# iptables executables
IPTABLES="/sbin/iptables"
IP6TABLES="/sbin/ip6tables"

# Set this to 1 if you want enable IPv4 port forwarding
IPV4_FORWARDING=""

# 99% you don't need IPv6 at all, so, disable it
DISALLOW_IPV6="1"

# Ports that you want to be explicitly disabled
PORTS_TO_DISABLE="113"

# TCP traffic is completely disabled, you can cherry-pick ports
# you want to allow traffic in and out
TCP_PORTS_INCOMING_ALLOW="21 631 6667 7000 2222 80 443"
TCP_PORTS_OUTGOING_ALLOW="21 631 6667 7000 2222 80 443"

# UDP traffic is completely disabled, you can cherry-pick ports
# you want to allow traffic in and out
UDP_PORTS_INCOMING_ALLOW="53"
UDP_PORTS_OUTGOING_ALLOW="53"

# Block IPs trying to make too many connections on given ports
# If you have Entropy connecting, do not set this!
# Of course timed ports here have to be set in the variables above too.
# It will work for both tcp and udp.
TIMED_PORTS=""

# Number of times ip is allowed to bug port
TIMED_PORTS_HIT_COUNT="5"

# Number of seconds the ban will last and also the amount of time
# within user can at most try to connect TIMED_PORTS_HIT_COUNT times
TIMED_PORTS_TIMER_SECS="300"

# PORT SETTINGS ABOVE
# Allow sane ICMP packets (ping, traceroute) (DoS)
# set this to 1 if you want it, or leave unset
ALLOW_SANE_ICMP="1"

# Completely disable ICMP instead? (DoS)
# set this to 1 if you want it, or leave unset
FUCK_ICMP_I_DONT_NEED_IT=""

# Number of allowed ICMP packets per second (this is a further filter) (DoS)
ICMP_PACKETS_PER_SECOND="1"

# Also rate limit RST Packets, to mitigate SMURF attacks (DoS)
RST_PACKETS_PER_SECOND="2"

# Kill identd?
# set this to 1 if you want it, or leave unset
KILL_IDENTD="1"

# Kill port scanning? If you set this to 1, please also set
# a port to monitor against port scans (I suggest 139, trust me, it's fine for ssh too)
# IP will be blocked for PORT_SCANNING_SECONDS (1 day)
KILL_PORT_SCANNING="1"
PORT_SCANNING_PORT="139"
PORT_SCANNING_SECONDS="86400"

# Enable IP spoofing protection? (DoS)
IP_SPOOFING_PROTECTION="1"

# Enable kernel SYN flood protection? (DoS)
SYN_FLOOD_PROTECTION="1"

# Max SYN backlog on TCP
TCP_MAX_SYN_BACKLOG="1024"

# Set the tcp-time-wait buckets pool size
TCP_MAX_TW_BUCKETS="1440000"

# Ignore ICMP broadcasts anyway? (DoS)
IGNORE_ICMP_BROADCASTS="1"

# Log packets with impossible addresses?
LOG_MARTIAN_IPS="1"

# Disallow ICMP redirects? (DoS)
DISALLOW_ICMP_REDIRECTS="1"

# Disallow source routed packets? (DoS)
DISALLOW_SOURCE_ROUTED_PACKETS="1"

# Disallow multicast routing? (DoS)
#DISALLOW_MULTICAST_ROUTING="1"

# Disallow proxy_arp?
DISALLOW_PROXY_ARP="1"

# Disallow bootp relay?
DISALLOW_BOOTP_RELAY="1"

# Enable secure redirects (only accept ICMP redirects for
# gateways. Helps against MITM attacks.
ENABLE_SECURE_ICMP_REDIRECTS="1"

# Decrease the time default value for tcp_fin_timeout connection
TCP_FIN_TIMEOUT="15"

# Decrease the time default value for tcp_keepalive_time connection
TCP_KEEPALIVE_TIME="1800"

# Handle TCP window scaling, disable by default
DISALLOW_TCP_WINDOW_SCALING=""

# Turn off TCP timestamp feature
TCP_TIMESTAMP="0"

# Drop traffic from IANA-reserved IPs
DROP_IANA_IPS="1"

# Completely ignore Microsuck ports
IGNORE_MICROSOFT_SHIT="1"

# General default logging rate limit parameters
RLIMIT="-m limit --limit 3/s --limit-burst 8"

# General default logging parameters
LOG="LOG --log-level debug --log-tcp-sequence --log-tcp-options"
LOG="${LOG} --log-ip-options"

# set this to a valid path containing your custom iptables rules
# it will be sourced
CUSTOM_RULES_FILE_PRE=""
CUSTOM_RULES_FILE_POST=""

#### stay away from here // advanced
if [ -z "${NET_IF}" ]; then
echo "set NET_IF"
exit 1
fi
if [ ! -x ""${IPTABLES}"" ]; then
echo "set IPTABLES"
exit 1
fi
if [ ! -x ""${IP6TABLES}"" ]; then
echo "set IP6TABLES"
exit 1
fi

# drop everything by default
"${IPTABLES}" -P INPUT DROP
"${IPTABLES}" -P FORWARD DROP
"${IPTABLES}" -P OUTPUT DROP

# Set the nat/mangle/raw tables' chains to ACCEPT
"${IPTABLES}" -t nat -P PREROUTING ACCEPT
"${IPTABLES}" -t nat -P OUTPUT ACCEPT
"${IPTABLES}" -t nat -P POSTROUTING ACCEPT

"${IPTABLES}" -t mangle -P PREROUTING ACCEPT
"${IPTABLES}" -t mangle -P INPUT ACCEPT
"${IPTABLES}" -t mangle -P FORWARD ACCEPT
"${IPTABLES}" -t mangle -P OUTPUT ACCEPT
"${IPTABLES}" -t mangle -P POSTROUTING ACCEPT

# clear previous rules
"${IPTABLES}" -F
"${IPTABLES}" -t nat -F
"${IPTABLES}" -t mangle -F
"${IPTABLES}" -X
"${IPTABLES}" -t nat -X
"${IPTABLES}" -t mangle -X
"${IPTABLES}" -Z
"${IPTABLES}" -t nat -Z
"${IPTABLES}" -t mangle -Z

if [ -n "${DISALLOW_IPV6}" ]; then
"${IP6TABLES}" -P INPUT DROP
"${IP6TABLES}" -P FORWARD DROP
"${IP6TABLES}" -P OUTPUT DROP

# The mangle table can pass everything
"${IP6TABLES}" -t mangle -P PREROUTING ACCEPT
"${IP6TABLES}" -t mangle -P INPUT ACCEPT
"${IP6TABLES}" -t mangle -P FORWARD ACCEPT
"${IP6TABLES}" -t mangle -P OUTPUT ACCEPT
"${IP6TABLES}" -t mangle -P POSTROUTING ACCEPT

# Delete all rules
"${IP6TABLES}" -F
"${IP6TABLES}" -t mangle -F

# Delete all chains
"${IP6TABLES}" -X
"${IP6TABLES}" -t mangle -X

# Zero all packets and counters
"${IP6TABLES}" -Z
"${IP6TABLES}" -t mangle -Z
fi

if [ -f "${CUSTOM_RULES_FILE_PRE}" ]; then
source "${CUSTOM_RULES_FILE_PRE}"
fi

# setup ipv4 forwarding
ip_forward="0"
if [ -n "${IPV4_FORWARDING}" ]; then
ip_forward="1"
fi
echo "Setting ip_forward to ${ip_forward}"
echo ${ip_forward} > /proc/sys/net/ipv4/ip_forward

# ip spoofing protection
ip_spoof="0"
if [ -n "${IP_SPOOFING_PROTECTION}" ]; then
ip_spoof="1"
fi
for i in /proc/sys/net/ipv4/conf/*/rp_filter; do
echo "Setting ip spoofing protection on ${i} to ${ip_spoof}"
echo ${ip_spoof} > ${i}
done

# syn flood attacks
syn_flood="0"
if [ -n "${SYN_FLOOD_PROTECTION}" ]; then
syn_flood="1"
fi
echo "Setting SYN flood protection on to ${syn_flood}"
echo ${syn_flood} > /proc/sys/net/ipv4/tcp_syncookies
echo "Setting tcp_max_syn_backlog to ${TCP_MAX_SYN_BACKLOG}"
echo "${TCP_MAX_SYN_BACKLOG}" > /proc/sys/net/ipv4/tcp_max_syn_backlog
echo "Setting tcp_max_tw_buckets to ${TCP_MAX_TW_BUCKETS}"
echo "${TCP_MAX_TW_BUCKETS}" > /proc/sys/net/ipv4/tcp_max_tw_buckets

log_from_mars="0"
if [ -n "${LOG_MARTIAN_IPS}" ]; then
log_from_mars="1"
fi
for i in /proc/sys/net/ipv4/conf/*/log_martians; do
echo "Setting martian sources logging on ${i} to ${log_from_mars}"
echo ${log_from_mars} > ${i}
done

# don't log invalid responses to broadcast
echo 1 > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses

# don't accept or send ICMP redirects.
icmp_redir="1"
if [ -n "${DISALLOW_ICMP_REDIRECTS}" ]; then
icmp_redir="0"
fi
for i in /proc/sys/net/ipv4/conf/*/accept_redirects; do
echo "Setting ICMP redirection acceptance on ${i} to ${icmp_redir}"
echo ${icmp_redir} > ${i}
done
for i in /proc/sys/net/ipv4/conf/*/send_redirects; do
echo "Setting ICMP redirection send on ${i} to ${icmp_redir}"
echo ${icmp_redir} > ${i}
done

# don't accept source routed packets.
sr_pack="1"
if [ -n "${DISALLOW_SOURCE_ROUTED_PACKETS}" ]; then
sr_pack="0"
fi
for i in /proc/sys/net/ipv4/conf/*/accept_source_route; do
echo "Setting routed packed disallowing on ${i} to ${sr_pack}"
echo ${sr_pack} > ${i}
done

if [ -n "${TCP_FIN_TIMEOUT}" ]; then
echo "Setting tcp_fin_timeout to ${TCP_FIN_TIMEOUT}"
echo "${TCP_FIN_TIMEOUT}" > /proc/sys/net/ipv4/tcp_fin_timeout
fi
if [ -n "${TCP_KEEPALIVE_TIME}" ]; then
echo "Setting tcp_keepalive_time to ${TCP_KEEPALIVE_TIME}"
echo "${TCP_KEEPALIVE_TIME}" > /proc/sys/net/ipv4/tcp_keepalive_time
fi
w_scal="1"
if [ -n "${DISALLOW_TCP_WINDOW_SCALING}" ]; then
w_scal="0"
fi
echo "Setting tcp_window_scaling to ${w_scal}"
echo "${w_scal}" > /proc/sys/net/ipv4/tcp_window_scaling

# TCP timestamp
echo "Setting tcp_timestamps to ${TCP_TIMESTAMP}"
echo "${TCP_TIMESTAMP}" > /proc/sys/net/ipv4/tcp_timestamps

# disallow proxy_arp
p_arp="1"
if [ -n "${DISALLOW_PROXY_ARP}" ]; then
p_arp="0"
fi
for i in /proc/sys/net/ipv4/conf/*/proxy_arp; do
echo "Setting proxy_arp on ${i} to ${p_arp}"
echo ${p_arp} > ${i}
done
bp_rel="1"
if [ -n "${DISALLOW_BOOTP_RELAY}" ]; then
bp_rel="0"
fi
for i in /proc/sys/net/ipv4/conf/*/bootp_relay; do
echo "Setting bootp_relay on ${i} to ${bp_rel}"
echo ${bp_rel} > ${i}
done

s_redir="0"
if [ -n "${ENABLE_SECURE_ICMP_REDIRECTS}" ]; then
s_redir="1"
fi
for i in /proc/sys/net/ipv4/conf/*/secure_redirects; do
echo "Setting secure_redirects on ${i} to ${s_redir}"
echo ${s_redir} > ${i}
done

# enable changes
echo 1 > /proc/sys/net/ipv4/route/flush

# create some custom chains, useful for logging
# LOG packets, then ACCEPT
RLIMIT="-m limit --limit 3/s --limit-burst 8"
"${IPTABLES}" -N ACCEPTLOG
"${IPTABLES}" -A ACCEPTLOG -j ${LOG} ${RLIMIT} --log-prefix "ACCEPT "
"${IPTABLES}" -A ACCEPTLOG -j ACCEPT

# LOG packets, then DROP
"${IPTABLES}" -N DROPLOG
"${IPTABLES}" -A DROPLOG -j ${LOG} ${RLIMIT} --log-prefix "DROP "
"${IPTABLES}" -A DROPLOG -j DROP

# LOG packets, then REJECT
# TCP packets are rejected with a TCP reset.
"${IPTABLES}" -N REJECTLOG
"${IPTABLES}" -A REJECTLOG -j ${LOG} ${RLIMIT} --log-prefix "REJECT "
"${IPTABLES}" -A REJECTLOG -p tcp -j REJECT --reject-with tcp-reset
"${IPTABLES}" -A REJECTLOG -j REJECT
echo "Generated chains: ACCEPTLOG, DROPLOG, REJECTLOG"

# setup local communication
"${IPTABLES}" -A INPUT -i ${LO_IF} -j ACCEPT
"${IPTABLES}" -A OUTPUT -o ${LO_IF} -j ACCEPT

if [ -n "${DMZ_IF}" ]; then
"${IPTABLES}" -A INPUT -i ${DMZ_IF} -j ACCEPT
"${IPTABLES}" -A OUTPUT -o ${DMZ_IF} -j ACCEPT
echo "Permit all traffic on ${DMZ_IF}"
fi

# disable ports explicitly
for port in ${PORTS_TO_DISABLE}; do
"${IPTABLES}" -A INPUT -p tcp --dport ${port} -j DROPLOG
echo "Disabled input port ${port} on ${NET_IF} (tcp) (DROPLOG)"
"${IPTABLES}" -A INPUT -p udp --dport ${port} -j DROPLOG
echo "Disabled input port ${port} on ${NET_IF} (udp) (DROPLOG)"
done

if [ -n "${KILL_PORT_SCANNING}" ]; then
echo "Killing port scanning attempts on ${NET_IF}, against port ${PORT_SCANNING_PORT}, ban seconds: ${PORT_SCANNING_SECONDS}"
"${IPTABLES}" -A INPUT -i ${NET_IF} -m recent --name portscan --rcheck --seconds "${PORT_SCANNING_SECONDS}" -j DROP
"${IPTABLES}" -A FORWARD -m recent --name portscan --rcheck --seconds "${PORT_SCANNING_SECONDS}" -j DROP

# Once the day has passed, remove them from the portscan list
"${IPTABLES}" -A INPUT -i ${NET_IF} -m recent --name portscan --remove
"${IPTABLES}" -A FORWARD -m recent --name portscan --remove

# These rules add scanners to the portscan list, and log the attempt.
"${IPTABLES}" -A INPUT -i ${NET_IF} -p tcp -m tcp --dport "${PORT_SCANNING_PORT}" -m recent --name portscan --set -j LOG --log-prefix 
"Portscan(host_destroyed): "
"${IPTABLES}" -A INPUT -i ${NET_IF} -p tcp -m tcp --dport "${PORT_SCANNING_PORT}" -m recent --name portscan --set -j DROP

"${IPTABLES}" -A FORWARD -p tcp -m tcp --dport "${PORT_SCANNING_PORT}" -m recent --name portscan --set -j LOG --log-prefix 
"Portscan(host_destroyed): "
"${IPTABLES}" -A FORWARD -p tcp -m tcp --dport "${PORT_SCANNING_PORT}" -m recent --name portscan --set -j DROP
fi

# UDP
for port in ${UDP_PORTS_INCOMING_ALLOW}; do
"${IPTABLES}" -A INPUT -p udp --dport ${port} --sport 1024:65535 -j ACCEPT
"${IPTABLES}" -A OUTPUT -p udp --sport ${port} --dport 1024:65535 -m state --state RELATED,ESTABLISHED -j ACCEPT
echo "Allowing UDP incoming traffic on ${port} on ${NET_IF} (ACCEPT)"
done
for port in ${UDP_PORTS_OUTGOING_ALLOW}; do
"${IPTABLES}" -A OUTPUT -p udp --dport ${port} --sport 1024:65535 -j ACCEPT
"${IPTABLES}" -A INPUT -p udp --sport ${port} --dport 1024:65535 -m state --state RELATED,ESTABLISHED -j ACCEPT
echo "Allowing UDP outgoing traffic on ${port} on ${NET_IF} (ACCEPT)"
done

# TCP
for port in ${TCP_PORTS_INCOMING_ALLOW}; do
"${IPTABLES}" -A INPUT -p tcp --dport ${port} --sport 1024:65535 -j ACCEPT
"${IPTABLES}" -A OUTPUT -p tcp --sport ${port} --dport 1024:65535 -m state --state RELATED,ESTABLISHED -j ACCEPT
echo "Allowing TCP incoming traffic on ${port} on ${NET_IF} (ACCEPT)"
done
for port in ${TCP_PORTS_OUTGOING_ALLOW}; do
"${IPTABLES}" -A OUTPUT -p tcp --dport ${port} --sport 1024:65535 -j ACCEPT
"${IPTABLES}" -A INPUT -p tcp --sport ${port} --dport 1024:65535 -m state --state RELATED,ESTABLISHED -j ACCEPT
echo "Allowing TCP outgoing traffic on ${port} on ${NET_IF} (ACCEPT)"
done

# Timed ports
for port in ${TIMED_PORTS}; do
# TCP
"${IPTABLES}" -I INPUT -p tcp --dport ${port} -i ${NET_IF} -m state --state NEW -m recent --set
# log before TIMED_PORTS_HIT_COUNT
"${IPTABLES}" -I INPUT -p tcp --dport ${port} -i ${NET_IF} -m state --state NEW -m recent --update \
--seconds ${TIMED_PORTS_TIMER_SECS} --hitcount $((${TIMED_PORTS_HIT_COUNT}-1)) -j LOG
"${IPTABLES}" -I INPUT -p tcp --dport ${port} -i ${NET_IF} -m state --state NEW -m recent --update \
--seconds ${TIMED_PORTS_TIMER_SECS} --hitcount ${TIMED_PORTS_HIT_COUNT} -j DROP
echo "Setting up timed port feature on ${port} on ${NET_IF} (tcp) [seconds:${TIMED_PORTS_TIMER_SECS}|hit_count:${TIMED_PORTS_HIT_COUNT}] (DROP)"

# UDP
"${IPTABLES}" -I INPUT -p udp --dport ${port} -i ${NET_IF} -m state --state NEW -m recent --set
# log before TIMED_PORTS_HIT_COUNT
"${IPTABLES}" -I INPUT -p udp --dport ${port} -i ${NET_IF} -m state --state NEW -m recent --update \
--seconds ${TIMED_PORTS_TIMER_SECS} --hitcount $((${TIMED_PORTS_HIT_COUNT}-1)) -j LOG
"${IPTABLES}" -I INPUT -p udp --dport ${port} -i ${NET_IF} -m state --state NEW -m recent --update \
--seconds ${TIMED_PORTS_TIMER_SECS} --hitcount ${TIMED_PORTS_HIT_COUNT} -j DROP
echo "Setting up timed port feature on ${port} on ${NET_IF} (udp) [seconds:${TIMED_PORTS_TIMER_SECS}|hit_count:${TIMED_PORTS_HIT_COUNT}] (DROP)"
done

# ignore microsoft ports?
if [ -n "${IGNORE_MICROSOFT_SHIT}" ]; then
"${IPTABLES}" -A INPUT -p tcp -m multiport --dports 135,137,138,139,445,1433,1434,3306 -j DROP
"${IPTABLES}" -A INPUT -p udp -m multiport --dports 135,137,138,139,445,1433,1434,3306 -j DROP
fi

# ICMP TYPES
"${IPTABLES}" -N RELATED_ICMP
if [ -n "${ALLOW_SANE_ICMP}" ]; then
"${IPTABLES}" -A RELATED_ICMP -i ${NET_IF} -p icmp -m icmp -m limit --limit "${ICMP_PACKETS_PER_SECOND}/second" -j ACCEPT
"${IPTABLES}" -A RELATED_ICMP -i ${NET_IF} -p icmp --icmp-type destination-unreachable -j ACCEPT
"${IPTABLES}" -A RELATED_ICMP -i ${NET_IF} -p icmp --icmp-type time-exceeded -j ACCEPT
"${IPTABLES}" -A RELATED_ICMP -i ${NET_IF} -p icmp --icmp-type echo-reply -j ACCEPT
"${IPTABLES}" -A RELATED_ICMP -i ${NET_IF} -p icmp --icmp-type echo-request -j ACCEPT
"${IPTABLES}" -A RELATED_ICMP -i ${NET_IF} -p icmp --icmp-type parameter-problem -j ACCEPT
"${IPTABLES}" -A RELATED_ICMP -j DROPLOG
echo "Allowing sane ICMP, only accept some reliable ICMP packets"
elif [ -n "${FUCK_ICMP_I_DONT_NEED_IT}" ]; then
echo 0 > /proc/sys/net/ipv4/icmp_echo_ignore_all
echo "Ignoring all ICMP traffic"
fi
ignore_icmp_broadcast="0"
if [ -n "${IGNORE_ICMP_BROADCASTS}" ]; then
# ignore broadcast requests
ignore_icmp_broadcast="1"
fi
echo "Ignoring ICMP echo broadcasts"
echo ${ignore_icmp_broadcast} > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts

# Rate Limit RST packets
if [ -n "${RST_PACKETS_PER_SECOND}" ]; then
"${IPTABLES}" -A INPUT -p tcp -m tcp --tcp-flags RST RST -m limit --limit "${RST_PACKETS_PER_SECOND}/second" --limit-burst 2 -j ACCEPT
fi

# make it even harder to multi-ping
"${IPTABLES}" -A INPUT -p icmp -m limit --limit 1/s --limit-burst 2 -j ACCEPT
"${IPTABLES}" -A INPUT -p icmp -m limit --limit 1/s --limit-burst 2 -j LOG --log-prefix PING-DROP:
"${IPTABLES}" -A INPUT -p icmp -j DROP
"${IPTABLES}" -A OUTPUT -p icmp -j ACCEPT

# Drop all fragmented ICMP packets, malicious
"${IPTABLES}" -A INPUT -p icmp --fragment -j DROPLOG
"${IPTABLES}" -A OUTPUT -p icmp --fragment -j DROPLOG
"${IPTABLES}" -A FORWARD -p icmp --fragment -j DROPLOG

# Allow all ESTABLISHED ICMP traffic
"${IPTABLES}" -A INPUT -p icmp -m state --state ESTABLISHED -j ACCEPT ${RLIMIT}
"${IPTABLES}" -A OUTPUT -p icmp -m state --state ESTABLISHED -j ACCEPT ${RLIMIT}
# Allow some parts of the RELATED ICMP traffic, block the rest
"${IPTABLES}" -A INPUT -p icmp -m state --state RELATED -j RELATED_ICMP ${RLIMIT}
"${IPTABLES}" -A OUTPUT -p icmp -m state --state RELATED -j RELATED_ICMP ${RLIMIT}
# Allow incoming ICMP echo requests (ping), but only rate-limited
"${IPTABLES}" -A INPUT -p icmp --icmp-type echo-request -j ACCEPT ${RLIMIT}
# Allow outgoing ICMP echo requests (ping), but only rate-limited
"${IPTABLES}" -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT ${RLIMIT}

# Drop any other ICMP traffic
"${IPTABLES}" -A INPUT -p icmp -j DROPLOG
"${IPTABLES}" -A OUTPUT -p icmp -j DROPLOG
"${IPTABLES}" -A FORWARD -p icmp -j DROPLOG
echo "Configured stricted ICMP rules"

# explicitly drop invalid incoming/outgoing traffic
"${IPTABLES}" -A INPUT -m state --state INVALID -j DROP
"${IPTABLES}" -A OUTPUT -m state --state INVALID -j DROP
# If we would use NAT, INVALID packets would pass - BLOCK them anyways
"${IPTABLES}" -A FORWARD -m state --state INVALID -j DROP
echo "Dropped all INVALID incoming/outgoing traffic"

# PORT Scanners (stealth also)
"${IPTABLES}" -A INPUT -m state --state NEW -p tcp --tcp-flags ALL ALL -j DROP
"${IPTABLES}" -A INPUT -m state --state NEW -p tcp --tcp-flags ALL NONE -j DROP
echo "Made port-scanner life harder"

if [ -n "${SYN_FLOOD_PROTECTION}" ]; then
"${IPTABLES}" -N SYN_FLOOD
"${IPTABLES}" -A INPUT -p tcp --syn -j SYN_FLOOD
"${IPTABLES}" -A SYN_FLOOD -m limit --limit 2/s --limit-burst 6 -j RETURN
"${IPTABLES}" -A SYN_FLOOD -j DROP
echo "Made SYN packets life harder (setting 2/s limit, 6 burst packets thresholds)"
fi

if [ -n "${DROP_IANA_IPS}" ]; then
"${IPTABLES}" -A INPUT -s 0.0.0.0/7 -j DROP
"${IPTABLES}" -A INPUT -s 2.0.0.0/8 -j DROP
"${IPTABLES}" -A INPUT -s 5.0.0.0/8 -j DROP
"${IPTABLES}" -A INPUT -s 7.0.0.0/8 -j DROP
"${IPTABLES}" -A INPUT -s 10.0.0.0/8 -j DROP
"${IPTABLES}" -A INPUT -s 23.0.0.0/8 -j DROP
"${IPTABLES}" -A INPUT -s 27.0.0.0/8 -j DROP
"${IPTABLES}" -A INPUT -s 31.0.0.0/8 -j DROP
"${IPTABLES}" -A INPUT -s 36.0.0.0/7 -j DROP
"${IPTABLES}" -A INPUT -s 39.0.0.0/8 -j DROP
"${IPTABLES}" -A INPUT -s 42.0.0.0/8 -j DROP
"${IPTABLES}" -A INPUT -s 49.0.0.0/8 -j DROP
"${IPTABLES}" -A INPUT -s 50.0.0.0/8 -j DROP
"${IPTABLES}" -A INPUT -s 77.0.0.0/8 -j DROP
"${IPTABLES}" -A INPUT -s 78.0.0.0/7 -j DROP
"${IPTABLES}" -A INPUT -s 92.0.0.0/6 -j DROP
"${IPTABLES}" -A INPUT -s 96.0.0.0/4 -j DROP
"${IPTABLES}" -A INPUT -s 112.0.0.0/5 -j DROP
"${IPTABLES}" -A INPUT -s 120.0.0.0/8 -j DROP
"${IPTABLES}" -A INPUT -s 169.254.0.0/16 -j DROP
"${IPTABLES}" -A INPUT -s 172.16.0.0/12 -j DROP
"${IPTABLES}" -A INPUT -s 173.0.0.0/8 -j DROP
"${IPTABLES}" -A INPUT -s 174.0.0.0/7 -j DROP
"${IPTABLES}" -A INPUT -s 176.0.0.0/5 -j DROP
"${IPTABLES}" -A INPUT -s 184.0.0.0/6 -j DROP
"${IPTABLES}" -A INPUT -s 192.0.2.0/24 -j DROP
"${IPTABLES}" -A INPUT -s 197.0.0.0/8 -j DROP
"${IPTABLES}" -A INPUT -s 198.18.0.0/15 -j DROP
"${IPTABLES}" -A INPUT -s 223.0.0.0/8 -j DROP
"${IPTABLES}" -A INPUT -s 224.0.0.0/24 -j DROP
echo "Dropped all IANA-reserved IP ranges"
fi

# kick off identd quick
if [ -n "${KILL_IDENTD}" ]; then
"${IPTABLES}" -A INPUT -p tcp -i ${NET_IF} --dport 113 -j REJECT --reject-with tcp-reset
echo "Dropped identd request completely on ${NET_IF} (REJECT)"
fi

if [ -f "${CUSTOM_RULES_FILE_POST}" ]; then
source "${CUSTOM_RULES_FILE_POST}"
fi

# close both TCP and UDP
iptables -A OUTPUT -j REJECTLOG
iptables -A INPUT -j REJECTLOG
iptables -A FORWARD -j REJECTLOG
