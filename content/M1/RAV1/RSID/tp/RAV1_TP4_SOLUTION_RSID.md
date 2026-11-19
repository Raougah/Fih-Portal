# Part 1


- 
- 192.168.1.10
- ![[Pasted image 20261118215731.png]]
- 4
- **Tableau**

| Message  | Sender  | Receiver                                        |
| -------- | ------- | ----------------------------------------------- |
| Discover | PC0     | Broadcast avec le serveur qui accepte le packet |
| Offer    | serveur | Broadcast avec le PC0 qui accepte le packet     |
| Request  | PC0     | Broadcast avec le serveur qui accepte le packet |
| Ack      | serveur | Broadcast avec le PC0 qui accepte le packet     |

- le switch fait un broadcast avec le packet discover car PC0 ne connait pas l'addresse du serveur
- ![[Pasted image 20261118223816.png]]
- ![[Pasted image 20261118224333.png]]
- DHCP Release
- oui le pc0 recois la meme addresse car c'est le seul pc configuré pour DHCP
- ![[Pasted image 20261118225749.png]]
- c'est une adresse APIPA donné par le systeme d'exploitation pour communiqué dans le reseau local