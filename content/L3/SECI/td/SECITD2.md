## **Fiche:**

- [[FICHESECITD2.pdf]]
  
## **Solution:**

```bash
#1)

iptables -A OUTPUT -J DROP
iptables -A INPUT -J DROP
iptables -A FORWARD -J DROP

#2)

iptables -A FORWARD -J ACCEPT -i eth2 -o eth1 -s 193.168.25.0/24 -d 172.33.25.0/24

#3)

iptables -A FORWARD -J DROP -i eth2 -o eth1 -s 193.168.25.0/24 -d 172.33.25.0/24
iptables -A FORWARD -J DROP -i eth0 -o eth1 -s 10.0.2.0/24 -d 172.33.25.0/24

#4)

iptables -A INPUT -J DROP -p icmp --icmp-type echo-request -d 10.0.2.0/24

#5)

iptables -A OUTPUT -J DROP -p tcp --dport 22 -i eth0 -o eth2 -s 10.0.2.0/24 -d 193.168.25.0/24

#6)

iptables -A FORWARD -J DROP -p tcp -dport 22 -d 193.168.25.0/24 -m limit --limit 3/min
```
