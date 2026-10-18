## Linux
#### Server
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 8080
#define BUFFER_SIZE 1024

int main(void) {
    int server_fd, new_socket;
    struct sockaddr_in address;
    socklen_t addrlen = sizeof(address);
    char buffer[BUFFER_SIZE] = {0};

    const char *ack_message =
        "ACK_SERVER: Trame recue avec succes.";

    // 1. Création de la socket IPv4, flux TCP
    server_fd = socket(AF_INET, SOCK_STREAM, 0);

    if (server_fd == -1) {
        perror("[ERREUR] Echec creation de socket");
        return 1;
    }

    // Permet de réutiliser rapidement le port après fermeture
    int opt = 1;
    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR,
                   &opt, sizeof(opt)) == -1) {
        perror("[ERREUR] setsockopt");
        close(server_fd);
        return 1;
    }

    // 2. Configuration de l'adresse d'écoute
    memset(&address, 0, sizeof(address));
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    // 3. Liaison de la socket à l'adresse et au port
    if (bind(server_fd, (struct sockaddr *)&address,
             sizeof(address)) == -1) {
        perror("[ERREUR] Echec du bind");
        close(server_fd);
        return 1;
    }

    // 4. Mise en mode écoute
    if (listen(server_fd, 3) == -1) {
        perror("[ERREUR] Echec de listen");
        close(server_fd);
        return 1;
    }

    printf("==========================================\n");
    printf("[SERVEUR] En attente de connexion sur le port %d...\n",
           PORT);
    printf("==========================================\n");

    // 5. Acceptation de la connexion
    new_socket = accept(server_fd,
                        (struct sockaddr *)&address, &addrlen);

    if (new_socket == -1) {
        perror("[ERREUR] Echec accept");
        close(server_fd);
        return 1;
    }

    printf("[SERVEUR] Connexion entrante acceptee !\n");

    // 6. Réception des données
    ssize_t bytes_received =
        recv(new_socket, buffer, BUFFER_SIZE - 1, 0);

    if (bytes_received > 0) {
        buffer[bytes_received] = '\0';
        printf("[SERVEUR] Donnees recues : %s\n", buffer);

        // 7. Envoi de l'accusé de réception
        if (send(new_socket, ack_message,
                 strlen(ack_message), 0) == -1) {
            perror("[ERREUR] Echec send");
        } else {
            printf("[SERVEUR] Accuse de reception envoye au client.\n");
        }
    } else if (bytes_received == 0) {
        printf("[SERVEUR] Le client a ferme la connexion.\n");
    } else {
        perror("[ERREUR] Echec recv");
    }

    // 8. Fermeture des sockets
    close(new_socket);
    close(server_fd);

    return 0;
}
```
#### Client
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 8080
#define BUFFER_SIZE 1024

int main(void) {
    int sock;
    struct sockaddr_in serv_addr;
    char buffer[BUFFER_SIZE] = {0};

    // Trame simulant le capteur du TD1
    const char *sensor_payload =
        "ID=S01; Temp=28.5C; Humidity=63%; Time=10:30:00";

    // 1. Création de la socket
    sock = socket(AF_INET, SOCK_STREAM, 0);

    if (sock == -1) {
        perror("[ERREUR] Creation de la socket");
        return 1;
    }

    // 2. Configuration de la destination
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);

    if (inet_pton(AF_INET, "127.0.0.1",
                  &serv_addr.sin_addr) != 1) {
        fprintf(stderr, "[ERREUR] Adresse IP invalide.\n");
        close(sock);
        return 1;
    }

    // 3. Demande de connexion au serveur
    if (connect(sock, (struct sockaddr *)&serv_addr,
                sizeof(serv_addr)) == -1) {
        perror("[ERREUR] Connexion refusee. Le serveur est-il lance ?");
        close(sock);
        return 1;
    }

    printf("[CLIENT] Connecte avec succes au serveur !\n");

    // 4. Envoi de la trame
    if (send(sock, sensor_payload,
             strlen(sensor_payload), 0) == -1) {
        perror("[ERREUR] Echec send");
        close(sock);
        return 1;
    }

    printf("[CLIENT] Trame emise : %s\n", sensor_payload);

    // 5. Réception de la réponse du serveur
    ssize_t bytes_received =
        recv(sock, buffer, BUFFER_SIZE - 1, 0);

    if (bytes_received > 0) {
        buffer[bytes_received] = '\0';
        printf("[CLIENT] Reponse du serveur : %s\n", buffer);
    } else if (bytes_received == 0) {
        printf("[CLIENT] Le serveur a ferme la connexion.\n");
    } else {
        perror("[ERREUR] Echec recv");
    }

    // 6. Fermeture de la session
    close(sock);

    return 0;
}
```
## Windows
#### Server
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <winsock2.h>
#include <ws2tcpip.h>

