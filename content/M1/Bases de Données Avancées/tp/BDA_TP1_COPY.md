### Verification
```sql
SELECT name, open_mode FROM v$database; 
```

```sql
SELECT instance_name, status, host_name, version FROM v$instance; 
```

```sql
SELECT parameter,value FROM nls_database_parameters WHERE parameter IN ('NLS_CHARACTERSET','NLS_NCHAR_CHARACTERSET'); 
```

```sql
SELECT value FROM v$parameter WHERE name = 'service_names';
```
### Creation tablespace
```sql
SELECT tablespace_name, file_name FROM dba_data_files ORDER BY tablespace_name;
```

```sql
CREATE TABLESPACE elsaha_ts DATAFILE '/home/oracle/tp_elsaha/elsaha01.dbf' SIZE 200M AUTOEXTEND ON NEXT 20M MAXSIZE 2G;
```
### Creation user avec mdp oracleTP
```sql
CREATE USER elsaha_admin IDENTIFIED BY oracleTP DEFAULT TABLESPACE elsaha_ts TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON elsaha_ts ACCOUNT UNLOCK;
```
### Permission
```sql
GRANT CREATE SESSION TO elsaha_admin; 
``` 

```sql 
GRANT CREATE TABLE TO elsaha_admin; 
``` 

```sql 
GRANT CREATE VIEW TO elsaha_admin; 
``` 

```sql 
GRANT CREATE SEQUENCE TO elsaha_admin; 
``` 

```sql 
GRANT CREATE PROCEDURE TO elsaha_admin; 
``` 

```sql 
GRANT CREATE TRIGGER TO elsaha_admin; 
``` 

```sql 
GRANT CREATE SYNONYM TO elsaha_admin; 
```

### verification
```sql
SELECT username, account_status, default_tablespace FROM dba_users WHERE username = 'ELSAHA_ADMIN';
```

```sql
SELECT grantee, privilege FROM dba_sys_privs WHERE grantee = 'ELSAHA_ADMIN' ORDER BY privilege;
```

### Creation tables

```sql
SPOOL installation_elsaha.txt
```

```sql
@/home/oracle/01_creation_EL_SAHA.sql
```

```sql
@/home/oracle/02_peupler_EL_SAHA.sql
```

```sql
SPOOL OFF
```

### Controle

```sql
SELECT COUNT(*) AS nb_tables FROM user_tables;
```

```sql
SELECT COUNT(*) AS nb_sequences FROM user_sequences;
```

```sql
SELECT object_type, status, COUNT(*) AS nombre FROM user_objects GROUP BY object_type, status ORDER BY object_type, status;
```

```sql
SELECT table_name, num_rows FROM user_tables ORDER BY table_name;
```

```sql
SELECT 'CLINIQUE' table_nom, COUNT(*) nombre FROM clinique
UNION ALL SELECT 'PERSONNE', COUNT(*) FROM personne
UNION ALL SELECT 'PATIENT', COUNT(*) FROM patient
UNION ALL SELECT 'MEDECIN', COUNT(*) FROM medecin
UNION ALL SELECT 'SERVICE', COUNT(*) FROM service
UNION ALL SELECT 'RENDEZ_VOUS', COUNT(*) FROM rendez_vous
UNION ALL SELECT 'CONSULTATION', COUNT(*) FROM consultation
UNION ALL SELECT 'HOSPITALISATION', COUNT(*) FROM hospitalisation
UNION ALL SELECT 'FACTURE', COUNT(*) FROM facture
UNION ALL SELECT 'PAIEMENT', COUNT(*) FROM paiement;
```