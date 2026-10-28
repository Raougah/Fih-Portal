## admin_tp0.sql

```sql
-- =====================================================================

-- TP No 0 - Installation and administration of Oracle 10g

-- File     : admin_tp0.sql

-- Pair     : mekibes_besghire

-- Database : ORCL (instance orcl, Oracle Database 10g Release 2 10.2.0.1.0)

-- Note     : all commands below were executed in SQL*Plus as shown in the

--            SPOOL file tp0_mekibes_besghire.txt. Passwords are replaced

--            by placeholders on purpose.

-- =====================================================================

  

-- ---------------------------------------------------------------------

-- 9. SQL*Plus basics

-- ---------------------------------------------------------------------

-- Connection (done before SPOOL was started), password typed at the prompt:

--   CONNECT system@ORCL

  

-- Start recording the session

SPOOL tp0_mekibes_besghire.txt

  

-- Show the current user (expected: SYSTEM)

SHOW USER

  

-- Show all SQL*Plus environment settings (linesize, pagesize, serveroutput...)

SHOW ALL

  

-- Syntax help for the CONNECT command

HELP CONNECT

  

-- Run a query, then test the SQL buffer

SELECT name FROM v$database;

  

-- LIST displays the content of the SQL buffer (last SQL statement) without running it

LIST

  

-- "/" executes the statement stored in the SQL buffer

/

  

-- ---------------------------------------------------------------------

-- 10. Identify the database and the instance

-- ---------------------------------------------------------------------

-- Database name and open mode (ORCL, READ WRITE)

SELECT name, open_mode

FROM v$database;

  

-- Instance name, status, host and version (orcl, OPEN, 10.2.0.1.0)

SELECT instance_name, status, host_name, version

FROM v$instance;

  

-- Full version banner of the Oracle components

SELECT *

FROM v$version;

  

-- ---------------------------------------------------------------------

-- 11. Working tablespace CLINIQUE_TS

-- ---------------------------------------------------------------------

  

-- Creation attempt

CREATE TABLESPACE clinique_ts

DATAFILE 'C:\ORACLE\PRODUCT\10.2.0\ORADATA\ORCL\clinique01.dbf'

SIZE 100M

AUTOEXTEND ON NEXT 10M

MAXSIZE 500M;

  

-- check the tablespace

SELECT tablespace_name, status, contents

FROM dba_tablespaces

WHERE tablespace_name = 'CLINIQUE_TS';

  

-- Its data file (100 MB = 104857600 bytes)

SELECT tablespace_name, file_name, bytes

FROM dba_data_files

WHERE tablespace_name = 'CLINIQUE_TS';

  

-- ---------------------------------------------------------------------

-- 12. Working account CLINIQUE_DEV

-- ---------------------------------------------------------------------

-- Creation attempt

CREATE USER clinique_dev

IDENTIFIED BY <temporary_password>

DEFAULT TABLESPACE clinique_ts

TEMPORARY TABLESPACE temp

QUOTA UNLIMITED ON clinique_ts

ACCOUNT UNLOCK;

  

-- Check the account (status OPEN, default tablespace CLINIQUE_TS)

SELECT username, account_status, default_tablespace

FROM dba_users

WHERE username = 'CLINIQUE_DEV';

  

-- 12.1 Grant only the necessary system privileges (least privilege, no DBA role)

GRANT CREATE SESSION   TO clinique_dev;   -- required to connect

GRANT CREATE TABLE     TO clinique_dev;

GRANT CREATE VIEW      TO clinique_dev;

GRANT CREATE SEQUENCE  TO clinique_dev;

GRANT CREATE PROCEDURE TO clinique_dev;

GRANT CREATE TRIGGER   TO clinique_dev;

  

-- 12.2 Test the account

CONNECT clinique_dev

SHOW USER

  

-- ---------------------------------------------------------------------

-- 13. First object created by CLINIQUE_DEV

-- ---------------------------------------------------------------------

CREATE TABLE test_installation (

    id_test     NUMBER(3)

        CONSTRAINT pk_test_installation PRIMARY KEY,

    description VARCHAR2(100) NOT NULL,

    date_test   DATE DEFAULT SYSDATE

);

  

INSERT INTO test_installation (id_test, description)

VALUES (1, 'Installation Oracle valide');

  

COMMIT;

  

-- Structure and content of the table

DESCRIBE test_installation

  

SELECT *

FROM test_installation;

  

-- Tables of the current schema (only TEST_INSTALLATION)

SELECT table_name

FROM user_tables

ORDER BY table_name;

  

-- ---------------------------------------------------------------------

-- 14. Basic account administration (as SYSTEM)

-- ---------------------------------------------------------------------

CONNECT system

  

-- Lock the account

ALTER USER clinique_dev ACCOUNT LOCK;

  

-- Login must now fail with ORA-28000: the account is locked

CONNECT clinique_dev

  

-- Reconnect as the administrator and unlock the account

CONNECT system

ALTER USER clinique_dev ACCOUNT UNLOCK;

  

-- Change the password

ALTER USER clinique_dev

IDENTIFIED BY <new_password>;

  

-- System privileges granted to the account (6 rows)

SELECT grantee, privilege

FROM dba_sys_privs

WHERE grantee = 'CLINIQUE_DEV'

ORDER BY privilege;

  

-- ---------------------------------------------------------------------

-- 15. Script execution (run as SYSTEM, 141 tables listed)

-- ---------------------------------------------------------------------

@controle_tp0.sql

  

-- Stop recording

SPOOL OFF
```

