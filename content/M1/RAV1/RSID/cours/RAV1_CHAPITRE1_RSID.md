# Molakhas
## Cours
### Modele OSI et TCP/IP
```mermaid
block-beta
  columns 5

  %% Compact Column Headers
  header_osi["Modèle OSI"]:2
  header_tcp["Modèle TCP/IP"]:2
  header_pdu["Unité (PDU)"]:1

  %% Group 1: Application (Layers 7, 6, 5 -> Application -> Data)
  block:grp_app:5
    columns 5
    block:osi_app:2
      columns 1
      osi7["7. Application"]
      osi6["6. Présentation"]
      osi5["5. Session"]
    end
    tcp_app["Application"]:2
    pdu_data["Data<br/>(Données)"]:1
  end

  %% Group 2: Transport (Layer 4 -> Transport -> Segment)
  block:grp_trans:5
    columns 5
    osi4["4. Transport"]:2
    tcp_trans["Transport"]:2
    pdu_seg["Segment"]:1
  end

  %% Group 3: Internet / Réseau (Layer 3 -> Internet -> Packet)
  block:grp_net:5
    columns 5
    osi3["3. Réseau"]:2
    tcp_net["Internet"]:2
    pdu_pkt["Packet<br/>(Paquet)"]:1
  end

  %% Group 4: Network Access (Layers 2, 1 -> Accès réseau -> Frame & Bits)
  block:grp_link:5
    columns 5
    block:osi_link:2
      columns 1
      osi2["2. Liaison de données"]
      osi1["1. Physique"]
    end
    tcp_link["Accès réseau"]:2
    block:pdu_link:1
      columns 1
      pdu_frame["Frame (Trame)"]
      pdu_bits["Bits"]
    end
  end

  %% Styling
  classDef header fill:transparent,stroke:none,font-weight:bold,font-size:13px,padding:0px
  class header_osi,header_tcp,header_pdu header

  classDef box fill:#ececec,stroke:#1b5e4b,stroke-width:3px,rx:6,ry:6,color:#000
  class osi7,osi6,osi5,osi4,osi3,osi2,osi1,tcp_app,tcp_trans,tcp_net,tcp_link box

  classDef pdu fill:#ffffff,stroke:#1b5e4b,stroke-width:2px,stroke-dasharray: 4 3,rx:6,ry:6,color:#1b5e4b,font-weight:bold
  class pdu_data,pdu_seg,pdu_pkt,pdu_frame,pdu_bits pdu

  classDef invisible fill:transparent,stroke:none
  class osi_app,osi_link,pdu_link invisible

  style grp_app fill:#d4f3ea,stroke:#62d2b4,stroke-width:1px,rx:6,ry:6
  style grp_trans fill:#dadcf5,stroke:#8b90d6,stroke-width:1px,rx:6,ry:6
  style grp_net fill:#ead4eb,stroke:#b682b8,stroke-width:1px,rx:6,ry:6
  style grp_link fill:#fadbc8,stroke:#e59b6d,stroke-width:1px,rx:6,ry:6
```
### Architecture
#### Client/serveur
- 3andek serveur ou client yethadro, client ydemandi swala7 ou serveur yjaweb
##### Types
- **Architecture 2-tiers:** client serveur bark kayen ghir *(2 niveau)*
- **Architecture 3-tiers:** client et 2 serveurs *(3 niveau)*
- **Architecture n-tiers:** client ou  n-1 serveurs 
##### Avantage et Incoveniant
- Jay centralisé mala sahel fel gestion ou bech tsecurisih 
- jay centralise mala ida yetmolasta serveur yetmolasta kolch **(single point of failure)**
- tesralah constipation ki ykon ghachi bzaf **(moodle lila 9bel examen)**
#### Peer To Peer 
- Ga3 les pairs ykono clients et serveurs f nafs wa9t
##### Avantage et Incoveniant
- Jay mchi centralisé mala s3ib fel gestion ou bech tsecurisih 
- jay mchi centralise mala yetmolasta pair normal
- Kayen repartition ta3 la charge matesraloch constipation
- Performance 3la 7sab les pairs
#### Publisher/Subscriber 
- **Publisher:** Walter White yeproduisi zaza
- **Broker:** Gustave yerproposi abonnement ta3 zaza
- **Subscriber:** Yahia yconsomi zaza
Les information yet9asmo en topics par example zaza,cocaine,marijuana ou subscribers ykhayro 3la chah y2aboniw mala ki tji information jdida broker yerselhalhom direct

##### Avantage et Incoveniant
- Kayen decouplage, Pub masam3ch bel Sub
- Communication asynchrone
- S3ib fel gestion ou bech tsecurisih 
- L'information pas forcément towsal dans l'ordre
## DNS

