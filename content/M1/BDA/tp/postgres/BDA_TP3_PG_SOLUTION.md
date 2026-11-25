# Partie 1
### exo1
```sql
CREATE TABLE frag_clients_identite AS SELECT id_client, nom, prenom,region FROM clients;
CREATE TABLE frag_clients_contact AS SELECT id_client, email, telephone FROM clients;

SELECT id_client, nom, prenom, region, email, telephone FROM frag_clients_identite JOIN frag_clients_contact USING (id_client);

SELECT Count(id_client) FROM frag_clients_identite JOIN frag_clients_contact USING (id_client);
```
### exo2
```sql
CREATE TABLE frag_clients_ouest AS SELECT * FROM clients WHERE region = 'Ouest';

CREATE TABLE frag_clients_centre AS SELECT * FROM clients WHERE region = 'Centre';

CREATE TABLE frag_clients_est AS SELECT * FROM clients WHERE region = 'Est';
```
```sql
SELECT COUNT(*) FROM frag_clients_ouest;
SELECT COUNT(*) FROM frag_clients_centre;
SELECT COUNT(*) FROM frag_clients_est;
```
```sql
SELECT * FROM frag_clients_ouest
UNION ALL
SELECT * FROM frag_clients_centre
UNION ALL
SELECT * FROM frag_clients_est;
```
### exo3
```sql
CREATE TABLE commandes_partitionnees (
    id_commande BIGINT NOT NULL,
    id_client INTEGER NOT NULL,
    date_commande DATE NOT NULL,
    statut VARCHAR(20) NOT NULL,
    montant_total NUMERIC(12,2) NOT NULL
) PARTITION BY RANGE (date_commande);
```

```sql
CREATE TABLE p2023 PARTITION OF commandes_partitionnees
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE p2024 PARTITION OF commandes_partitionnees
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE p2025 PARTITION OF commandes_partitionnees
FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');
```

```sql
INSERT INTO commandes_partitionnees
SELECT * FROM commandes;
```

```sql
SELECT 'p2023' AS partition, COUNT(*) FROM p2023
UNION ALL
SELECT 'p2024', COUNT(*) FROM p2024
UNION ALL
SELECT 'p2025', COUNT(*) FROM p2025;
```

```sql
SELECT * FROM commandes_partitionnees
WHERE date_commande BETWEEN '2024-01-01' AND '2024-12-31';

SELECT * FROM p2024;
```