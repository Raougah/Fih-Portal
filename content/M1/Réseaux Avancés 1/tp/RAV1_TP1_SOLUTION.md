### Configuration reseau initial

- **Adresse IPv4 locale:** 
- **Adresse MAC:**  
- **Gateway:** 
- **Nom de domaine cible:** zahratemmar.pythonanywhere.com
- **Adresse IP du sserveur:** 35.173.69.207
### Analyse HTTP

1. ![[Pasted image 20261015114425.png]]
2. Code 304 Not modified ![[Pasted image 20261015114633.png]]
3. 

| Couche/Champ | Source            | Destination       | Domaine Cible |
| ------------ | ----------------- | ----------------- | ------------- |
| Liaison      | 10:08:b1:3e:96:bb | a0:9f:7a:10:d5:f5 |               |
| Réseau       | 192.168.0.6       | 35.173.69.207     |               |
| Transport    | 51592             | 80                |               |
### Manipulation
- Oui on retrouve les données saisie il y'a un danger d'une interception **(attack Man In The Middle)**
![[Pasted image 20261015115452.png]]

| Couche/Champ | Source            | Destination       | Domaine Cible |
| ------------ | ----------------- | ----------------- | ------------- |
| Liaison      | 10:08:b1:3e:96:bb | a0:9f:7a:10:d5:f5 |               |
| Réseau       | 192.168.0.6       | 35.173.69.207     |               |
| Transport    | 51592             | 80                |               |