### Fonctionement
#### Concept
- Nom de domaine yrodah adresse IP
#### el mosabi3on
- **Client:** hada li ydir la requete recursive lel resolver
- **Recursive resolver:** hada ysa9si lokhrin bah yejbed el ip bech yerselha lel client
- **Root Server:** hada ypointi lel top level domain (.dz, .com, .fr)
- **TLD Server:** hada ypointi lel serveur authoritaire 
- **Authoritative Server:** hada 3ando ma3loma final
#### Cache
- Ida ma3loma kayen fel cache **SKIP**
- TTL decidi ch7al yeb9a fel cache
#### Diagramme
```mermaid
flowchart LR
    Client(["Client"])
    Cache["Cache<br/>(Local / OS / Router / Hosts)"]

    Client -- "1. Check cache" --> Cache
    Cache -- "2. Not found" --> Client
    Client -- "3. Query IP" --> Resolver

    subgraph DNS["DNS Search"]
        direction LR
        Resolver["Recursive Resolver"]
        Root["Root Server"]
        TLD["TLD Server"]
        Auth["Authoritative Server"]

        Resolver -- "4. Query TLD" --> Root
        Root -- "5. TLD IP" --> Resolver
        Resolver -- "6. Query Auth" --> TLD
        TLD -- "7. Auth IP" --> Resolver
        Resolver -- "8. Query domain IP" --> Auth
        Auth -- "9. Domain IP" --> Resolver
    end

    Resolver -- "10. Return IP" --> Client

    style DNS fill:#fffde7,stroke:#5c6bc0,stroke-width:2px,stroke-dasharray: 5 5
    classDef nodeStyle fill:#ececec,stroke:#1b5e4b,stroke-width:2px,rx:5,ry:5,color:#000
    class Client,Cache,Resolver,Root,TLD,Auth nodeStyle
```
#### La zone
- hna win kayen les enregistrements DNS

| **Type** | **Fonction**                            |
| -------- | --------------------------------------- |
| A        | Nom → adresse IPv4                      |
| AAAA     | Nom → adresse IPv6                      |
| CNAME    | Alias d’un nom                          |
| MX       | Serveur de messagerie                   |
| NS       | Serveur DNS autoritaire                 |
| TXT      | Informations textuelles                 |
| SOA      | Informations administratives de la zone |
| PTR      | Adresse IP → nom                        |
#### Reverse DNS
- Evil Twin DNS yrodlek adresse IP ila ism
### Ma3lomat lazem ta3rafhom

| **Port**                 | 53                                                                                  |
| ------------------------ | ----------------------------------------------------------------------------------- |
| **Protocol Transport**   | UDP mais sa3at TCP ida la reponse tfout 500 octet <br>wela kayen changement de zone |
| **Resolution recursive** | mabin client ou resolver                                                            |
| **Resolution iterative** | mabin resolver ou les serveurs                                                      |
| **DoT**                  | DNS over TLS port tcp 853                                                           |
| **DoH**                  | DNS over HTTPS port tcp 443                                                         |
| **DNSSEC**               | khati chiffrement ydir authentification ou integrity                                |
### Security
- **DNS vergiftung(DNS cache poisoning):** attaquant yseba3 fel cache
- **подмена DNS (DNS Spoofing):** wa7ed yjaweb fi blacet resolveur wela serveur
- DNS mchi chiffré 3la hadik kayen DoT, DoH ou may2asurich integrité mala kayen DNSSEC
- **DOS wela DDOS** 3la serveur li ma3labalehch cha ma3netha DDOS aymen gal teb3at wladek ymolestiw server, ana golt ta9ra M1 ida mata3rafch 9is ro7ak
- **DNS tunneling** testa3mel DNS bech tfout 3la firewall
- **Détournement de domaine** yedo el compte ta3 admin ou yereslok schadlicher server

| **Problème**            | **Propriété principalement concernée** | **Conséquence**                              |
| ----------------------- | -------------------------------------- | -------------------------------------------- |
| DNS Spoofing            | Authenticité                           | Fausse réponse DNS                           |
| Cache Poisoning         | Intégrité                              | Cache contenant de fausses données           |
| Requêtes non chiffrées  | Confidentialité                        | Observation des noms consultés               |
| DoS / DDoS              | Disponibilité                          | Service DNS inaccessible                     |
| Tunneling DNS           | Surveillance et contrôle du réseau     | Communication ou fuite de données dissimulée |
| Détournement de domaine | Intégrité et contrôle administratif    | Modification des enregistrements             |
# DHCP
### Fonctionement
#### Concept

# Fichiers Utiles
- [[RAV1_COURS1_RSID.pdf|Cours]]
- [[RAV1_DNS_RSID.pdf|DNS]]
- [[RAV1_DHCP_RSID.pdf|DHCP]]
- [[RAV1_HTTP_RSID.pdf|HTTP]]
- [[RAV1_IOT_RSID.pdf|IOT]]
- [[RAV1_MAIL_RSID.pdf|Mail]]
- [[RAV1_VOIP_RSID.pdf|VoIP]]
- [[RAV1_FTP_RSID.pdf|FTP]]
- [[RAV1_COURS1_Question_RSID|Questions]]