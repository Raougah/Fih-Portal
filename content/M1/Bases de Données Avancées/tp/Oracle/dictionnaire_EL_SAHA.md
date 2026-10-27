```sql
-- ============================================================

-- Dictionnaire de donnees automatique : EL_SAHA

-- A executer en tant que ELSAHA_ADMIN

-- Oracle Database 10g

-- ============================================================

  

SET ECHO ON

SET FEEDBACK ON

SET PAGESIZE 100

SET LINESIZE 200

  

SPOOL dictionnaire_elsaha.txt

  

PROMPT ==========================================

PROMPT 1. TABLES

PROMPT ==========================================

  

SELECT table_name

FROM user_tables

ORDER BY table_name;

  

PROMPT ==========================================

PROMPT 2. COLONNES, TYPES ET NULLABILITE

PROMPT ==========================================

  

SELECT table_name,

       column_id,

       column_name,

       data_type,

       data_length,

       nullable

FROM user_tab_columns

ORDER BY table_name, column_id;

  

PROMPT ==========================================

PROMPT 3. CONTRAINTES

PROMPT ==========================================

  

SELECT table_name,

       constraint_name,

       constraint_type,

       status

FROM user_constraints

ORDER BY table_name, constraint_type;

  

PROMPT ==========================================

PROMPT 4. DETAILS DES CLES ETRANGERES

PROMPT ==========================================

  

SELECT c.table_name,

       c.constraint_name,

       cc.column_name,

       c.r_constraint_name

FROM user_constraints c

JOIN user_cons_columns cc

  ON cc.constraint_name = c.constraint_name

WHERE c.constraint_type = 'R'

ORDER BY c.table_name, c.constraint_name;

  

PROMPT ==========================================

PROMPT 5. INDEX

PROMPT ==========================================

  

SELECT index_name, table_name, uniqueness

FROM user_indexes

ORDER BY table_name, index_name;

  

PROMPT ==========================================

PROMPT 6. SEQUENCES

PROMPT ==========================================

  

SELECT sequence_name, increment_by, last_number

FROM user_sequences

ORDER BY sequence_name;

  

PROMPT ==========================================

PROMPT 7. OBJETS ET STATUTS

PROMPT ==========================================

  

SELECT object_name, object_type, status

FROM user_objects

ORDER BY object_type, object_name;

  

SPOOL OFF

  

-- Fin du dictionnaire automatique
```