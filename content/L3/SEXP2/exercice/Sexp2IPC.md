## **Exercice 1**

### Question 1:Communication unidirectionnelle avec les tubes anonymes  

Écrire un programme C qui crée deux processus : le processus père écrit le message « Bonjour, fils. Je suis ton père ! ». Le fils le récupère, puis l'affiche en utilisant un tube anonyme.

### Question 2: Communication bidirectionnelle avec les tubes anonymes  

Écrire un programme C qui permet de réaliser une communication bidirectionnelle d'informations entre un processus père et son fils via des tubes anonymes. On souhaite réaliser cette communication dans laquelle deux processus A et B s'échangent une chaîne de caractères, plus précisément :

- Le processus A envoie la chaîne "hello, je suis le processus A"
- Le processus B répond par la chaîne "hello, je suis le processus B"

---

## **Exercice 2:** Application client/serveur

Écrire deux programmes en C

- Le premier programme : un serveur écrit des messages de 64 caractères dans un tube nommé.
- Le deuxième programme : un client lit sur ce tube nommé des messages de 64 caractères et les affiche sur la sortie standard.

---

## **Exercice 3**

Écrire un programme C qui effectue une communication entre deux processus par une file de message de clé 17.

---

## **Exercice 4**

Écrire un programme C qui crée trois fils, l'un affiche les entiers de 1 à 30, le deuxième de 31 à 60 et le troisième de 61 à 90.

On veut que l'affichage soit ordonné de 1 à 90, proposer une solution via les signaux (utiliser les signaux SIGUSR1 et SIGUSR2).


# **Solution AI**

## Exo1
```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

int main() {
    int fd[2];
    pid_t pid;
    char message[] = "Bonjour, fils. Je suis ton père !";
    char buffer[100];

    if (pipe(fd) == -1) { perror("pipe"); exit(1); }

    pid = fork();
    if (pid < 0) { perror("fork"); exit(1); }

    if (pid > 0) {
        // Père : écrit dans le tube
        close(fd[0]);                              // ferme la lecture
        write(fd[1], message, strlen(message) + 1);
        close(fd[1]);
    } else {
        // Fils : lit depuis le tube
        close(fd[1]);                              // ferme l'écriture
        read(fd[0], buffer, sizeof(buffer));
        printf("Fils reçoit : %s\n", buffer);
        close(fd[0]);
    }
    return 0;
}

```

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

int main() {
    int fd_A_to_B[2];   // tube : père (A) → fils (B)
    int fd_B_to_A[2];   // tube : fils (B) → père (A)
    pid_t pid;
    char buffer[100];

    if (pipe(fd_A_to_B) == -1 || pipe(fd_B_to_A) == -1) {
        perror("pipe"); exit(1);
    }

    pid = fork();
    if (pid < 0) { perror("fork"); exit(1); }

    if (pid > 0) {
        // Processus A (père)
        close(fd_A_to_B[0]);
        close(fd_B_to_A[1]);

        char *msgA = "hello, je suis le processus A";
        write(fd_A_to_B[1], msgA, strlen(msgA) + 1);
        close(fd_A_to_B[1]);

        read(fd_B_to_A[0], buffer, sizeof(buffer));
        printf("A reçoit : %s\n", buffer);
        close(fd_B_to_A[0]);

    } else {
        // Processus B (fils)
        close(fd_A_to_B[1]);
        close(fd_B_to_A[0]);

        read(fd_A_to_B[0], buffer, sizeof(buffer));
        printf("B reçoit : %s\n", buffer);
        close(fd_A_to_B[0]);

        char *msgB = "hello, je suis le processus B";
        write(fd_B_to_A[1], msgB, strlen(msgB) + 1);
        close(fd_B_to_A[1]);
    }
    return 0;
}
```
## Exo2
```c
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <string.h>

#define FIFO_PATH "/tmp/my_fifo"
#define MSG_SIZE  64