## controle_tp0.sql

```sql
SET SERVEROUTPUT ON

SHOW USER

SELECT name FROM v$database;

SELECT instance_name, status FROM v$instance;

SELECT table_name

FROM user_tables

ORDER BY table_name;
```

## Answers
### 9.2 SQL*Plus Basics

#### Role of the SQL*Plus Buffer, and Difference Between LIST and /

The SQL buffer stores the last SQL statement typed (SQL*Plus commands such as SHOW are not stored in it). `LIST` displays the content of the buffer without executing it. The `/` command executes the statement currently stored in the buffer. In our session, `LIST` showed `SELECT name FROM v$database` and `/` ran it again, returning `ORCL`.

---

## 10 Identify the Database and the Instance

1. **What is the name of the database?**  
   ORCL.

2. **What is the name of the instance?**  
   orcl.

3. **What is the status of the instance?**  
   OPEN (the database open mode is READ WRITE).

4. **Which Oracle version is installed?**  
   Oracle Database 10g Enterprise Edition Release 10.2.0.1.0 - Production (TNS for 32-bit Windows).

5. **What is the difference between an Oracle database and an Oracle instance?**  
   The database is the set of physical files stored on disk (data files, control files, redo log files). The instance is the set of memory structures (the SGA – System Global Area) and background processes that Oracle starts in order to access and manage the database. An instance opens one database, and without an instance the files cannot be used.

---

## 12.2 Account Test

**Why should CLINIQUE_DEV not receive the DBA role?**

The DBA (Database Administrator) role grants almost all system privileges: creating or dropping users, reading and modifying the data of every schema, and so on. A mistake or a compromise of that account would affect the whole database. Following the principle of least privilege, CLINIQUE_DEV only receives `CREATE SESSION`, `CREATE TABLE`, `CREATE VIEW`, `CREATE SEQUENCE`, `CREATE PROCEDURE` and `CREATE TRIGGER`.

---

## 17 Synthesis Questions

1. **What is the difference between a database, an instance, a service and a schema?**  
   - **Database:** the physical storage files.  
   - **Instance:** the memory structures and processes that operate on the database.  
   - **Service:** the logical name that clients use to connect through the listener (for example ORCL, defined in `tnsnames.ora`).  
   - **Schema:** the collection of objects (tables, views, sequences, etc.) owned by a user, with the same name as that user.

2. **Why can a user not connect without CREATE SESSION?**  
   `CREATE SESSION` is the system privilege that allows a user to log in. Without it, the account exists but the connection is refused (`ORA-01045: user lacks CREATE SESSION privilege`).

3. **What is the role of a tablespace?**  
   A tablespace is a logical storage unit that links database objects (tables, indexes) to the physical data files. It lets the administrator control where data is stored, set user quotas, and manage space, backup and maintenance by groups of objects.

4. **What is the difference between a system privilege and an object privilege?**  
   A system privilege gives the right to perform an action on the database or on a type of object, for example `CREATE TABLE` or `CREATE USER`. An object privilege gives the right to perform an action on one specific object, for example `SELECT` on a given table or `EXECUTE` on a given procedure.

5. **Why should SYSTEM be avoided for ordinary work?**  
   SYSTEM is a powerful administrative account. Using it for everyday work exposes the database to accidental or malicious damage, and mixes user objects with administrative ones. A dedicated account with limited privileges, such as CLINIQUE_DEV, is safer and cleaner.

6. **Why is the principle of least privilege important for a medical database?**  
   A medical database holds sensitive and confidential patient data. Giving each account only the privileges it needs limits the exposure of that data, reduces the impact of errors, misuse or a compromised account, and makes access easier to audit and justify.

7. **What is the benefit of SPOOL in an administration lab?**  
   `SPOOL` records everything displayed during the session in a file. It provides proof of the commands executed and their results, keeps a trace that can be reviewed or reproduced, and produces the output file that has to be submitted.