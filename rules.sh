ifname=$(ip route get 1 | awk '{print $(NF-4);exit}')

iptables -t nat -A POSTROUTING -s 10.0.1.0/24 -o $ifname -m policy --pol ipsec --dir out -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.0.1.0/24 -o $ifname -j MASQUERADE

iptables -A FORWARD --match policy --pol ipsec --dir in -s 10.0.1.0/24 -o $ifname -p tcp -m tcp --tcp-flags SYN,RST SYN -m tcpmss --mss 1361:1536 -j TCPMSS --set-mss 1360

echo 1 > /proc/sys/net/ipv4/ip_forward