int main() {
    char messages[][MSG_SIZE] = {
        "Message 1 : Bonjour depuis le serveur !",
        "Message 2 : Il fait beau aujourd'hui.",
        "Message 3 : Fin de transmission."
    };

    // Crée le tube nommé s'il n'existe pas
    mkfifo(FIFO_PATH, 0666);

    printf("Serveur : en attente du client...\n");
    int fd = open(FIFO_PATH, O_WRONLY);   // bloque jusqu'à ce que le client ouvre en lecture
    if (fd == -1) { perror("open"); exit(1); }

    for (int i = 0; i < 3; i++) {
        char buf[MSG_SIZE] = {0};
        strncpy(buf, messages[i], MSG_SIZE - 1);
        write(fd, buf, MSG_SIZE);
        printf("Serveur envoie : %s\n", buf);
        sleep(1);
    }

    close(fd);
    unlink(FIFO_PATH);
    printf("Serveur : terminé.\n");
    return 0;
}

```

```c
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

#define FIFO_PATH "/tmp/my_fifo"
#define MSG_SIZE  64

int main() {
    char buf[MSG_SIZE];

    int fd = open(FIFO_PATH, O_RDONLY);
    if (fd == -1) { perror("open"); exit(1); }

    printf("Client : lecture des messages...\n");
    while (read(fd, buf, MSG_SIZE) > 0) {
        printf("Client reçoit : %s\n", buf);
    }

    close(fd);
    printf("Client : terminé.\n");
    return 0;
}
```
## Exo3
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <unistd.h>

#define KEY 17

// Structure d'un message IPC
struct message {
    long mtype;       // type du message (doit être > 0)
    char mtext[100];
};

int main() {
    int msgid;
    struct message msg;
    pid_t pid;

    // Crée ou accède à la file de messages de clé 17
    msgid = msgget((key_t)KEY, IPC_CREAT | 0666);
    if (msgid == -1) { perror("msgget"); exit(1); }

    pid = fork();
    if (pid < 0) { perror("fork"); exit(1); }

    if (pid > 0) {
        // Père : envoie un message
        msg.mtype = 1;
        strcpy(msg.mtext, "Bonjour fils, message via file IPC !");
        msgsnd(msgid, &msg, sizeof(msg.mtext), 0);
        printf("Père : message envoyé.\n");
        wait(NULL);

        // Supprime la file après utilisation
        msgctl(msgid, IPC_RMID, NULL);

    } else {
        // Fils : reçoit le message
        sleep(1);   // laisse le père envoyer en premier
        msgrcv(msgid, &msg, sizeof(msg.mtext), 1, 0);
        printf("Fils reçoit : %s\n", msg.mtext);
    }
    return 0;
}
```
## Exo4
```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>

// Flags de synchronisation (volatile car modifiés par les handlers)
volatile sig_atomic_t go = 0;

void handler(int sig) {
    go = 1;   // autorise le processus à continuer
}

int main() {
    pid_t pid2, pid3;

    // Crée le fils 3 en premier pour avoir son PID
    pid3 = fork();
    if (pid3 == 0) {
        // ---- Fils 3 : affiche 61 à 90 ----
        signal(SIGUSR2, handler);
        while (!go) pause();         // attend SIGUSR2
        for (int i = 61; i <= 90; i++) printf("%d\n", i);
        fflush(stdout);
        exit(0);
    }

    // Crée le fils 2
    pid2 = fork();
    if (pid2 == 0) {
        // ---- Fils 2 : affiche 31 à 60 ----
        signal(SIGUSR1, handler);
        while (!go) pause();         // attend SIGUSR1
        for (int i = 31; i <= 60; i++) printf("%d\n", i);
        fflush(stdout);
        kill(pid3, SIGUSR2);         // réveille fils 3
        exit(0);
    }

    // ---- Fils 1 (dans le père) : affiche 1 à 30 immédiatement ----
    // On crée fils 1 explicitement
    pid_t pid1 = fork();
    if (pid1 == 0) {
        // ---- Fils 1 : affiche 1 à 30 ----
        for (int i = 1; i <= 30; i++) printf("%d\n", i);
        fflush(stdout);
        kill(pid2, SIGUSR1);         // réveille fils 2
        exit(0);
    }

    // Père : attend tous les fils (dans l'ordre de fin)
    waitpid(pid1, NULL, 0);
    waitpid(pid2, NULL, 0);
    waitpid(pid3, NULL, 0);
    printf("Père : affichage terminé.\n");
    return 0;
}
```