```sql
-- ============================================================================

-- EL_SAHA (الصحة) - TP2 PL/SQL et triggers : exemples du guide (schema MCD v4)

-- Oracle Database 10g Release 2 - a executer avec ELSAHA_ADMIN (F5 dans SQL Developer)

-- Sections 1 a 11 : PL/SQL ; sections 12 a 19 : triggers (ils sont supprimes a la fin).

-- Tous les exemples sont rejouables ; ceux qui modifient la base finissent par ROLLBACK.

-- ============================================================================

  

SET SERVEROUTPUT ON SIZE 1000000

SET VERIFY OFF

SET FEEDBACK ON

SHOW USER

  

-- 1. Premier bloc -----------------------------------------------------------

BEGIN

  DBMS_OUTPUT.PUT_LINE('Bienvenue dans EL_SAHA');

  DBMS_OUTPUT.PUT_LINE('Date : ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));

END;

/

  

-- 2. Variables, constantes, SELECT INTO ---------------------------------------

DECLARE

  v_nb_patients NUMBER := 0;

  v_message     VARCHAR2(100);

  c_base        CONSTANT VARCHAR2(20) := 'EL_SAHA';

BEGIN

  SELECT COUNT(*) INTO v_nb_patients FROM patient;

  v_message := 'Nombre de patients : ' || v_nb_patients;

  DBMS_OUTPUT.PUT_LINE(c_base || ' - ' || v_message);

END;

/

  

-- 3. Types ancres %TYPE et %ROWTYPE --------------------------------------------

DECLARE

  v_id_medecin medecin.id_medecin%TYPE := 1;

  v_nom        medecin.nom%TYPE;

  v_clinique   clinique%ROWTYPE;

BEGIN

  SELECT m.nom INTO v_nom FROM medecin m WHERE m.id_medecin = v_id_medecin;

  SELECT cl.* INTO v_clinique

  FROM clinique cl

  JOIN service s ON s.id_clinique = cl.id_clinique

  JOIN medecin m ON m.id_service = s.id_service

  WHERE m.id_medecin = v_id_medecin;

  DBMS_OUTPUT.PUT_LINE('Dr ' || v_nom || ' travaille a ' || v_clinique.nom_clinique);

END;

/

  

-- 3 bis. Sequence sous Oracle 10g : SELECT ... INTO, pas d'affectation directe ---------

DECLARE

  v_id acte.id_acte%TYPE;

BEGIN

  SELECT seq_acte.NEXTVAL INTO v_id FROM dual;      -- v_id := seq_acte.NEXTVAL est refuse en 10g

  DBMS_OUTPUT.PUT_LINE('Prochain identifiant d''acte : ' || v_id);

END;

/

  

-- 4. Valeur saisie : DEFINE puis &variable -------------------------------------

DEFINE p_id_clinique = 1

DECLARE

  v_id  clinique.id_clinique%TYPE := &p_id_clinique;

  v_nom clinique.nom_clinique%TYPE;

BEGIN

  SELECT nom_clinique INTO v_nom FROM clinique WHERE id_clinique = v_id;

  DBMS_OUTPUT.PUT_LINE('Clinique ' || v_id || ' : ' || v_nom);

END;

/

UNDEFINE p_id_clinique

  

-- 5. Conditions : IF / ELSIF / ELSE et CASE --------------------------------------

DECLARE

  v_stock  medicament.stock%TYPE;

  v_seuil  medicament.seuil_alerte%TYPE;

  v_statut VARCHAR2(30);

BEGIN

  SELECT stock, seuil_alerte INTO v_stock, v_seuil FROM medicament WHERE id_medicament = 3;

  IF v_stock = 0 THEN

    DBMS_OUTPUT.PUT_LINE('Rupture');

  ELSIF v_stock <= v_seuil THEN

    DBMS_OUTPUT.PUT_LINE('Stock critique');

  ELSE

    DBMS_OUTPUT.PUT_LINE('Stock normal');

  END IF;

  SELECT statut INTO v_statut FROM facture WHERE id_facture = 2;

  DBMS_OUTPUT.PUT_LINE(CASE v_statut

                         WHEN 'EMISE'     THEN 'Non reglee'

                         WHEN 'PARTIELLE' THEN 'Paiement partiel'

                         WHEN 'PAYEE'     THEN 'Reglee'

                         ELSE 'Autre statut'

                       END);

END;

/

  

-- 6. Boucles ------------------------------------------------------------------

BEGIN

  FOR i IN 1..5 LOOP

    DBMS_OUTPUT.PUT_LINE(i || ' au carre = ' || i * i);

  END LOOP;

END;

/

DECLARE

  v_n NUMBER := 1;

BEGIN

  WHILE v_n <= 100 LOOP

    DBMS_OUTPUT.PUT_LINE('v_n = ' || v_n);

    v_n := v_n * 10;

  END LOOP;

  LOOP

    v_n := v_n - 1000;

    EXIT WHEN v_n < 0;

  END LOOP;

  DBMS_OUTPUT.PUT_LINE('Sortie de boucle : ' || v_n);

END;

/

  

-- 7. SQL dans PL/SQL et transaction : SAVEPOINT ------------------------------------

DECLARE

  v_nb NUMBER;

BEGIN

  SAVEPOINT avant_modification;

  UPDATE rendez_vous SET statut = 'CONFIRME' WHERE statut = 'PLANIFIE';

  v_nb := SQL%ROWCOUNT;

  DBMS_OUTPUT.PUT_LINE(v_nb || ' lignes modifiees');

  ROLLBACK TO avant_modification;

  UPDATE rendez_vous SET statut = 'CONFIRME' WHERE id_rdv = 99999;

  IF SQL%NOTFOUND THEN

    DBMS_OUTPUT.PUT_LINE('Aucun rendez-vous 99999 : SQL%NOTFOUND est vrai');

  END IF;

END;

/

ROLLBACK;

  

-- 8. Exceptions predefinies et erreur metier ---------------------------------------

DEFINE p_id_medecin = 1

DECLARE

  v_nom medecin.nom%TYPE;

BEGIN

  SELECT nom INTO v_nom FROM medecin WHERE id_medecin = &p_id_medecin;

  DBMS_OUTPUT.PUT_LINE('Medecin : ' || v_nom);

EXCEPTION

  WHEN NO_DATA_FOUND THEN

    DBMS_OUTPUT.PUT_LINE('Medecin inexistant');

  WHEN TOO_MANY_ROWS THEN

    DBMS_OUTPUT.PUT_LINE('Plusieurs lignes retournees');

  WHEN OTHERS THEN

    DBMS_OUTPUT.PUT_LINE('SQLCODE = ' || SQLCODE);

    DBMS_OUTPUT.PUT_LINE('SQLERRM = ' || SQLERRM);

END;

/

UNDEFINE p_id_medecin

  

DECLARE

  e_date_passee EXCEPTION;

  v_date DATE := DATE '2020-01-01';

BEGIN

  IF v_date < TRUNC(SYSDATE) THEN

    RAISE e_date_passee;

  END IF;

EXCEPTION

  WHEN e_date_passee THEN

    DBMS_OUTPUT.PUT_LINE('Exception utilisateur : date passee');

END;

/

-- erreur attendue : ORA-20010

BEGIN

  RAISE_APPLICATION_ERROR(-20010, 'La date du rendez-vous est passee.');

END;

/

  

-- 9. Curseurs ------------------------------------------------------------------------

-- 9.1 Boucle FOR sur requete (ouverture, lecture, fermeture automatiques)

BEGIN

  FOR r IN (SELECT m.nom, COUNT(c.id_consultation) AS nb

            FROM medecin m

            LEFT JOIN consultation c ON c.id_medecin = m.id_medecin

            GROUP BY m.nom

            ORDER BY m.nom) LOOP

    DBMS_OUTPUT.PUT_LINE(r.nom || ' : ' || r.nb);

  END LOOP;

END;

/

-- 9.2 Curseur explicite parametre

DECLARE

  CURSOR c_rdv(p_id_medecin medecin.id_medecin%TYPE) IS

    SELECT id_rdv, date_rdv, statut

    FROM rendez_vous

    WHERE id_medecin = p_id_medecin

    ORDER BY date_rdv;

BEGIN

  FOR r IN c_rdv(1) LOOP

    DBMS_OUTPUT.PUT_LINE(r.id_rdv || ' - ' || TO_CHAR(r.date_rdv, 'DD/MM/YYYY') || ' - ' || r.statut);

  END LOOP;

END;

/

-- 9.3 OPEN / FETCH / CLOSE

DECLARE

  CURSOR c_cliniques IS SELECT id_clinique, nom_clinique FROM clinique ORDER BY nom_clinique;

  v_id  clinique.id_clinique%TYPE;

  v_nom clinique.nom_clinique%TYPE;

BEGIN

  OPEN c_cliniques;

  LOOP

    FETCH c_cliniques INTO v_id, v_nom;

    EXIT WHEN c_cliniques%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(c_cliniques%ROWCOUNT || '. ' || v_nom);

  END LOOP;

  CLOSE c_cliniques;

  IF NOT c_cliniques%ISOPEN THEN

    DBMS_OUTPUT.PUT_LINE('Curseur ferme');

  END IF;

END;

/

  

-- 10. Procedures et fonctions stockees ---------------------------------------------

CREATE OR REPLACE PROCEDURE p_afficher_patient(p_id_patient IN patient.id_patient%TYPE) IS

  v_nom patient.nom%TYPE;

BEGIN

  SELECT nom INTO v_nom FROM patient WHERE id_patient = p_id_patient;

  DBMS_OUTPUT.PUT_LINE(v_nom);

EXCEPTION

  WHEN NO_DATA_FOUND THEN

    DBMS_OUTPUT.PUT_LINE('Patient inexistant');

END;

/

SHOW ERRORS PROCEDURE p_afficher_patient

  

BEGIN

  p_afficher_patient(1);

  p_afficher_patient(99999);

END;

/

  

-- parametre OUT

CREATE OR REPLACE PROCEDURE p_nb_patients_ville(

  p_ville IN  patient.ville%TYPE,

  p_nb    OUT NUMBER) IS

BEGIN

  SELECT COUNT(*) INTO p_nb FROM patient WHERE ville = p_ville;

END;

/

SHOW ERRORS PROCEDURE p_nb_patients_ville

  

DECLARE

  v_nb NUMBER;

BEGIN

  p_nb_patients_ville('Oran', v_nb);

  DBMS_OUTPUT.PUT_LINE('Patients a Oran : ' || v_nb);

END;

/

  

-- parametre IN OUT : valeur fournie, modifiee, retournee

CREATE OR REPLACE PROCEDURE p_majuscules(p_texte IN OUT VARCHAR2) IS

BEGIN

  p_texte := UPPER(TRIM(p_texte));

END;

/

SHOW ERRORS PROCEDURE p_majuscules

  

DECLARE

  v_texte VARCHAR2(50) := '  el saha ';

BEGIN

  p_majuscules(v_texte);

  DBMS_OUTPUT.PUT_LINE('[' || v_texte || ']');      -- [EL SAHA]

END;

/

  

-- fonction utilisable dans SQL

CREATE OR REPLACE FUNCTION f_total_paye_facture(p_id_facture IN facture.id_facture%TYPE)

  RETURN NUMBER IS

  v_total NUMBER;

BEGIN

  SELECT NVL(SUM(montant), 0) INTO v_total FROM paiement WHERE id_facture = p_id_facture;

  RETURN v_total;

END;

/

SHOW ERRORS FUNCTION f_total_paye_facture

  

SELECT id_facture, montant_total, f_total_paye_facture(id_facture) AS total_paye

FROM facture

WHERE id_facture <= 5;

  

-- 11. Compilation et diagnostic ------------------------------------------------------

SELECT object_name, object_type, status

FROM user_objects

WHERE object_type IN ('PROCEDURE', 'FUNCTION')

ORDER BY object_type, object_name;

  

SELECT name, type, line, position, text

FROM user_errors

ORDER BY name, sequence;

  

-- 12. Syntaxe d'un trigger (exemple de la fiche) ---------------------------------------

CREATE OR REPLACE TRIGGER trg_exemple

BEFORE INSERT OR UPDATE OF cout_acte ON acte

FOR EACH ROW

WHEN (NEW.cout_acte IS NOT NULL)

BEGIN

  IF :NEW.cout_acte < 0 THEN

    RAISE_APPLICATION_ERROR(-20001, 'Cout negatif interdit');

  END IF;

END;

/

SHOW ERRORS TRIGGER trg_exemple

  

BEGIN

  UPDATE acte SET cout_acte = -1 WHERE id_acte = 1;

EXCEPTION

  WHEN OTHERS THEN

    DBMS_OUTPUT.PUT_LINE(SQLERRM);      -- ORA-20001

END;

/

ROLLBACK;

  

-- 13. Trigger avant ecriture, niveau ligne : normaliser les donnees --------------------

CREATE OR REPLACE TRIGGER trg_ex_clinique_biu

BEFORE INSERT OR UPDATE ON clinique

FOR EACH ROW

BEGIN

  :NEW.nom_clinique := UPPER(TRIM(:NEW.nom_clinique));

  :NEW.ville        := INITCAP(LOWER(TRIM(:NEW.ville)));

END;

/

SHOW ERRORS TRIGGER trg_ex_clinique_biu

  

UPDATE clinique SET ville = '  oRAN ' WHERE id_clinique = 1;

SELECT id_clinique, nom_clinique, ville FROM clinique WHERE id_clinique = 1;

ROLLBACK;

  

-- 14. Trigger apres ecriture avec clause WHEN : journaliser un changement de prix ---------

CREATE OR REPLACE TRIGGER trg_ex_acte_prix

AFTER UPDATE OF cout_acte ON acte

FOR EACH ROW

WHEN (NEW.cout_acte <> OLD.cout_acte)

BEGIN

  INSERT INTO journal_operation (id_journal, type_operation, nom_table, cle_ligne,

                                 ancienne_valeur, nouvelle_valeur)

  VALUES (seq_journal.NEXTVAL, 'UPDATE', 'ACTE', TO_CHAR(:NEW.id_acte),

          'cout=' || :OLD.cout_acte, 'cout=' || :NEW.cout_acte);

END;

/

SHOW ERRORS TRIGGER trg_ex_acte_prix

  

UPDATE acte SET cout_acte = cout_acte * 1.1 WHERE id_acte = 1;

SELECT utilisateur, type_operation, nom_table, cle_ligne, ancienne_valeur, nouvelle_valeur

FROM journal_operation ORDER BY id_journal;

UPDATE acte SET cout_acte = cout_acte WHERE id_acte = 2;      -- valeur identique : WHEN faux, pas de journal

SELECT COUNT(*) AS nb_lignes_journal FROM journal_operation;

ROLLBACK;

  

-- 15. Refuser une operation : BEFORE DELETE ----------------------------------------------

CREATE OR REPLACE TRIGGER trg_ex_acte_bd

BEFORE DELETE ON acte

FOR EACH ROW

DECLARE

  v_nb NUMBER;

BEGIN

  SELECT COUNT(*) INTO v_nb FROM acte_consultation WHERE id_acte = :OLD.id_acte;

  IF v_nb > 0 THEN

    RAISE_APPLICATION_ERROR(-20600, 'Acte utilise dans ' || v_nb || ' consultation(s)');

  END IF;

END;

/

SHOW ERRORS TRIGGER trg_ex_acte_bd

  

BEGIN

  DELETE FROM acte WHERE id_acte = 1;

EXCEPTION

  WHEN OTHERS THEN

    DBMS_OUTPUT.PUT_LINE(SQLERRM);      -- ORA-20600

END;

/

INSERT INTO acte (id_acte, nom_acte, categorie, cout_acte)

VALUES (seq_acte.NEXTVAL, 'Acte d''essai', 'Soins', 1000);

DELETE FROM acte WHERE nom_acte = 'Acte d''essai';      -- accepte : acte jamais utilise

ROLLBACK;

  

-- 16. Trigger de niveau instruction (une seule execution par ordre SQL) ----------------------

CREATE OR REPLACE TRIGGER trg_ex_acte_bs

BEFORE UPDATE ON acte

BEGIN

  DBMS_OUTPUT.PUT_LINE('Mise a jour de la table ACTE par ' || USER);

END;

/

UPDATE acte SET categorie = categorie;      -- le message s'affiche une fois, pour toutes les lignes

ROLLBACK;

  

-- 17. Distinguer l'evenement : INSERTING, UPDATING, DELETING ---------------------------

CREATE OR REPLACE TRIGGER trg_ex_acte_evt

BEFORE INSERT OR UPDATE OF categorie OR DELETE ON acte

FOR EACH ROW

BEGIN

  IF INSERTING THEN

    DBMS_OUTPUT.PUT_LINE('Insertion de ' || :NEW.nom_acte);

  ELSIF UPDATING THEN

    DBMS_OUTPUT.PUT_LINE('Modification de ' || :OLD.nom_acte);

  ELSE

    DBMS_OUTPUT.PUT_LINE('Suppression de ' || :OLD.nom_acte);

  END IF;

END;

/

SHOW ERRORS TRIGGER trg_ex_acte_evt

  

INSERT INTO acte (id_acte, nom_acte, categorie, cout_acte)

VALUES (seq_acte.NEXTVAL, 'Acte d''essai 2', 'Soins', 500);

UPDATE acte SET categorie = 'Imagerie' WHERE nom_acte = 'Acte d''essai 2';

DELETE FROM acte WHERE nom_acte = 'Acte d''essai 2';

ROLLBACK;

  

-- 18. Table mutante : un trigger ligne ne lit pas la table qu'il modifie -----------------------

CREATE OR REPLACE TRIGGER trg_ex_acte_mutant

BEFORE UPDATE ON acte

FOR EACH ROW

DECLARE

  v_nb NUMBER;

BEGIN

  SELECT COUNT(*) INTO v_nb FROM acte;

END;

/

BEGIN

  UPDATE acte SET categorie = categorie WHERE id_acte = 1;

EXCEPTION

  WHEN OTHERS THEN

    DBMS_OUTPUT.PUT_LINE(SQLERRM);      -- ORA-04091 : la table ACTE est en cours de modification

END;

/

ROLLBACK;

  

-- 19. Gerer les triggers ---------------------------------------------------------------------

SELECT trigger_name, table_name, triggering_event, trigger_type, status

FROM user_triggers

ORDER BY table_name, trigger_name;

  

SELECT name, line, text FROM user_errors WHERE type = 'TRIGGER';

  

ALTER TRIGGER trg_ex_acte_mutant DISABLE;

UPDATE acte SET categorie = categorie WHERE id_acte = 1;      -- plus d'erreur

ROLLBACK;

ALTER TRIGGER trg_ex_acte_mutant ENABLE;

  

-- nettoyage des triggers d'exemple

DROP TRIGGER trg_exemple;

DROP TRIGGER trg_ex_acte_evt;

DROP TRIGGER trg_ex_clinique_biu;

DROP TRIGGER trg_ex_acte_prix;

DROP TRIGGER trg_ex_acte_bd;

DROP TRIGGER trg_ex_acte_bs;

DROP TRIGGER trg_ex_acte_mutant;
```