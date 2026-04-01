## **Fiche:**

- [[FICHESECITD2.pdf]]
## **Solution:**

```bash
#1)

iptables -A OUTPUT -J DROP
iptables -A INPUT -J DROP
iptables -A FORWARD -J DROP

#2)

iptables -A OUTPUT -J ACCEPT -s 193.168.25.1/24 -d 172.33.25.1/24

#3)

iptables -A OUTPUT -J DROP -s 10.0.2.1/24 -d 172.33.25.1/24 
iptables -A OUTPUT -J DROP -s 10.0.2.1/24 -d 193.168.25.1/24

#4)

iptables -A INPUT -J DROP -p ICMP -s 10.0.2.1/24

#5)

iptables -A OUTPUT -J DROP -s 10.0.2.1/24 -d 193.168.25.1/24 --dport 22

#6)

iptables -A INPUT -J DROP -s 193.168.25.1/24 --sport 22 -m limit --limit 3/min
```
