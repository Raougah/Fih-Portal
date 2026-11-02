
> La fiche tp: - [[AI_RAV_TP2_FLSM_SOL|TP2 SOL]]
> Packet tracer file: [[AI_RAV_TP_2_FLSM.pkt]]
> Image topologie:
> ![[AI_RAV_TP_2_FLSM.png]]
## Étape 1 : diviser 192.168.100.0/24

| **Question**                                                        | **Réponse**                                                       |
| ------------------------------------------------------------------- | ----------------------------------------------------------------- |
| a. D'après la topologie, combien de sous-réseaux sont nécessaires ? | **5** (4 LANs + 1 liaison WAN)                                    |
| b. Combien de bits faut-il emprunter ?                              | **3 bits** ($2^3 = 8$ sous-réseaux)                               |
| c. Combien de sous-réseaux obtient-on ?                             | **8** sous-réseaux                                                |
| d. Combien d'hôtes utilisables par sous-réseau ? (25 minimum)       | **30** hôtes ($2^5 - 2 = 30$, car il reste 5 bits pour les hôtes) |
> bach n3arfo ch7al nado emprunt khass ykoun $2^n$ > ch7al 3adna mn LAN (sous-réseaux)
> mouraha ywali 3adna partie réseaux = /27 3lah ? kan 3adna /24 + 3 (emprenter) = /27 yab9ana 32 - 27 = 5 bits li partie machine donc $2^5$ - 2 = 30 machines

## Étape 1e-f : binaire et masque

**e. Valeur binaire des cinq premiers sous-réseaux :**

| **N∘** | **Réseau**          | **Bit 7** | **Bit 6** | **Bit 5** | **Bit 4** | **Bit 3** | **Bit 2** | **Bit 1** | **Bit 0** |
| ------ | ------------------- | --------- | --------- | --------- | --------- | --------- | --------- | --------- | --------- |
| 0      | 192.168.100.**0**   | 0         | 0         | 0         | 0         | 0         | 0         | 0         | 0         |
| 1      | 192.168.100.**32**  | 0         | 0         | 1         | 0         | 0         | 0         | 0         | 0         |
| 2      | 192.168.100.**64**  | 0         | 1         | 0         | 0         | 0         | 0         | 0         | 0         |
| 3      | 192.168.100.**96**  | 0         | 1         | 1         | 0         | 0         | 0         | 0         | 0         |
| 4      | 192.168.100.**128** | 1         | 0         | 0         | 0         | 0         | 0         | 0         | 0         |

**f. Nouveau masque de sous-réseau (/27) :**

| **Format**  | **Octet 1** | **Octet 2** | **Octet 3** | **Octet 4** |
| ----------- | ----------- | ----------- | ----------- | ----------- |
| **Binaire** | 11111111    | 11111111    | 11111111    | 11100000    |
| **Décimal** | 255         | 255         | 255         | 224         |

- Quel est le pas entre deux sous-réseaux ? **32** (kol khatra nzido bi 32)

## Étape 1g : table des sous-réseaux

| **N∘** | **Sous-réseau** | **1re utilisable** | **Dernière utilisable** | **Diffusion (Broadcast)** |
| ------ | --------------- | ------------------ | ----------------------- | ------------------------- |
| 0      | 192.168.100.0   | 192.168.100.1      | 192.168.100.30          | 192.168.100.31            |
| 1      | 192.168.100.32  | 192.168.100.33     | 192.168.100.62          | 192.168.100.63            |
| 2      | 192.168.100.64  | 192.168.100.65     | 192.168.100.94          | 192.168.100.95            |
| 3      | 192.168.100.96  | 192.168.100.97     | 192.168.100.126         | 192.168.100.127           |
| 4      | 192.168.100.128 | 192.168.100.129    | 192.168.100.158         | 192.168.100.159           |
| 5      | 192.168.100.160 | 192.168.100.161    | 192.168.100.190         | 192.168.100.191           |
| 6      | 192.168.100.192 | 192.168.100.193    | 192.168.100.222         | 192.168.100.223           |
| 7      | 192.168.100.224 | 192.168.100.225    | 192.168.100.254         | 192.168.100.255           |

## Étape 2 : attribution aux réseaux

| **Sous-réseau** | **Réseau à connecter**          | **Adresse /27**    |
| --------------- | ------------------------------- | ------------------ |
| 0               | LAN - GigabitEthernet 0/0 de R1 | 192.168.100.0/27   |
| 1               | LAN - GigabitEthernet 0/1 de R1 | 192.168.100.32/27  |
| 2               | LAN - GigabitEthernet 0/0 de R2 | 192.168.100.64/27  |
| 3               | LAN - GigabitEthernet 0/1 de R2 | 192.168.100.96/27  |
| 4               | Liaison WAN entre R1 et R2      | 192.168.100.128/27 |

## Étape 3 : documenter l'adressage

_(Le masque de sous-réseau pour tous les appareils est **255.255.255.224**)_

| **Routeur** | **Interface**       | **Adresse IP**  |
| ----------- | ------------------- | --------------- |
| R1          | GigabitEthernet 0/0 | 192.168.100.1   |
| R1          | GigabitEthernet 0/1 | 192.168.100.33  |
| R1          | S0/0/0 (WAN)        | 192.168.100.129 |
| R2          | GigabitEthernet 0/0 | 192.168.100.65  |
| R2          | GigabitEthernet 0/1 | 192.168.100.97  |
| R2          | S0/0/0 (WAN)        | 192.168.100.158 |

| **Appareil** | **Adresse IP**  | **Passerelle par défaut** |
| ------------ | --------------- | ------------------------- |
| S1           | 192.168.100.2   | 192.168.100.1             |
| S2           | 192.168.100.34  | 192.168.100.33            |
| S3           | 192.168.100.66  | 192.168.100.65            |
| S4           | 192.168.100.98  | 192.168.100.97            |
| PC1          | 192.168.100.30  | 192.168.100.1             |
| PC2          | 192.168.100.62  | 192.168.100.33            |
| PC3          | 192.168.100.94  | 192.168.100.65            |
| PC4          | 192.168.100.126 | 192.168.100.97            |
