# Partie1
- Le serveur par defaut est le **routeur(gateway)**, **IP: 192.168.01**
![[Pasted image 20261028165748.png]]
- l'adresse retourné **41.111.171.195**
- Oui car la reponse est venu du cache ou d'un autre serveur dns et pas de ns1.univ-usto.dz
![[Pasted image 20261028181700.png]]
![[Pasted image 20261028181832.png]]
![[Pasted image 20261028181930.png]]
![[Pasted image 20261028181958.png]]
![[Pasted image 20261028182030.png]]


| Type RR | Rôle du Type d'Enregistrement            | Résultat pour univ-usto.dz                                                                                                                                             | Résultat pour google.com                                                                                                                                      |
| ------- | ---------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A       | Adresse IPv4 (32 bits)                   | 41.111.171.195                                                                                                                                                         | 192.178.203.102                                                                                                                                               |
| AAAA    | Adresse IPv6 (128 bits)                  | *** Can't find univ-usto.dz: No answer                                                                                                                                 | 2a00:1450:400c:c06::66                                                                                                                                        |
| MX      | Serveur(s) de messagerie électronique    | mail exchanger = 10 ALT4.ASPMX.L.GOOGLE.COM                                                                                                                            | mail exchanger = 10 smtp.google.com                                                                                                                           |
| NS      | Serveur(s) DNS autoritaire(s) de la zone | nameserver = ns1.univ-usto.dz                                                                                                                                          | nameserver = ns1.google.com                                                                                                                                   |
| SOA     | Paramètres administratifs de la zone     | origin = ns1.univ-usto.dz<br>	mail addr = admin.univ-usto.dz<br>	serial = 2016063022<br>	refresh = 43200<br>	retry = 7200<br>	expire = 1209600<br>	minimum = 86400<br> | origin = ns1.google.com<br>	mail addr = dns-admin.google.com<br>	serial = 1007977091<br>	refresh = 900<br>	retry = 900<br>	expire = 1800<br>	minimum = 60<br> |
- Par design du DNS quand on change l'adresse ip du record NS on pourra le faire sans updater tout les records
# Partie2

| Champ / Élément à relever       | Trame Requête (Query)                          | Trame Réponse (Response)                       |
| ------------------------------- | ---------------------------------------------- | ---------------------------------------------- |
| Adresse MAC Source / Dest.      | Src:10:08:b1:3e:96:bb<br>Dst:d8:32:14:2a:5f:d0 | Src:d8:32:14:2a:5f:d0<br>Dst:10:08:b1:3e:96:bb |
| Adresse IP Source / Dest.       | Src: 192.168.0.151 <br>Dst: 192.168.0.1        | Src:192.168.0.1<br>Dst:192.168.0.151           |
| Port Source / Port Dest.        | Src:56580<br>Dst:53                            | Src:53<br>Dst:56580                            |
| Protocole de Transport          | UDP                                            | UDP                                            |
| Transaction ID (16 bits)        | 0x6de1                                         | 0x6de1                                         |
| Flags : Bit QR (Query/Response) | ![[Pasted image 20261028185209.png]]           | ![[Pasted image 20261028185555.png]]           |
| Nom de Domaine & Type demandé   | ![[Pasted image 20261028185335.png]]           |                                                |
| Adresse IP retournée & TTL      |                                                | ![[Pasted image 20261028185700.png]]           |
- le port 53, on utilise UDP car il est plus rapide
- le premier bit
- Transaction ID
- Time to Live in cache
- TTL eleve veut dire plus de temps en cache, inconvénient en cas de change d'adresse le serveur renvoie a l'adresse precedente
- ![[Pasted image 20261028190537.png]]
![[Pasted image 20261028190549.png]]