# Windows
### Exo1
#### server_udp.c

``` c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <winsock2.h>
#include <ws2tcpip.h>

#define PORT 9090
#define BUFFER_SIZE 1024

int main() {
    WSADATA wsa;
    SOCKET server_sock;
    struct sockaddr_in server_addr, client_addr;
    int client_len = sizeof(client_addr);
    char buffer[BUFFER_SIZE];

    // 1. Initialisation Winsock
    if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0) {
        printf("[ERREUR] WSAStartup : %d\n", WSAGetLastError());
        return 1;
    }

    // 2. Création de la socket UDP (SOCK_DGRAM)
    server_sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (server_sock == INVALID_SOCKET) {
        printf("[ERREUR] Creation socket UDP : %d\n", WSAGetLastError());
        WSACleanup();
        return 1;
    }

    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    // 3. Liaison IP et Port
    if (bind(server_sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) == SOCKET_ERROR) {
        printf("[ERREUR] Bind UDP : %d\n", WSAGetLastError());
        closesocket(server_sock);
        WSACleanup();
        return 1;
    }

    printf("===================================================\n");
    printf("[SERVEUR UDP] En attente de datagrammes sur le port %d...\n", PORT);
    printf("===================================================\n");

    while (1) {
        memset(buffer, 0, BUFFER_SIZE);

        // 4. Réception du datagramme et capture de l'adresse de l'émetteur
        int bytes_received = recvfrom(server_sock, buffer, BUFFER_SIZE - 1, 0,
                                      (struct sockaddr *)&client_addr, &client_len);

        if (bytes_received == SOCKET_ERROR) {
            printf("[ERREUR] recvfrom : %d\n", WSAGetLastError());
            break;
        }

        buffer[bytes_received] = '\0';
        char client_ip[INET_ADDRSTRLEN];
        strcpy(client_ip, inet_ntoa(client_addr.sin_addr));
        int client_port = ntohs(client_addr.sin_port);

        printf("[SERVEUR UDP] Paquet recu de %s:%d -> %s\n", client_ip, client_port, buffer);

        // 5. Réponse optionnelle au client
        const char *ack_msg = "ACK_UDP: Datagramme bien recu";
        sendto(server_sock, ack_msg, (int)strlen(ack_msg), 0,
               (struct sockaddr *)&client_addr, client_len);
    }

    closesocket(server_sock);
    WSACleanup();
    return 0;
}
```

#### client_udp.c

``` c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <winsock2.h>
#include <ws2tcpip.h>

#define PORT 9090
#define BUFFER_SIZE 1024

int main() {
    WSADATA wsa;
    SOCKET sock;
    struct sockaddr_in dest_addr;
    int addr_len = sizeof(dest_addr);
    char buffer[BUFFER_SIZE];

    // 1. Initialisation Winsock
    if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0) {
        printf("[ERREUR] WSAStartup : %d\n", WSAGetLastError());
        return 1;
    }

    // 2. Création de la socket UDP (SOCK_DGRAM)
    sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock == INVALID_SOCKET) {
        printf("[ERREUR] Creation socket : %d\n", WSAGetLastError());
        WSACleanup();
        return 1;
    }

    // 3. Configuration de l'adresse de destination
    dest_addr.sin_family = AF_INET;
    dest_addr.sin_port = htons(PORT);
    dest_addr.sin_addr.s_addr = inet_addr("127.0.0.1");

    printf("===================================================\n");
    printf("[CLIENT UDP] Pret a envoyer des datagrammes au port %d\n", PORT);
    printf("Tapez votre message puis Entree (ou 'exit' pour quitter)\n");
    printf("===================================================\n");

    while (1) {
        printf("> ");
        if (!fgets(buffer, sizeof(buffer), stdin)) break;
        buffer[strcspn(buffer, "\r\n")] = '\0';

        if (strcmp(buffer, "exit") == 0) break;
        if (strlen(buffer) == 0) continue;

        // 4. Envoi direct sans connect() préalable
        int sent = sendto(sock, buffer, (int)strlen(buffer), 0,
                          (struct sockaddr *)&dest_addr, addr_len);

        if (sent == SOCKET_ERROR) {
            printf("[ERREUR] sendto echoue : %d\n", WSAGetLastError());
            continue;
        }

        printf("[CLIENT UDP] %d octets emis avec succes.\n", sent);

        // 5. Lecture de l'accuse eventuel
        memset(buffer, 0, BUFFER_SIZE);
        int received = recvfrom(sock, buffer, BUFFER_SIZE - 1, 0,
                                (struct sockaddr *)&dest_addr, &addr_len);
        if (received > 0) {
            buffer[received] = '\0';
            printf("[CLIENT UDP] Reponse : %s\n", buffer);
        }
    }

    closesocket(sock);
    WSACleanup();
    return 0;
}
```
