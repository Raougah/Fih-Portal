### Configuration reseau initial

- **Adresse IPv4 locale:** 192.168.0.6
- **Adresse MAC:**  10:08:b1:3e:96:bb
- **Gateway:** 192.168.0.1
- **Nom de domaine cible:** zahratemmar.pythonanywhere.com
- **Adresse IP du sserveur:** 35.173.69.207
### Analyse HTTP

1. ![[Pasted image 20261015114425.png]]
2. Code 304 Not modified ![[Pasted image 20261015114633.png]]
3. 

| Couche/Champ | Source            | Destination       | Domaine Cible                  |
| ------------ | ----------------- | ----------------- | ------------------------------ |
| Liaison      | 10:08:b1:3e:96:bb | a0:9f:7a:10:d5:f5 | zahratemmar.pythonanywhere.com |
| Réseau       | 192.168.0.6       | 35.173.69.207     |                                |
| Transport    | 51592             | 80                |                                |
### Manipulation
- Oui on retrouve les données saisie il y'a un danger d'une interception **(attack Man In The Middle)**
![[Pasted image 20261015115452.png]]

| Couche/Champ | Source            | Destination       | Domaine Cible                  |
| ------------ | ----------------- | ----------------- | ------------------------------ |
| Liaison      | 10:08:b1:3e:96:bb | a0:9f:7a:10:d5:f5 | zahratemmar.pythonanywhere.com |
| Réseau       | 192.168.0.6       | 35.173.69.207     |                                |
| Transport    | 51592             | 80                |                                |

### QUIC
- TLSv1.3 et QUIC, le contenu n'est plus visible car le trafics avec les utilisants le protocol https et chiffré avant d'etre transmis

| Couche/Champ | Source            | Destination       | Domaine Cible   |
| ------------ | ----------------- | ----------------- | --------------- |
| Liaison      | 10:08:b1:3e:96:bb | d8:32:14:2a:5f:d0 | www.youtube.com |
| Réseau       | 192.168.0.151     | 66.102.1.102      |                 |
| Transport    | 59369             | 443               |                 |
- Le protocole qui apparait et le protocole QUIC c'est le protocol de transport de http/3, il integre le chiffrement et multiplexage
![[Pasted image 20261021224224.png]]

- http/2 integre le multiplexage avec une seule connexion TCP donc si un paquet est perdu tout les flux sont touché
- http/3 utlise QUIC avec UDP donc si un paquet est perdu seul le flux concerné est touché
- Pile de protocole
	- **HTTP/1.1** : HTTP/1.1 **TCP** IP
	- **HTTPS** : HTTP **TLS** TCP IP
	- **HTTP/3** : HTTP/3 **QUIC** **UDP** IP