#define PORT 8080
#define BUFFER_SIZE 1024

int main() {
    WSADATA wsa;
    SOCKET server_fd, new_socket;
    struct sockaddr_in address;
    int addrlen = sizeof(address);
    char buffer[BUFFER_SIZE] = {0};
    const char *ack_message = "ACK_SERVER: Trame recue avec succes.";

    // 1. Initialisation de la bibliothèque réseau Winsock
    if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0) {
        printf("[ERREUR] Echec de l'initialisation Winsock : %d\n",
               WSAGetLastError());
        return 1;
    }

    // 2. Création de la socket IPv4, flux TCP
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == INVALID_SOCKET) {
        printf("[ERREUR] Echec creation de socket : %d\n",
               WSAGetLastError());
        WSACleanup();
        return 1;
    }

    // Configuration de l'adresse d'écoute
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    // 3. Liaison de la socket à l'adresse et au port
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address))
        == SOCKET_ERROR) {
        printf("[ERREUR] Echec du bind : %d\n", WSAGetLastError());
        closesocket(server_fd);
        WSACleanup();
        return 1;
    }

    // 4. Mise en mode écoute
    if (listen(server_fd, 3) == SOCKET_ERROR) {
        printf("[ERREUR] Echec de listen : %d\n", WSAGetLastError());
        closesocket(server_fd);
        WSACleanup();
        return 1;
    }

    printf("==========================================\n");
    printf("[SERVEUR] En attente de connexion sur le port %d...\n", PORT);
    printf("==========================================\n");

    // 5. Acceptation de la connexion
    if ((new_socket = accept(server_fd,
            (struct sockaddr *)&address, &addrlen)) == INVALID_SOCKET) {
        printf("[ERREUR] Echec accept : %d\n", WSAGetLastError());
        closesocket(server_fd);
        WSACleanup();
        return 1;
    }

    printf("[SERVEUR] Connexion entrante acceptee !\n");

    // 6. Lecture des données envoyées par le client
    int bytes_received = recv(new_socket, buffer, BUFFER_SIZE - 1, 0);
    if (bytes_received > 0) {
        buffer[bytes_received] = '\0';
        printf("[SERVEUR] Donnees recues : %s\n", buffer);
    }

    // 7. Envoi de l'accusé de réception
    send(new_socket, ack_message, (int)strlen(ack_message), 0);
    printf("[SERVEUR] Accuse de reception envoye au client.\n");

    // 8. Fermeture des sockets
    closesocket(new_socket);
    closesocket(server_fd);
    WSACleanup();

    return 0;
}
```
#### Client

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <winsock2.h>
#include <ws2tcpip.h>

#define PORT 8080
#define BUFFER_SIZE 1024

int main() {
    WSADATA wsa;
    SOCKET sock;
    struct sockaddr_in serv_addr;
    char buffer[BUFFER_SIZE] = {0};

    // Trame simulant le capteur du TD1
    const char *sensor_payload =
        "ID=S01; Temp=28.5C; Humidity=63%; Time=10:30:00";

    // 1. Initialisation Winsock
    if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0) {
        printf("[ERREUR] Initialisation Winsock : %d\n",
               WSAGetLastError());
        return 1;
    }

    // 2. Création de la socket
    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) == INVALID_SOCKET) {
        printf("[ERREUR] Creation de la socket : %d\n",
               WSAGetLastError());
        WSACleanup();
        return 1;
    }

    // Configuration de la destination
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);
    serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");

    // 3. Demande de connexion au serveur
    if (connect(sock, (struct sockaddr *)&serv_addr,
                sizeof(serv_addr)) == SOCKET_ERROR) {
        printf("[ERREUR] Connexion refusee. Le serveur est-il lance ? (%d)\n",
               WSAGetLastError());
        closesocket(sock);
        WSACleanup();
        return 1;
    }

    printf("[CLIENT] Connecte avec succes au serveur !\n");

    // 4. Envoi de la trame
    send(sock, sensor_payload, (int)strlen(sensor_payload), 0);
    printf("[CLIENT] Trame emise : %s\n", sensor_payload);

    // 5. Réception de la réponse
    int bytes_received = recv(sock, buffer, BUFFER_SIZE - 1, 0);
    if (bytes_received > 0) {
        buffer[bytes_received] = '\0';
        printf("[CLIENT] Reponse du serveur : %s\n", buffer);
    }

    // 6. Fermeture de la session
    closesocket(sock);
    WSACleanup();

    return 0;
}
```

#### Compile command in windows

```bash
gcc server.c -o server.exe -lws2_32 
gcc client.c -o client.exe -lws2_32
```