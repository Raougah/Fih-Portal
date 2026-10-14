## Recurring commands

| Task                                    | Where to run             | Command                                                                                           |
| --------------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------- |
| Select TP database for local connection | Terminal                 | `export ORACLE_SID=database_SID`                                                                  |
| Check current SID                       | Terminal                 | `echo $ORACLE_SID`                                                                                |
| Check Oracle home                       | Terminal                 | `echo $ORACLE_HOME`                                                                               |
| Start listener if stopped               | Terminal                 | `lsnrctl start`                                                                                   |
| Check listener                          | Terminal                 | `lsnrctl status`                                                                                  |
| Test TP network alias                   | Terminal                 | `tnsping EL_SAHA`                                                                                 |
| Connect locally as administrator        | Terminal                 | `sqlplus / as sysdba`                                                                             |
| Connect as TP user                      | Terminal                 | `sqlplus elsaha_admin@EL_SAHA`                                                                    |
| Start database if stopped               | SQL*Plus as SYSDBA       | `STARTUP;`                                                                                        |
| Check database name                     | SQL*Plus                 | `SELECT name FROM v$database;`                                                                    |
| Check instance status                   | SQL*Plus                 | `SELECT instance_name, status FROM v$instance;`                                                   |
| Check connected user                    | SQL*Plus                 | `SHOW USER`                                                                                       |
| Start installation log                  | SQL*Plus as ELSAHA_ADMIN | `SPOOL /home/oracle/tp_elsaha/installation_elsaha.txt`                                            |
| Stop installation log                   | SQL*Plus                 | `SPOOL OFF`                                                                                       |
| List tables                             | SQL*Plus as ELSAHA_ADMIN | `SELECT table_name FROM user_tables ORDER BY table_name;`                                         |
| List columns and data types             | SQL*Plus as ELSAHA_ADMIN | `SELECT table_name, column_name, data_type FROM user_tab_columns ORDER BY table_name, column_id;` |
| List constraints                        | SQL*Plus as ELSAHA_ADMIN | `SELECT table_name, constraint_name, constraint_type FROM user_constraints ORDER BY table_name;`  |
| List indexes                            | SQL*Plus as ELSAHA_ADMIN | `SELECT index_name, table_name FROM user_indexes ORDER BY table_name;`                            |
| List sequences                          | SQL*Plus as ELSAHA_ADMIN | `SELECT sequence_name FROM user_sequences ORDER BY sequence_name;`                                |
| Exit SQL*Plus                           | SQL*Plus                 | `EXIT;`                                                                                           |


