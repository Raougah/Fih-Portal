
> La fiche tp: - [[AI_RAV_TP_2_VLSM.pdf|TP2 VLSM]]
> Packet tracer file: makanch
> Image topologie:
> ![[Pasted image 20261103165515.png]]

## 1. Identify the required subnets

First, count all LANs and point-to-point connections in the topology. There are:

|Network|Required hosts|
|---|---|
|LAN 1, PC1|50|
|LAN 2, PC2|50|
|LAN 3, PC3|20|
|LAN 4, PC4|20|
|LAN 5, PC5|12|
|LAN 6, PC6|12|
|WAN, SIEGE ↔ AGENCE1|2|
|WAN, SIEGE ↔ AGENCE2|2|
|WAN, AGENCE1 ↔ AGENCE2|2|

9 subnets required

There are 6 LAN subnets and 3 WAN subnets.

## 2. Calculate the VLSM subnet masks

We use this formula:

$$2^h-2 \geq \text{Required hosts}$$

Where:

- \(h\) = number of host bits.
- 2 addresses are reserved for network and broadcast.

Then:

$$Prefix=32-h$$

Calculate each subnet:

| Required hosts | Calculation  | Prefix | Subnet mask     |
| -------------- | ------------ | ------ | --------------- |
| 50             | $$2^6-2=62$$ | /26    | 255.255.255.192 |
| 20             | $$2^5-2=30$$ | /27    | 255.255.255.224 |
| 12             | $$2^4-2=14$$ | /28    | 255.255.255.240 |
| 2              | $$2^2-2=2$$  | /30    | 255.255.255.252 |

> ‼️Important: Always allocate the largest subnet first. This is the fundamental VLSM rule.

## 3. Build the VLSM addressing plan

Start with `192.168.1.0/24`.

Allocate addresses sequentially, respecting each subnet's block size.

- /26 = 64 addresses.
    
- /27 = 32 addresses.
    
- /28 = 16 addresses.
    
- /30 = 4 addresses.
    

### Complete subnet table

|Network|Network address|First usable|Last usable|Broadcast|
|---|---|---|---|---|
|LAN 1|192.168.1.0/26|.1|.62|.63|
|LAN 2|192.168.1.64/26|.65|.126|.127|
|LAN 3|192.168.1.128/27|.129|.158|.159|
|LAN 4|192.168.1.160/27|.161|.190|.191|
|LAN 5|192.168.1.192/28|.193|.206|.207|
|LAN 6|192.168.1.208/28|.209|.222|.223|
|WAN 1|192.168.1.224/30|.225|.226|.227|
|WAN 2|192.168.1.228/30|.229|.230|.231|
|WAN 3|192.168.1.232/30|.233|.234|.235|

All addresses in the table belong to `192.168.1.x`.

## 4. Assign IP addresses to router interfaces

Now we assign the first usable IP address of each LAN to its router interface. This address becomes the default gateway.

### A. SIEGE router

According to your topology:

|Interface|Connected network|IP address|Mask|
|---|---|---|---|
|Fa0/0|PC1 LAN|192.168.1.1|/26|
|Fa0/1|PC2 LAN|192.168.1.65|/26|
|S0/0/0|AGENCE1|192.168.1.225|/30|
|S0/0/1|AGENCE2|192.168.1.229|/30|

### B. AGENCE1 router

|Interface|Connected network|IP address|Mask|
|---|---|---|---|
|Fa0/1|PC3 LAN|192.168.1.129|/27|
|Fa0/0|PC4 LAN|192.168.1.161|/27|
|S0/0/0|SIEGE|192.168.1.226|/30|
|S0/0/1|AGENCE2|192.168.1.233|/30|

### C. AGENCE2 router

|Interface|Connected network|IP address|Mask|
|---|---|---|---|
|Fa0/1|PC5 LAN|192.168.1.193|/28|
|Fa0/0|PC6 LAN|192.168.1.209|/28|
|S0/0/1|SIEGE|192.168.1.230|/30|
|S0/0/0|AGENCE1|192.168.1.234|/30|

## 5. Configure the PCs

You can assign the following addresses to the PCs.

|PC|IP address|Subnet mask|Default gateway|
|---|---|---|---|
|PC1|192.168.1.2|255.255.255.192|192.168.1.1|
|PC2|192.168.1.66|255.255.255.192|192.168.1.65|
|PC3|192.168.1.130|255.255.255.224|192.168.1.129|
|PC4|192.168.1.162|255.255.255.224|192.168.1.161|
|PC5|192.168.1.194|255.255.255.240|192.168.1.193|
|PC6|192.168.1.210|255.255.255.240|192.168.1.209|

These are example host assignments. Other available addresses in the same subnet would also work.

### 6. Addresses from `.236` to `.255` remain available.