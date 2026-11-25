# UDP
### server
```python
import socket

Sock_serv = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
Sock_serv.bind(("127.0.0.1", 60000))
msgClient, add_client = Sock_serv.recvfrom(1024)
Sock_serv.sendto("Welcome to this server".encode(), add_client)
print("Server received:", msgClient.decode(), "-- from client:", add_client)
Sock_serv.close()
```
### client
```python
import socket

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.sendto("Hello server".encode(), ("127.0.0.1", 60000))
msgServ, add_serv = s.recvfrom(1024)
s.close()
```
# TCP
### server
```python
import socket

Sock_serv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
Sock_serv.bind(("127.0.0.1", 60000))
Sock_serv.listen()
Sock_client, add_client = Sock_serv.accept()
msgClient = Sock_client.recv(1024)
Sock_client.send("Welcome to this server".encode())
print("Server received:", msgClient.decode(), "-- from client:", add_client)
Sock_client.close()
Sock_serv.close()
```
### client
```python
import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(("127.0.0.1", 60000))
s.send("Hello server".encode())
msgServ = s.recv(1024)
s.close()
```
# Solution
1. l'adresse localhost
2. etre dans l'intervalle des port dynamiques ou privés 49152-65535
3. recvFrom est recommandé car on peut recupere le socket du client pour continuer la communication