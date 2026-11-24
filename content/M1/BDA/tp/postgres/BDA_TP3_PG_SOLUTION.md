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