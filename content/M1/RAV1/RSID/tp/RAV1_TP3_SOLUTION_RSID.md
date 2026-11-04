# Part 1
- The packets represent the three way handshake to establish the TCP connexion
![[Pasted image 20261104224222.png]]
 
 - First FTP packet
![[Pasted image 20261104224307.png]]
- username request/reply 
 ![[Pasted image 20261104224400.png]]
![[Pasted image 20261104224449.png]]
- password request/reply
![[Pasted image 20261104225007.png]]![[Pasted image 20261104224524.png]]
- SERVER IP and client
![[Pasted image 20261104225223.png]]

- yes the password is readable and can be intercepted by a man in the middle attack
# Part 2

![[Pasted image 20261104225510.png]]
- pwd
![[Pasted image 20261104230635.png]]

![[Pasted image 20261104230904.png]]

- dir
![[Pasted image 20261104230917.png]]

![[Pasted image 20261104230939.png]]

![[Pasted image 20261104231059.png]]

![[Pasted image 20261104231120.png]]

![[Pasted image 20261104231134.png]]
- non les fichiers n'apparaisent pas dans les packets envoyé sur le port 21 car c'est la connexion de controle 
- dir apres cd
![[Pasted image 20261104225558.png]]

![[Pasted image 20261104231640.png]]
![[Pasted image 20261104231704.png]]

![[Pasted image 20261104231758.png]]


# Part 3
- code avant connection 125 et apres 226
![[Pasted image 20261104230003.png]]
![[Pasted image 20261104231906.png]]
```txt
Welcome to test.rebex.net!

You are connected to an FTP or SFTP server used for testing purposes
by Rebex FTP/SSL or Rebex SFTP sample code. Only read access is allowed.

For information about Rebex FTP/SSL, Rebex SFTP and other Rebex libraries
for .NET, please visit our website at https://www.rebex.net/

For feedback and support, contact support@rebex.net

Thanks!

```
![[Pasted image 20261104231948.png]]

- on peut pas voir les fichiers car il sont transferé sur la connection de donne sur **le port 20**
- des packets FTP-DATA avec les fichiers et les repertoire recu avec dir
![[Pasted image 20261104232256.png]]
![[Pasted image 20261104232308.png]]

- le serveur envoie le premier SYN
![[Pasted image 20261104232511.png]]
- les echanges de packets

| Serveur     | Client  | protocol |
| ----------- | ------- | -------- |
| SYN ECE CWR |         | TCP      |
|             | SYN ACK |          |
| ACK         |         |          |
| FIN ACK     |         |          |
|             | ACK     |          |
| PSH ACK     |         | FTP-DATA |
|             | ACK     | TCP      |
|             | FIN ACK |          |
| ACK         |         |          |
- non la connection n'est pas fermé
- non ce n'est pas le meme port
- 21: connection de controle pour l'envoie de comande
- 20: connection de donnee pour l'envoi des donnés
- apres bye: 221 Closing session.

