```sql
-- ============================================================================

-- EL_SAHA (الصحة) - TP2 PL/SQL et triggers : travail complet

-- Compte : ELSAHA_ADMIN

-- ============================================================================

SET SERVEROUTPUT ON SIZE 1000000

SET VERIFY OFF

SET FEEDBACK ON

  

-- ============================================================================

-- SPOOL : génération du fichier .txt de preuves

-- ============================================================================

SPOOL tp2_plsql.txt

  

-- ============================================================

-- A. Blocs, variables, conditions et exceptions

-- ============================================================

  

-- Exercice 1 [OBL] : F_FACTORIEL

CREATE OR REPLACE FUNCTION F_FACTORIEL(p_n IN NUMBER) RETURN NUMBER IS

    v_n   NUMBER := p_n;

    v_res NUMBER := 1;

BEGIN

    IF v_n < 0 OR MOD(v_n, 1) <> 0 THEN

        RAISE_APPLICATION_ERROR(-20001, 'n doit etre un entier positif ou nul');

    END IF;

    FOR i IN 2..TRUNC(v_n) LOOP

        v_res := v_res * i;

    END LOOP;

    RETURN v_res;

END;

/

SHOW ERRORS FUNCTION F_FACTORIEL

  

-- Tests Ex1

DECLARE v_res NUMBER;

BEGIN

    v_res := F_FACTORIEL(10);

    DBMS_OUTPUT.PUT_LINE('Factoriel de 10 = ' || v_res);

END;

/

DEFINE p_n = 5

DECLARE v_res NUMBER;

BEGIN

    v_res := F_FACTORIEL(&p_n);

    DBMS_OUTPUT.PUT_LINE('Factoriel de ' || &p_n || ' = ' || v_res);

END;

/

UNDEFINE p_n

BEGIN

    DBMS_OUTPUT.PUT_LINE('Factoriel de -3 = ' || F_FACTORIEL(-3));

EXCEPTION

    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue : ' || SQLERRM);

END;

/

  

-- Exercice 2 [OBL] : Fiche patient

DEFINE p_id_patient = 1

DECLARE

    v_nom     personne.nom%TYPE;

    v_prenom  personne.prenom%TYPE;

    v_groupe  patient.groupe_sanguin%TYPE;

    v_ville   personne.ville%TYPE;

BEGIN

    SELECT per.nom, per.prenom, pat.groupe_sanguin, per.ville

    INTO v_nom, v_prenom, v_groupe, v_ville

    FROM patient pat JOIN personne per ON per.id_personne = pat.id_personne

    WHERE pat.id_patient = &p_id_patient;

    DBMS_OUTPUT.PUT_LINE(v_nom || ' ' || v_prenom || ' - ' || v_groupe || ' - ' || v_ville);

EXCEPTION

    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Patient inexistant');

END;

/

UNDEFINE p_id_patient

  

DEFINE p_id_patient = 99999

DECLARE

    v_nom     personne.nom%TYPE;

    v_prenom  personne.prenom%TYPE;

    v_groupe  patient.groupe_sanguin%TYPE;

    v_ville   personne.ville%TYPE;

BEGIN

    SELECT per.nom, per.prenom, pat.groupe_sanguin, per.ville

    INTO v_nom, v_prenom, v_groupe, v_ville

    FROM patient pat JOIN personne per ON per.id_personne = pat.id_personne

    WHERE pat.id_patient = &p_id_patient;

    DBMS_OUTPUT.PUT_LINE(v_nom || ' ' || v_prenom);

EXCEPTION

    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Patient inexistant');

END;

/

UNDEFINE p_id_patient

  

-- Exercice 3 [OBL] : Âge et catégorie

DEFINE p_id_patient = 1

DECLARE

    v_date_naiss personne.date_naissance%TYPE;

    v_age        NUMBER;

    v_categorie  VARCHAR2(10);

BEGIN

    SELECT per.date_naissance INTO v_date_naiss

    FROM patient pat JOIN personne per ON per.id_personne = pat.id_personne

    WHERE pat.id_patient = &p_id_patient;

    v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, v_date_naiss) / 12);

    IF v_age < 18 THEN v_categorie := 'mineur';

    ELSIF v_age <= 59 THEN v_categorie := 'adulte';

    ELSE v_categorie := 'senior';

    END IF;

    DBMS_OUTPUT.PUT_LINE('Age : ' || v_age || ' - Categorie : ' || v_categorie);

END;

/

UNDEFINE p_id_patient

  

-- Exercice 4 [OBL] : SELECT INTO : 0, 1, n lignes

DECLARE v_id_patient patient.id_patient%TYPE;

BEGIN

    SELECT pat.id_patient INTO v_id_patient

    FROM patient pat JOIN personne per ON per.id_personne = pat.id_personne

    WHERE per.nom = 'NomInexistant';

EXCEPTION

    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND : aucun patient avec ce nom.');

END;

/

DECLARE

    v_id_patient patient.id_patient%TYPE;

    v_nom        personne.nom%TYPE;

BEGIN

    SELECT pat.id_patient, per.nom INTO v_id_patient, v_nom

    FROM patient pat JOIN personne per ON per.id_personne = pat.id_personne

    WHERE per.nom = 'Bensalem';

    DBMS_OUTPUT.PUT_LINE('Patient trouve : ' || v_id_patient || ' - ' || v_nom);

END;

/

DECLARE v_id_patient patient.id_patient%TYPE;

BEGIN

    SELECT pat.id_patient INTO v_id_patient

    FROM patient pat JOIN personne per ON per.id_personne = pat.id_personne

    WHERE per.ville = 'Oran';

EXCEPTION

    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS : plusieurs patients a Oran.');

END;

/

  

-- Exercice 5 [OPT] : Vendredi ou samedi

DEFINE p_date = DATE '2026-10-23'

DECLARE

    d DATE := &p_date;

    j NUMBER := TRUNC(d) - TRUNC(d, 'IW');

BEGIN

    IF j IN (4, 5) THEN

        DBMS_OUTPUT.PUT_LINE(TO_CHAR(d, 'DD/MM/YYYY') || ' -> vendredi/samedi (j=' || j || ')');

    ELSE

        DBMS_OUTPUT.PUT_LINE(TO_CHAR(d, 'DD/MM/YYYY') || ' -> autre jour (j=' || j || ')');

    END IF;

END;

/

UNDEFINE p_date

  

-- ============================================================

-- B. Curseurs

-- ============================================================

  

-- Exercice 6 [OBL] : Curseur FOR

BEGIN

    FOR r IN (

        SELECT pat.id_patient, per.nom, COUNT(c.id_consultation) AS nb_consult

        FROM patient pat

        JOIN personne per ON per.id_personne = pat.id_personne

        LEFT JOIN consultation c ON c.id_patient = pat.id_patient

        GROUP BY pat.id_patient, per.nom

        ORDER BY pat.id_patient

    ) LOOP

        DBMS_OUTPUT.PUT_LINE(r.id_patient || ' - ' || r.nom || ' : ' || r.nb_consult || ' consultation(s)');

    END LOOP;

END;

/

  

-- Exercice 7 [OBL] : Curseur paramétré

DECLARE

    CURSOR c_consult_service (

        p_id_service service.id_service%TYPE,

        p_debut      DATE,

        p_fin        DATE

    ) IS

        SELECT c.id_consultation, m.nom, c.date_consultation

        FROM consultation c JOIN medecin m ON m.id_medecin = c.id_medecin

        WHERE c.id_service = p_id_service

        AND c.date_consultation BETWEEN p_debut AND p_fin;

BEGIN

    FOR r IN c_consult_service(1, DATE '2026-09-05', DATE '2026-09-10') LOOP

        DBMS_OUTPUT.PUT_LINE(r.id_consultation || ' - Dr ' || r.nom || ' - ' || TO_CHAR(r.date_consultation, 'DD/MM/YYYY'));

    END LOOP;

END;

/

  

-- Exercice 8 [OPT] : OPEN, FETCH, CLOSE

DECLARE

    CURSOR c_stock IS

        SELECT id_medicament, nom_medicament, stock, seuil_alerte

        FROM medicament WHERE stock < seuil_alerte;

    v_id    medicament.id_medicament%TYPE;

    v_nom   medicament.nom_medicament%TYPE;

    v_stock medicament.stock%TYPE;

    v_seuil medicament.seuil_alerte%TYPE;

BEGIN

    OPEN c_stock;

    LOOP

        FETCH c_stock INTO v_id, v_nom, v_stock, v_seuil;

        EXIT WHEN c_stock%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(c_stock%ROWCOUNT || '. ' || v_nom || ' : stock=' || v_stock || ' (seuil ' || v_seuil || ')');

    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total medicaments sous seuil : ' || c_stock%ROWCOUNT);

    CLOSE c_stock;

END;

/

  

-- ============================================================

-- C. Procédures, fonctions et transactions

-- ============================================================

  

-- Exercice 9 [OBL] : P_RESUME_PATIENT

CREATE OR REPLACE PROCEDURE P_RESUME_PATIENT(p_id_patient IN patient.id_patient%TYPE) IS

    v_nom    personne.nom%TYPE;

    v_pre    personne.prenom%TYPE;

    v_nb_rdv NUMBER;

    v_nb_con NUMBER;

    v_nb_hos NUMBER;

BEGIN

    SELECT per.nom, per.prenom INTO v_nom, v_pre

    FROM patient pat JOIN personne per ON per.id_personne = pat.id_personne

    WHERE pat.id_patient = p_id_patient;

    SELECT COUNT(*) INTO v_nb_rdv FROM rendez_vous WHERE id_patient = p_id_patient;

    SELECT COUNT(*) INTO v_nb_con FROM consultation WHERE id_patient = p_id_patient;

    SELECT COUNT(*) INTO v_nb_hos FROM hospitalisation WHERE id_patient = p_id_patient;

    DBMS_OUTPUT.PUT_LINE('Patient       : ' || v_pre || ' ' || v_nom);

    DBMS_OUTPUT.PUT_LINE('Rendez-vous   : ' || v_nb_rdv);

    DBMS_OUTPUT.PUT_LINE('Consultations : ' || v_nb_con);

    DBMS_OUTPUT.PUT_LINE('Hospitalisations : ' || v_nb_hos);

EXCEPTION

    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Patient inexistant');

END;

/

SHOW ERRORS PROCEDURE P_RESUME_PATIENT

BEGIN P_RESUME_PATIENT(1); END;

/

BEGIN P_RESUME_PATIENT(99999); END;

/

  

-- Exercice 10 [OBL] : F_RESTE_FACTURE

CREATE OR REPLACE FUNCTION F_RESTE_FACTURE(p_id_facture IN facture.id_facture%TYPE) RETURN NUMBER IS

    v_total  facture.montant_total%TYPE;

    v_remise facture.remise%TYPE;

    v_paye   NUMBER;

BEGIN

    SELECT montant_total, remise INTO v_total, v_remise

    FROM facture WHERE id_facture = p_id_facture;

    SELECT NVL(SUM(montant), 0) INTO v_paye FROM paiement WHERE id_facture = p_id_facture;

    RETURN v_total * (1 - v_remise / 100) - v_paye;

EXCEPTION

    WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR(-20101, 'Facture inexistante');

END;

/

SHOW ERRORS FUNCTION F_RESTE_FACTURE

DECLARE v_reste NUMBER; BEGIN v_reste := F_RESTE_FACTURE(2);  DBMS_OUTPUT.PUT_LINE('Reste facture 2  : ' || v_reste); END;

/

DECLARE v_reste NUMBER; BEGIN v_reste := F_RESTE_FACTURE(20); DBMS_OUTPUT.PUT_LINE('Reste facture 20 : ' || v_reste); END;

/

BEGIN

    DBMS_OUTPUT.PUT_LINE('Reste facture 99999 : ' || F_RESTE_FACTURE(99999));

EXCEPTION

    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue : ' || SQLERRM);

END;

/

  

-- Exercice 11 [OBL] : P_AJOUTER_PATIENT

CREATE OR REPLACE PROCEDURE P_AJOUTER_PATIENT(

    p_nom        IN personne.nom%TYPE,

    p_prenom     IN personne.prenom%TYPE,

    p_date_naiss IN personne.date_naissance%TYPE,

    p_sexe       IN personne.sexe%TYPE,

    p_email      IN personne.email%TYPE,

    p_num_ss     IN patient.num_securite_soc%TYPE,

    p_id_patient OUT patient.id_patient%TYPE

) IS

    v_id_personne personne.id_personne%TYPE;

    v_dummy       NUMBER;

BEGIN

    IF p_email IS NOT NULL THEN

        BEGIN

            SELECT 1 INTO v_dummy FROM personne WHERE email = p_email;

            RAISE_APPLICATION_ERROR(-20111, 'Adresse e-mail deja utilisee');

        EXCEPTION

            WHEN NO_DATA_FOUND THEN NULL;

        END;

    END IF;

    IF p_num_ss IS NOT NULL THEN

        BEGIN

            SELECT 1 INTO v_dummy FROM patient WHERE num_securite_soc = p_num_ss;

            RAISE_APPLICATION_ERROR(-20112, 'Numero de securite sociale deja utilise');

        EXCEPTION

            WHEN NO_DATA_FOUND THEN NULL;

        END;

    END IF;

    SELECT seq_personne.NEXTVAL INTO v_id_personne FROM dual;

    INSERT INTO personne (id_personne, nom, prenom, date_naissance, sexe, email, date_creation)

    VALUES (v_id_personne, p_nom, p_prenom, p_date_naiss, p_sexe, p_email, SYSDATE);

    SELECT seq_patient.NEXTVAL INTO p_id_patient FROM dual;

    INSERT INTO patient (id_patient, id_personne, num_securite_soc)

    VALUES (p_id_patient, v_id_personne, p_num_ss);

END;

/

SHOW ERRORS PROCEDURE P_AJOUTER_PATIENT

DECLARE v_id NUMBER;

BEGIN

    P_AJOUTER_PATIENT('Dupont', 'Jean', DATE '2000-01-01', 'M', 'jean.dupont@test.dz', 'SS-TEST001', v_id);

    DBMS_OUTPUT.PUT_LINE('Patient ajoute : id = ' || v_id);

    ROLLBACK;

END;

/

DECLARE v_id NUMBER;

BEGIN

    P_AJOUTER_PATIENT('Dupont', 'Jean', DATE '2000-01-01', 'M', 'amine.bensalem@elsaha.dz', 'SS-TEST002', v_id);

EXCEPTION

    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue : ' || SQLERRM);

    ROLLBACK;

END;

/

  

-- Exercice 12 [OBL] : SAVEPOINT

DECLARE

    v_stock_med1 medicament.stock%TYPE;

    v_stock_med2 medicament.stock%TYPE;

    v_stock_med3 medicament.stock%TYPE;

BEGIN

    SELECT stock INTO v_stock_med1 FROM medicament WHERE id_medicament = 1;

    SELECT stock INTO v_stock_med2 FROM medicament WHERE id_medicament = 2;

    SELECT stock INTO v_stock_med3 FROM medicament WHERE id_medicament = 3;

    DBMS_OUTPUT.PUT_LINE('Avant - med1=' || v_stock_med1 || ', med2=' || v_stock_med2 || ', med3=' || v_stock_med3);

    UPDATE medicament SET stock = stock - 10 WHERE id_medicament = 1;

    UPDATE medicament SET stock = stock - 20 WHERE id_medicament = 2;

    SAVEPOINT avant_erreur;

    UPDATE medicament SET stock = -100 WHERE id_medicament = 3;

EXCEPTION

    WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('Erreur detectee : ' || SQLERRM || ' -> retour au SAVEPOINT');

        ROLLBACK TO avant_erreur;

        SELECT stock INTO v_stock_med1 FROM medicament WHERE id_medicament = 1;

        SELECT stock INTO v_stock_med3 FROM medicament WHERE id_medicament = 3;

        DBMS_OUTPUT.PUT_LINE('Apres ROLLBACK TO - med1=' || v_stock_med1 || ', med3=' || v_stock_med3);

        ROLLBACK;

END;

/

  

-- ============================================================

-- D. Triggers

-- ============================================================

  

-- Exercice 13 [OBL] : TRG_PATIENT_BIU

CREATE OR REPLACE TRIGGER TRG_PATIENT_BIU

BEFORE INSERT OR UPDATE ON patient

FOR EACH ROW

BEGIN

    UPDATE personne

    SET nom    = UPPER(TRIM(nom)),

        prenom = INITCAP(LOWER(TRIM(prenom))),

        email  = DECODE(email, NULL, NULL, LOWER(TRIM(email)))

    WHERE id_personne = :NEW.id_personne;

END;

/

SHOW ERRORS TRIGGER TRG_PATIENT_BIU

DECLARE

    v_nom  personne.nom%TYPE;

    v_pre  personne.prenom%TYPE;

    v_mail personne.email%TYPE;

BEGIN

    UPDATE personne SET nom = '  bEnSaLeM  ', prenom = '  aMiNe  ', email = '  AMINE@ELSAHA.DZ  '

    WHERE id_personne = (SELECT id_personne FROM patient WHERE id_patient = 1);

    UPDATE patient SET id_personne = id_personne WHERE id_patient = 1;

    SELECT nom, prenom, email INTO v_nom, v_pre, v_mail

    FROM personne WHERE id_personne = (SELECT id_personne FROM patient WHERE id_patient = 1);

    DBMS_OUTPUT.PUT_LINE('Nom=[' || v_nom || '] Prenom=[' || v_pre || '] Email=[' || v_mail || ']');

    ROLLBACK;

END;

/

  

-- Exercice 14 [OBL] : TRG_RDV_BIU

CREATE OR REPLACE TRIGGER TRG_RDV_BIU

BEFORE INSERT OR UPDATE ON rendez_vous

FOR EACH ROW

BEGIN

    IF INSERTING THEN

        IF :NEW.date_rdv < TRUNC(SYSDATE) THEN

            RAISE_APPLICATION_ERROR(-20201, 'Date de rendez-vous passee interdite');

        END IF;

    ELSIF UPDATING THEN

        IF :NEW.date_rdv <> :OLD.date_rdv AND :NEW.date_rdv < TRUNC(SYSDATE) THEN

            RAISE_APPLICATION_ERROR(-20201, 'Nouvelle date passee');

        END IF;

    END IF;

    IF NOT REGEXP_LIKE(:NEW.heure_rdv, '^[0-2][0-9]:[0-5][0-9]$') THEN

        RAISE_APPLICATION_ERROR(-20202, 'Heure invalide (format HH:MM attendu)');

    END IF;

    IF UPDATING AND :NEW.statut <> :OLD.statut THEN

        IF :OLD.statut IN ('ANNULE', 'REALISE', 'ABSENT') THEN

            RAISE_APPLICATION_ERROR(-20203, 'Impossible de modifier le statut d un rdv clos');

        END IF;

        IF :OLD.statut = 'CONFIRME' AND :NEW.statut = 'PLANIFIE' THEN

            RAISE_APPLICATION_ERROR(-20204, 'Retour de CONFIRME a PLANIFIE interdit');

        END IF;

    END IF;

END;

/

SHOW ERRORS TRIGGER TRG_RDV_BIU

UPDATE rendez_vous SET motif = 'Motif modifie' WHERE id_rdv = 81;

ROLLBACK;

BEGIN

    INSERT INTO rendez_vous (id_rdv, id_patient, id_medecin, id_service, date_rdv, heure_rdv, motif, statut)

    VALUES (seq_rdv.NEXTVAL, 1, 1, 1, DATE '2020-01-01', '09:00', 'Test', 'PLANIFIE');

EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur (-20201) : ' || SQLERRM); ROLLBACK;

END;

/

BEGIN

    UPDATE rendez_vous SET heure_rdv = '25:00' WHERE id_rdv = 81;

EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur (-20202) : ' || SQLERRM); ROLLBACK;

END;

/

BEGIN

    UPDATE rendez_vous SET statut = 'ANNULE' WHERE id_rdv = 1;

EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur (-20203) : ' || SQLERRM); ROLLBACK;

END;

/

BEGIN

    UPDATE rendez_vous SET statut = 'PLANIFIE' WHERE id_rdv = 71;

EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur (-20204) : ' || SQLERRM); ROLLBACK;

END;

/

  

-- Exercice 15 [OBL] : TRG_CONSULT_BI

CREATE OR REPLACE TRIGGER TRG_CONSULT_BI

BEFORE INSERT ON consultation

FOR EACH ROW

WHEN (NEW.id_rdv IS NOT NULL)

DECLARE

    v_id_patient rendez_vous.id_patient%TYPE;

    v_id_medecin rendez_vous.id_medecin%TYPE;

    v_statut     rendez_vous.statut%TYPE;

    v_nb         NUMBER;

BEGIN

    SELECT COUNT(*) INTO v_nb FROM rendez_vous WHERE id_rdv = :NEW.id_rdv;

    IF v_nb = 0 THEN RAISE_APPLICATION_ERROR(-20403, 'Rendez-vous inexistant'); END IF;

    SELECT id_patient, id_medecin, statut INTO v_id_patient, v_id_medecin, v_statut

    FROM rendez_vous WHERE id_rdv = :NEW.id_rdv;

    IF v_statut = 'ANNULE' THEN RAISE_APPLICATION_ERROR(-20402, 'Rendez-vous annule'); END IF;

    IF :NEW.id_patient <> v_id_patient OR :NEW.id_medecin <> v_id_medecin THEN

        RAISE_APPLICATION_ERROR(-20401, 'Patient ou medecin different du rdv');

    END IF;

END;

/

SHOW ERRORS TRIGGER TRG_CONSULT_BI

DECLARE v_id NUMBER;

BEGIN

    SELECT seq_consultation.NEXTVAL INTO v_id FROM dual;

    INSERT INTO consultation (id_consultation, id_rdv, id_patient, id_medecin, id_service, date_consultation, heure_consultation, motif, type_consultation, montant_honoraire)

    VALUES (v_id, 99999, 1, 1, 1, SYSDATE, '09:00', 'Test', 'NORMALE', 0);

EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur (-20403) : ' || SQLERRM); ROLLBACK;

END;

/

DECLARE v_id NUMBER;

BEGIN

    SELECT seq_consultation.NEXTVAL INTO v_id FROM dual;

    INSERT INTO consultation (id_consultation, id_rdv, id_patient, id_medecin, id_service, date_consultation, heure_consultation, motif, type_consultation, montant_honoraire)

    VALUES (v_id, 81, 17, 6, 5, SYSDATE, '14:30', 'Consultation coherente', 'NORMALE', 0);

    DBMS_OUTPUT.PUT_LINE('Consultation inseree (acceptee).');

    ROLLBACK;

END;

/

  

-- Exercice 16 [OBL] : TRG_CONSULT_AI

CREATE OR REPLACE TRIGGER TRG_CONSULT_AI

AFTER INSERT ON consultation

FOR EACH ROW

BEGIN

    IF :NEW.id_rdv IS NOT NULL THEN

        UPDATE rendez_vous SET statut = 'REALISE'

        WHERE id_rdv = :NEW.id_rdv AND statut IN ('PLANIFIE', 'CONFIRME');

    END IF;

END;

/

SHOW ERRORS TRIGGER TRG_CONSULT_AI

DECLARE

    v_id     NUMBER;

    v_statut rendez_vous.statut%TYPE;

BEGIN

    SELECT seq_consultation.NEXTVAL INTO v_id FROM dual;

    INSERT INTO consultation (id_consultation, id_rdv, id_patient, id_medecin, id_service, date_consultation, heure_consultation, motif, type_consultation, montant_honoraire)

    VALUES (v_id, 81, 17, 6, 5, SYSDATE, '14:30', 'Test', 'NORMALE', 0);

    SELECT statut INTO v_statut FROM rendez_vous WHERE id_rdv = 81;

    DBMS_OUTPUT.PUT_LINE('Statut rdv 81 : ' || v_statut);

    ROLLBACK;

END;

/

  

-- Exercice 17 [OBL] : TRG_PRESCRIPTION_STOCK

CREATE OR REPLACE TRIGGER TRG_PRESCRIPTION_STOCK

BEFORE INSERT OR UPDATE OR DELETE ON prescription

FOR EACH ROW

DECLARE

    v_stock medicament.stock%TYPE;

BEGIN

    IF DELETING THEN

        UPDATE medicament SET stock = stock + :OLD.quantite WHERE id_medicament = :OLD.id_medicament;

    ELSIF INSERTING THEN

        SELECT stock INTO v_stock FROM medicament WHERE id_medicament = :NEW.id_medicament;

        IF v_stock < :NEW.quantite THEN RAISE_APPLICATION_ERROR(-20701, 'Stock insuffisant'); END IF;

        UPDATE medicament SET stock = stock - :NEW.quantite WHERE id_medicament = :NEW.id_medicament;

    ELSIF UPDATING THEN

        IF :NEW.id_medicament <> :OLD.id_medicament THEN

            SELECT stock INTO v_stock FROM medicament WHERE id_medicament = :NEW.id_medicament;

            IF v_stock < :NEW.quantite THEN RAISE_APPLICATION_ERROR(-20701, 'Stock insuffisant'); END IF;

            UPDATE medicament SET stock = stock + :OLD.quantite WHERE id_medicament = :OLD.id_medicament;

            UPDATE medicament SET stock = stock - :NEW.quantite WHERE id_medicament = :NEW.id_medicament;

        ELSIF :NEW.quantite <> :OLD.quantite THEN

            SELECT stock INTO v_stock FROM medicament WHERE id_medicament = :NEW.id_medicament;

            IF v_stock + :OLD.quantite < :NEW.quantite THEN RAISE_APPLICATION_ERROR(-20701, 'Stock insuffisant'); END IF;

            UPDATE medicament SET stock = stock + :OLD.quantite - :NEW.quantite WHERE id_medicament = :NEW.id_medicament;

        END IF;

    END IF;

END;

/

SHOW ERRORS TRIGGER TRG_PRESCRIPTION_STOCK

DECLARE

    v_id_ordo NUMBER;

    v_stock   medicament.stock%TYPE;

BEGIN

    SELECT seq_ordonnance.NEXTVAL INTO v_id_ordo FROM dual;

    INSERT INTO ordonnance (id_ordonnance, id_consultation, date_ordonnance, commentaire)

    VALUES (v_id_ordo, 1, SYSDATE, 'Test stock');

    INSERT INTO prescription (id_ordonnance, id_medicament, posologie, quantite, instructions)

    VALUES (v_id_ordo, 1, '1/jour', 10, NULL);

    SELECT stock INTO v_stock FROM medicament WHERE id_medicament = 1;

    DBMS_OUTPUT.PUT_LINE('Medicament 1 : stock = ' || v_stock);

    ROLLBACK;

END;

/

DECLARE v_id_ordo NUMBER;

BEGIN

    SELECT seq_ordonnance.NEXTVAL INTO v_id_ordo FROM dual;

    INSERT INTO ordonnance (id_ordonnance, id_consultation, date_ordonnance, commentaire)

    VALUES (v_id_ordo, 1, SYSDATE, 'Test stock insuffisant');

    INSERT INTO prescription (id_ordonnance, id_medicament, posologie, quantite, instructions)

    VALUES (v_id_ordo, 3, '1/jour', 90, NULL);

EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur (-20701) : ' || SQLERRM); ROLLBACK;

END;

/

  

-- Exercice 18 [OBL] : TRG_FACTURE_STATUT_BU

CREATE OR REPLACE TRIGGER TRG_FACTURE_STATUT_BU

BEFORE UPDATE OF statut ON facture

FOR EACH ROW

BEGIN

    IF :OLD.statut IN ('PAYEE', 'ANNULEE') THEN

        RAISE_APPLICATION_ERROR(-20801, 'Facture payee ou annulee : statut fige');

    END IF;

    IF :OLD.statut = 'PARTIELLE' AND :NEW.statut = 'EMISE' THEN

        RAISE_APPLICATION_ERROR(-20802, 'Une facture partielle ne peut pas revenir a emise');

    END IF;

END;

/

SHOW ERRORS TRIGGER TRG_FACTURE_STATUT_BU

BEGIN

    UPDATE facture SET statut = 'ANNULEE' WHERE id_facture = 1;

EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur (-20801) : ' || SQLERRM); ROLLBACK;

END;

/

BEGIN

    UPDATE facture SET statut = 'EMISE' WHERE id_facture = 2;

EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur (-20802) : ' || SQLERRM); ROLLBACK;

END;

/

UPDATE facture SET statut = 'PAYEE' WHERE id_facture = 3;

SELECT statut FROM facture WHERE id_facture = 3;

ROLLBACK;

  

-- Exercice 19 [OBL] : TRG_FACTURE_AUDIT

CREATE OR REPLACE TRIGGER TRG_FACTURE_AUDIT

AFTER INSERT OR UPDATE OR DELETE ON facture

FOR EACH ROW

DECLARE

    v_type  journal_operation.type_operation%TYPE;

    v_cle   journal_operation.cle_ligne%TYPE;

    v_anc   journal_operation.ancienne_valeur%TYPE;

    v_nouv  journal_operation.nouvelle_valeur%TYPE;

BEGIN

    IF INSERTING THEN

        v_type := 'INSERT'; v_cle := TO_CHAR(:NEW.id_facture);

        v_nouv := 'statut=' || :NEW.statut || ', montant=' || :NEW.montant_total || ', remise=' || :NEW.remise;

    ELSIF DELETING THEN

        v_type := 'DELETE'; v_cle := TO_CHAR(:OLD.id_facture);

        v_anc := 'statut=' || :OLD.statut || ', montant=' || :OLD.montant_total || ', remise=' || :OLD.remise;

    ELSE

        v_type := 'UPDATE'; v_cle := TO_CHAR(:NEW.id_facture);

        v_anc := 'statut=' || :OLD.statut || ', montant=' || :OLD.montant_total || ', remise=' || :OLD.remise;

        v_nouv := 'statut=' || :NEW.statut || ', montant=' || :NEW.montant_total || ', remise=' || :NEW.remise;

    END IF;

    INSERT INTO journal_operation (id_journal, type_operation, nom_table, cle_ligne, ancienne_valeur, nouvelle_valeur)

    VALUES (seq_journal.NEXTVAL, v_type, 'FACTURE', v_cle, v_anc, v_nouv);

END;

/

SHOW ERRORS TRIGGER TRG_FACTURE_AUDIT

UPDATE facture SET statut = 'PAYEE' WHERE id_facture = 3;

SELECT * FROM journal_operation WHERE nom_table = 'FACTURE' AND cle_ligne = '3' ORDER BY id_journal DESC;

ROLLBACK;

  

-- Exercice 20 [OBL] : Gérer les triggers

SELECT trigger_name, table_name, triggering_event, trigger_type, status

FROM user_triggers ORDER BY table_name, trigger_name;

SELECT name, type, line, position, text FROM user_errors ORDER BY name, sequence;

ALTER TRIGGER TRG_FACTURE_STATUT_BU DISABLE;

UPDATE facture SET statut = 'ANNULEE' WHERE id_facture = 1;

SELECT statut FROM facture WHERE id_facture = 1;

ROLLBACK;

ALTER TRIGGER TRG_FACTURE_STATUT_BU ENABLE;

  

-- Exercice 21 [OPT] : TRG_HOSPIT_BIU

CREATE OR REPLACE TRIGGER TRG_HOSPIT_BIU

BEFORE INSERT OR UPDATE OF id_chambre ON hospitalisation

FOR EACH ROW

DECLARE

    v_dispo chambre.disponible%TYPE;

    v_tarif chambre.tarif_journalier%TYPE;

    v_nb    NUMBER;

BEGIN

    SELECT COUNT(*) INTO v_nb FROM chambre WHERE id_chambre = :NEW.id_chambre;

    IF v_nb = 0 THEN RAISE_APPLICATION_ERROR(-20302, 'Chambre inexistante'); END IF;

    SELECT disponible, tarif_journalier INTO v_dispo, v_tarif FROM chambre WHERE id_chambre = :NEW.id_chambre;

    IF v_dispo = 'N' THEN RAISE_APPLICATION_ERROR(-20301, 'Chambre indisponible'); END IF;

    IF :NEW.cout_journalier IS NULL THEN :NEW.cout_journalier := v_tarif; END IF;

END;

/

SHOW ERRORS TRIGGER TRG_HOSPIT_BIU

UPDATE hospitalisation SET id_chambre = 1, cout_journalier = NULL WHERE id_hospitalisation = 6;

SELECT cout_journalier FROM hospitalisation WHERE id_hospitalisation = 6;

ROLLBACK;

  

-- Exercice 22 [OPT] : TRG_SERVICE_CHEF

CREATE OR REPLACE TRIGGER TRG_SERVICE_CHEF

BEFORE INSERT OR UPDATE OF id_medecin_chef ON service

FOR EACH ROW

WHEN (NEW.id_medecin_chef IS NOT NULL)

DECLARE

    v_nb_medecin NUMBER;

    v_clinique   service.id_clinique%TYPE;

BEGIN

    SELECT COUNT(*) INTO v_nb_medecin FROM medecin WHERE id_medecin = :NEW.id_medecin_chef;

    IF v_nb_medecin = 0 THEN RAISE_APPLICATION_ERROR(-20502, 'Medecin chef inexistant'); END IF;

    SELECT m.id_clinique INTO v_clinique FROM medecin m WHERE id_medecin = :NEW.id_medecin_chef;

    IF v_clinique <> :NEW.id_clinique THEN

        RAISE_APPLICATION_ERROR(-20501, 'Medecin chef doit etre dans la clinique du service');

    END IF;

END;

/

SHOW ERRORS TRIGGER TRG_SERVICE_CHEF

UPDATE service SET id_medecin_chef = 2 WHERE id_service = 1;

ROLLBACK;

  

-- Exercice 23 [OPT] : TRG_PRESCRIPTION_PEREMPTION

CREATE OR REPLACE TRIGGER TRG_PRESCRIPTION_PEREMPTION

BEFORE INSERT ON prescription

FOR EACH ROW

DECLARE

    v_peremption medicament.date_peremption%TYPE;

BEGIN

    SELECT date_peremption INTO v_peremption FROM medicament WHERE id_medicament = :NEW.id_medicament;

    IF v_peremption IS NOT NULL AND v_peremption < TRUNC(SYSDATE) THEN

        RAISE_APPLICATION_ERROR(-20901, 'Medicament perime');

    END IF;

END;

/

SHOW ERRORS TRIGGER TRG_PRESCRIPTION_PEREMPTION

  

-- Exercice 24 [OPT] : TRG_PATIENT_AUDIT

CREATE OR REPLACE TRIGGER TRG_PATIENT_AUDIT

AFTER UPDATE ON patient

FOR EACH ROW

DECLARE

    v_modifiees VARCHAR2(400) := '';

BEGIN

    IF NVL(:OLD.groupe_sanguin,'<NULL>') <> NVL(:NEW.groupe_sanguin,'<NULL>') THEN

        v_modifiees := v_modifiees || 'groupe_sanguin, ';

    END IF;

    IF NVL(:OLD.antecedents,'<NULL>') <> NVL(:NEW.antecedents,'<NULL>') THEN

        v_modifiees := v_modifiees || 'antecedents, ';

    END IF;

    IF NVL(:OLD.allergies,'<NULL>') <> NVL(:NEW.allergies,'<NULL>') THEN

        v_modifiees := v_modifiees || 'allergies, ';

    END IF;

    IF v_modifiees IS NOT NULL THEN

        v_modifiees := RTRIM(v_modifiees, ', ');

        INSERT INTO journal_operation (id_journal, type_operation, nom_table, cle_ligne, nouvelle_valeur)

        VALUES (seq_journal.NEXTVAL, 'UPDATE', 'PATIENT', TO_CHAR(:NEW.id_patient), v_modifiees);

    END IF;

END;

/

SHOW ERRORS TRIGGER TRG_PATIENT_AUDIT

UPDATE patient SET antecedents = 'Nouvel antecedent' WHERE id_patient = 1;

SELECT * FROM journal_operation WHERE nom_table = 'PATIENT' AND cle_ligne = '1' ORDER BY id_journal DESC;

ROLLBACK;

  

-- Exercice 25 [OPT] : Table mutante - Package

CREATE OR REPLACE PACKAGE pkg_paiement_audit IS

    TYPE t_factures IS TABLE OF facture.id_facture%TYPE INDEX BY BINARY_INTEGER;

    g_factures t_factures;

    g_idx      NUMBER := 0;

    PROCEDURE ajouter_facture(p_id IN facture.id_facture%TYPE);

    PROCEDURE traiter_factures;

END pkg_paiement_audit;

/

CREATE OR REPLACE PACKAGE BODY pkg_paiement_audit IS

    PROCEDURE ajouter_facture(p_id IN facture.id_facture%TYPE) IS

    BEGIN

        g_idx := g_idx + 1;

        g_factures(g_idx) := p_id;

    END;

    PROCEDURE traiter_factures IS

        v_net    facture.montant_total%TYPE;

        v_remise facture.remise%TYPE;

        v_total  NUMBER;

    BEGIN

        FOR i IN 1..g_idx LOOP

            SELECT montant_total, remise INTO v_net, v_remise FROM facture WHERE id_facture = g_factures(i);

            SELECT NVL(SUM(montant), 0) INTO v_total FROM paiement WHERE id_facture = g_factures(i);

            IF v_total > v_net * (1 - v_remise / 100) THEN

                RAISE_APPLICATION_ERROR(-20951, 'Total paye superieur au montant net');

            END IF;

            IF v_total = v_net * (1 - v_remise / 100) THEN

                UPDATE facture SET statut = 'PAYEE' WHERE id_facture = g_factures(i);

            ELSIF v_total > 0 THEN

                UPDATE facture SET statut = 'PARTIELLE' WHERE id_facture = g_factures(i);

            END IF;

        END LOOP;

        g_idx := 0;

    END;

END pkg_paiement_audit;

/

CREATE OR REPLACE TRIGGER trg_paiement_ligne

AFTER INSERT ON paiement

FOR EACH ROW

BEGIN pkg_paiement_audit.ajouter_facture(:NEW.id_facture); END;

/

CREATE OR REPLACE TRIGGER trg_paiement_instruction

AFTER INSERT ON paiement

BEGIN pkg_paiement_audit.traiter_factures; END;

/

  

-- ============================================================================

-- SECTION 11 : TRAVAIL A RENDRE - Elements complementaires

-- ============================================================================

  

-- 1. Liste des procedures et fonctions creees

SELECT object_name, object_type, status

FROM user_objects

WHERE object_type IN ('PROCEDURE', 'FUNCTION')

ORDER BY object_type, object_name;

  

-- 2. Liste des triggers crees

SELECT trigger_name, table_name, triggering_event, trigger_type, status

FROM user_triggers

ORDER BY table_name, trigger_name;

  

-- 3. Questions theoriques :

  

-- Q1. Difference entre curseur implicite et explicite :

-- Le curseur implicite est cree automatiquement par Oracle pour chaque requete SQL

-- (attributs SQL%FOUND, SQL%ROWCOUNT...), alors que le curseur explicite est declare

-- et controle manuellement par le programmeur avec OPEN, FETCH et CLOSE.

  

-- Q2. Difference entre procedure et fonction :

-- Une fonction retourne obligatoirement une valeur via RETURN et peut etre appelee

-- dans un SELECT SQL, tandis qu'une procedure ne retourne pas de valeur directement

-- (utilise des parametres OUT) et s'appelle comme une instruction independante.

  

-- Q3. Difference entre trigger BEFORE et AFTER :

-- Un trigger BEFORE s'execute avant l'ecriture en base (ideal pour valider ou modifier

-- les donnees via :NEW), alors qu'un trigger AFTER s'execute apres (ideal pour

-- journaliser dans une autre table ou mettre a jour des totaux).

  

-- Q4. Explication de l'erreur ORA-04091 (table mutante) :

-- C'est l'erreur qui se produit quand un trigger niveau ligne tente de lire ou

-- modifier la table qui est en cours de modification par la requete SQL declenchante ;

-- le contournement classique sous Oracle 10g est d'utiliser un package pour memoriser

-- les lignes concernees (trigger ligne) puis les traiter apres l'instruction (trigger instruction).

  

-- Nettoyage final

ROLLBACK;

  

SPOOL OFF;

-- ============================================================================

-- Fin du TP2 - EL_SAHA

-- ============================================================================
```