-- ============================================================================
-- EL_SAHA - TP2 PL/SQL et triggers - FICHIER DE TESTS COMPLET (exercices 1 a 25)
-- Schema MCD v4 (scripts 01_creation_EL_SAHA.sql et 02_peupler_EL_SAHA.sql du TP1)
-- Compte : ELSAHA_ADMIN
--
-- UTILISATION
--   1. Se connecter avec ELSAHA_ADMIN.
--   2. Copier-coller un exercice a la fois (du commentaire "EXERCICE ..." jusqu'au
--      dernier "/" de ses tests), ou executer tout le fichier avec F5.
--   3. Chaque test qui modifie la base se termine par ROLLBACK : la base revient
--      a son etat initial. Les CREATE OR REPLACE (DDL) valident la transaction :
--      c'est pour cela que chaque test se termine avant le CREATE suivant.
--   4. Les programmes, packages et triggers crees restent dans le schema (demande
--      par le TP). Le bloc de nettoyage ci-dessous permet de rejouer le script.
--   5. Pour produire la trace demandee dans le TP, decommenter les 2 lignes SPOOL
--      au debut et a la fin du script.
--
-- REMARQUES SUR LE SCHEMA REEL
--   * NOM, PRENOM, ADRESSE, VILLE, TELEPHONE et EMAIL sont dans PERSONNE.
--     PATIENT ne contient que les donnees propres au patient.
--   * MEDECIN ne contient pas NOM : on joint PERSONNE via ID_PERSONNE.
--   * HOSPITALISATION a une FK composite (ID_CHAMBRE, ID_SERVICE) : quand on
--     change de chambre, il faut aussi fournir le service de cette chambre.
--   * Les colonnes a normaliser de l'exercice 13 (nom, prenom, email) sont dans
--     PERSONNE : le trigger TRG_PATIENT_BIU est donc cree sur PERSONNE (le nom
--     demande par le TP est conserve). Cela evite aussi un trigger imbrique
--     sur PATIENT qui generait l'audit de l'exercice 24.
-- ============================================================================

-- SPOOL tp2_plsql_EL_SAHA.txt

SET SERVEROUTPUT ON SIZE 1000000
SET VERIFY OFF
SET FEEDBACK ON
SET LINESIZE 200
SET PAGESIZE 100

PROMPT ============================================================
PROMPT  NETTOYAGE OPTIONNEL DES OBJETS DU TP2 (pour rejouer le script)
PROMPT ============================================================
BEGIN
  FOR t IN (
    SELECT trigger_name FROM user_triggers
     WHERE trigger_name IN (
       'TRG_PATIENT_BIU', 'TRG_RDV_BIU', 'TRG_CONSULT_BI', 'TRG_CONSULT_AI',
       'TRG_PRESCRIPTION_STOCK', 'TRG_FACTURE_STATUT_BU', 'TRG_FACTURE_AUDIT',
       'TRG_HOSPIT_BIU', 'TRG_SERVICE_CHEF', 'TRG_PRESCRIPTION_PEREMPTION',
       'TRG_PATIENT_AUDIT', 'TRG_PERSONNE_PATIENT_AUDIT',
       'TRG_PAIEMENT_LIGNE', 'TRG_PAIEMENT_INSTRUCTION', 'TRG_PAIEMENT_MUTANT'
     )
  ) LOOP
    EXECUTE IMMEDIATE 'DROP TRIGGER ' || t.trigger_name;
  END LOOP;

  FOR p IN (
    SELECT object_name FROM user_objects
     WHERE object_type = 'PACKAGE' AND object_name = 'PKG_PAIEMENT_AUDIT'
  ) LOOP
    EXECUTE IMMEDIATE 'DROP PACKAGE ' || p.object_name;
  END LOOP;
END;
/

PROMPT ============================================================
PROMPT  A. BLOCS, VARIABLES, CONDITIONS ET EXCEPTIONS
PROMPT ============================================================

-- ############################################################################
-- EXERCICE 1 [OBL] : F_FACTORIEL
-- Ecrire F_FACTORIEL(n) (-20001 si n negatif ou non entier), afficher
-- F_FACTORIEL(10), puis le factoriel d'une valeur saisie avec DEFINE.
-- ############################################################################

CREATE OR REPLACE FUNCTION F_FACTORIEL (p_n IN NUMBER) RETURN NUMBER IS
  v_n   NUMBER := p_n;
  v_res NUMBER := 1;
BEGIN
  IF v_n < 0 OR MOD(v_n, 1) <> 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'n doit etre un entier positif ou nul');
  END IF;

  FOR i IN 2 .. TRUNC(v_n) LOOP
    v_res := v_res * i;
  END LOOP;

  RETURN v_res;
END;
/
SHOW ERRORS FUNCTION F_FACTORIEL

-- Test 1.1 : valeur normale
DECLARE
  v_res NUMBER;
BEGIN
  v_res := F_FACTORIEL(10);
  DBMS_OUTPUT.PUT_LINE('Factoriel de 10 = ' || v_res);
END;
/
-- Resultat attendu : Factoriel de 10 = 3628800

-- Test 1.2 : valeur saisie avec DEFINE
DEFINE p_n = 5
DECLARE
  v_res NUMBER;
BEGIN
  v_res := F_FACTORIEL(&p_n);
  DBMS_OUTPUT.PUT_LINE('Factoriel de ' || &p_n || ' = ' || v_res);
END;
/
UNDEFINE p_n
-- Resultat attendu : Factoriel de 5 = 120

-- Test 1.3 : cas refuse, n negatif
BEGIN
  DBMS_OUTPUT.PUT_LINE('Factoriel de -3 = ' || F_FACTORIEL(-3));
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue : ' || SQLERRM);
END;
/
-- Resultat attendu : ORA-20001: n doit etre un entier positif ou nul

-- Test 1.4 : cas refuse, n non entier
BEGIN
  DBMS_OUTPUT.PUT_LINE('Factoriel de 5.5 = ' || F_FACTORIEL(5.5));
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue : ' || SQLERRM);
END;
/
-- Resultat attendu : ORA-20001: n doit etre un entier positif ou nul


-- ############################################################################
-- EXERCICE 2 [OBL] : FICHE PATIENT
-- Afficher nom, prenom, groupe sanguin et ville d'un patient donne,
-- et traiter le patient inexistant.
-- ############################################################################

DEFINE p_id_patient = 1
DECLARE
  v_nom    personne.nom%TYPE;
  v_prenom personne.prenom%TYPE;
  v_groupe patient.groupe_sanguin%TYPE;
  v_ville  personne.ville%TYPE;
BEGIN
  SELECT per.nom, per.prenom, pat.groupe_sanguin, per.ville
    INTO v_nom, v_prenom, v_groupe, v_ville
    FROM patient pat
    JOIN personne per ON per.id_personne = pat.id_personne
   WHERE pat.id_patient = &p_id_patient;

  DBMS_OUTPUT.PUT_LINE('Nom    : ' || v_nom);
  DBMS_OUTPUT.PUT_LINE('Prenom : ' || v_prenom);
  DBMS_OUTPUT.PUT_LINE('Groupe : ' || v_groupe);
  DBMS_OUTPUT.PUT_LINE('Ville  : ' || v_ville);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Patient inexistant');
END;
/
UNDEFINE p_id_patient
-- Resultat attendu (patient 1) : Bensalem / Amine / A+ / Oran

-- Test 2.2 : patient inexistant
DEFINE p_id_patient = 99999
DECLARE
  v_nom    personne.nom%TYPE;
  v_prenom personne.prenom%TYPE;
  v_groupe patient.groupe_sanguin%TYPE;
  v_ville  personne.ville%TYPE;
BEGIN
  SELECT per.nom, per.prenom, pat.groupe_sanguin, per.ville
    INTO v_nom, v_prenom, v_groupe, v_ville
    FROM patient pat
    JOIN personne per ON per.id_personne = pat.id_personne
   WHERE pat.id_patient = &p_id_patient;

  DBMS_OUTPUT.PUT_LINE(v_nom || ' ' || v_prenom);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Patient inexistant');
END;
/
UNDEFINE p_id_patient
-- Resultat attendu : Patient inexistant


-- ############################################################################
-- EXERCICE 3 [OBL] : AGE ET CATEGORIE
-- Age en annees entieres avec MONTHS_BETWEEN (sans diviser par 365),
-- puis categorie : mineur (< 18), adulte (18 a 59), senior (>= 60).
-- ############################################################################

DEFINE p_id_patient = 1
DECLARE
  v_date_naiss personne.date_naissance%TYPE;
  v_age        NUMBER;
  v_categorie  VARCHAR2(10);
BEGIN
  SELECT per.date_naissance
    INTO v_date_naiss
    FROM patient pat
    JOIN personne per ON per.id_personne = pat.id_personne
   WHERE pat.id_patient = &p_id_patient;

  v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, v_date_naiss) / 12);

  IF v_age < 18 THEN
    v_categorie := 'mineur';
  ELSIF v_age <= 59 THEN
    v_categorie := 'adulte';
  ELSE
    v_categorie := 'senior';
  END IF;

  DBMS_OUTPUT.PUT_LINE('Age       : ' || v_age || ' ans');
  DBMS_OUTPUT.PUT_LINE('Categorie : ' || v_categorie);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Patient inexistant');
END;
/
UNDEFINE p_id_patient
-- Resultat attendu (patient 1, ne le 02/02/1957) : 69 ans, senior

-- Test 3.2 : patient 7 (ne le 08/08/1999)
DEFINE p_id_patient = 7
DECLARE
  v_date_naiss personne.date_naissance%TYPE;
  v_age        NUMBER;
  v_categorie  VARCHAR2(10);
BEGIN
  SELECT per.date_naissance
    INTO v_date_naiss
    FROM patient pat
    JOIN personne per ON per.id_personne = pat.id_personne
   WHERE pat.id_patient = &p_id_patient;

  v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, v_date_naiss) / 12);

  IF v_age < 18 THEN
    v_categorie := 'mineur';
  ELSIF v_age <= 59 THEN
    v_categorie := 'adulte';
  ELSE
    v_categorie := 'senior';
  END IF;

  DBMS_OUTPUT.PUT_LINE('Age=' || v_age || ', categorie=' || v_categorie);
END;
/
UNDEFINE p_id_patient
-- Resultat attendu : Age=27, categorie=adulte


-- ############################################################################
-- EXERCICE 4 [OBL] : SELECT INTO : 0, 1, n LIGNES
-- Rechercher un patient par nom (absent puis existant), puis par ville.
-- Expliquer NO_DATA_FOUND et TOO_MANY_ROWS.
-- ############################################################################

-- Test 4.1 : nom absent -> NO_DATA_FOUND (0 ligne)
DECLARE
  v_id_patient patient.id_patient%TYPE;
BEGIN
  SELECT pat.id_patient
    INTO v_id_patient
    FROM patient pat
    JOIN personne per ON per.id_personne = pat.id_personne
   WHERE per.nom = 'NomInexistant';

  DBMS_OUTPUT.PUT_LINE('Trouve : ' || v_id_patient);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND : aucun patient avec ce nom.');
END;
/
-- Resultat attendu : NO_DATA_FOUND

-- Test 4.2 : nom existant -> exactement 1 ligne
DECLARE
  v_id_patient patient.id_patient%TYPE;
  v_nom        personne.nom%TYPE;
BEGIN
  SELECT pat.id_patient, per.nom
    INTO v_id_patient, v_nom
    FROM patient pat
    JOIN personne per ON per.id_personne = pat.id_personne
   WHERE per.nom = 'Bensalem';

  DBMS_OUTPUT.PUT_LINE('Patient trouve : ' || v_id_patient || ' - ' || v_nom);
END;
/
-- Resultat attendu : Patient trouve : 1 - Bensalem

-- Test 4.3 : ville 'Oran' -> plusieurs lignes -> TOO_MANY_ROWS
DECLARE
  v_id_patient patient.id_patient%TYPE;
BEGIN
  SELECT pat.id_patient
    INTO v_id_patient
    FROM patient pat
    JOIN personne per ON per.id_personne = pat.id_personne
   WHERE per.ville = 'Oran';

  DBMS_OUTPUT.PUT_LINE('Trouve : ' || v_id_patient);
EXCEPTION
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS : plusieurs patients dans cette ville.');
END;
/
-- Resultat attendu : TOO_MANY_ROWS

-- Explication :
--   NO_DATA_FOUND : le SELECT INTO n'a retourne aucune ligne alors qu'il en
--   attendait exactement une (0 ligne).
--   TOO_MANY_ROWS : le SELECT INTO a retourne plusieurs lignes alors qu'il en
--   attendait une seule (n lignes).


-- ############################################################################
-- EXERCICE 5 [OPT] : VENDREDI OU SAMEDI
-- Sans dependre de la langue : TRUNC(d) - TRUNC(d,'IW') (lundi = 0,
-- vendredi = 4, samedi = 5).
-- ############################################################################

DEFINE p_date = DATE '2026-10-23'
DECLARE
  d DATE := &p_date;
  j NUMBER := TRUNC(d) - TRUNC(d, 'IW');
BEGIN
  IF j IN (4, 5) THEN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(d, 'DD/MM/YYYY') ||
      ' est un vendredi ou un samedi (j=' || j || ')');
  ELSE
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(d, 'DD/MM/YYYY') ||
      ' n est ni un vendredi ni un samedi (j=' || j || ')');
  END IF;
END;
/
UNDEFINE p_date
-- Resultat attendu : 23/10/2026 est un vendredi ou un samedi (j=4)

-- Test 5.2 : samedi 24/10/2026
DEFINE p_date = DATE '2026-10-24'
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
-- Resultat attendu : 24/10/2026 -> vendredi/samedi (j=5)

-- Test 5.3 : dimanche 25/10/2026 (refuse)
DEFINE p_date = DATE '2026-10-25'
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
-- Resultat attendu : 25/10/2026 -> autre jour (j=6)

PROMPT ============================================================
PROMPT  B. CURSEURS
PROMPT ============================================================

-- ############################################################################
-- EXERCICE 6 [OBL] : CURSEUR FOR
-- Afficher chaque patient avec son nombre de consultations, y compris les
-- patients sans consultation (LEFT JOIN).
-- ############################################################################

BEGIN
  FOR r IN (
    SELECT pat.id_patient, per.nom, per.prenom,
           COUNT(c.id_consultation) AS nb_consult
      FROM patient pat
      JOIN personne per ON per.id_personne = pat.id_personne
      LEFT JOIN consultation c ON c.id_patient = pat.id_patient
     GROUP BY pat.id_patient, per.nom, per.prenom
     ORDER BY pat.id_patient
  ) LOOP
    DBMS_OUTPUT.PUT_LINE(r.id_patient || ' - ' || r.nom || ' ' || r.prenom ||
                         ' : ' || r.nb_consult || ' consultation(s)');
  END LOOP;
END;
/
-- Resultat attendu : une ligne par patient, avec 0 pour ceux qui n'ont
-- aucune consultation.


-- ############################################################################
-- EXERCICE 7 [OBL] : CURSEUR PARAMETRE
-- Consultations des medecins d'un service entre deux dates.
-- Attention : MEDECIN n'a pas de colonne NOM, on joint PERSONNE.
-- ############################################################################

DECLARE
  CURSOR c_consult_service (
    p_id_service service.id_service%TYPE,
    p_debut      DATE,
    p_fin        DATE
  ) IS
    SELECT c.id_consultation,
           per.nom AS nom_medecin,
           per.prenom AS prenom_medecin,
           c.date_consultation,
           c.motif
      FROM consultation c
      JOIN medecin m ON m.id_medecin = c.id_medecin
      JOIN personne per ON per.id_personne = m.id_personne
     WHERE c.id_service = p_id_service
       AND c.date_consultation BETWEEN p_debut AND p_fin
     ORDER BY c.date_consultation, c.heure_consultation;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Consultations du service 1 du 05/09/2026 au 10/09/2026 :');
  FOR r IN c_consult_service(1, DATE '2026-09-05', DATE '2026-09-10') LOOP
    DBMS_OUTPUT.PUT_LINE(r.id_consultation || ' - Dr ' ||
                         r.nom_medecin || ' ' || r.prenom_medecin || ' - ' ||
                         TO_CHAR(r.date_consultation, 'DD/MM/YYYY') || ' - ' ||
                         r.motif);
  END LOOP;
END;
/
-- Resultat attendu : consultations 1 et 2 (service 1).

-- Test 7.2 : intervalle sans consultation (service 5, janvier 2027)
DECLARE
  CURSOR c_consult_service (
    p_id_service service.id_service%TYPE,
    p_debut      DATE,
    p_fin        DATE
  ) IS
    SELECT c.id_consultation, per.nom, c.date_consultation
      FROM consultation c
      JOIN medecin m ON m.id_medecin = c.id_medecin
      JOIN personne per ON per.id_personne = m.id_personne
     WHERE c.id_service = p_id_service
       AND c.date_consultation BETWEEN p_debut AND p_fin;
BEGIN
  FOR r IN c_consult_service(5, DATE '2027-01-01', DATE '2027-01-02') LOOP
    DBMS_OUTPUT.PUT_LINE(r.id_consultation || ' - Dr ' || r.nom);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Fin du test service 5 : aucune ligne attendue.');
END;
/


-- ############################################################################
-- EXERCICE 8 [OPT] : OPEN / FETCH / CLOSE
-- Parcourir a la main les medicaments sous le seuil d'alerte et afficher
-- leur nombre avec %ROWCOUNT.
-- ############################################################################

-- Dans la base initiale, aucun medicament n'est sous son seuil. On abaisse
-- temporairement deux stocks pour illustrer le parcours, puis ROLLBACK.
UPDATE medicament SET stock = 15 WHERE id_medicament = 3;  -- seuil 20
UPDATE medicament SET stock = 5  WHERE id_medicament = 9;  -- seuil 10

DECLARE
  CURSOR c_stock IS
    SELECT id_medicament, nom_medicament, stock, seuil_alerte
      FROM medicament
     WHERE stock < seuil_alerte
     ORDER BY id_medicament;
  v_id    medicament.id_medicament%TYPE;
  v_nom   medicament.nom_medicament%TYPE;
  v_stock medicament.stock%TYPE;
  v_seuil medicament.seuil_alerte%TYPE;
BEGIN
  OPEN c_stock;
  LOOP
    FETCH c_stock INTO v_id, v_nom, v_stock, v_seuil;
    EXIT WHEN c_stock%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(c_stock%ROWCOUNT || '. ' || v_nom ||
                         ' : stock=' || v_stock || ' (seuil ' || v_seuil || ')');
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Total sous le seuil : ' || c_stock%ROWCOUNT);
  CLOSE c_stock;
END;
/
ROLLBACK;
-- Resultat attendu : 2 lignes (Amoxicilline stock 15, Salbutamol stock 5),
-- puis "Total sous le seuil : 2". Le ROLLBACK restaure les stocks.


PROMPT ============================================================
PROMPT  C. PROCEDURES, FONCTIONS ET TRANSACTIONS
PROMPT ============================================================

-- ############################################################################
-- EXERCICE 9 [OBL] : P_RESUME_PATIENT
-- Afficher l'identite du patient et ses nombres de rendez-vous, consultations
-- et hospitalisations ; traiter le patient inexistant.
-- ############################################################################

CREATE OR REPLACE PROCEDURE P_RESUME_PATIENT (
  p_id_patient IN patient.id_patient%TYPE
) IS
  v_nom    personne.nom%TYPE;
  v_pre    personne.prenom%TYPE;
  v_nb_rdv NUMBER;
  v_nb_con NUMBER;
  v_nb_hos NUMBER;
BEGIN
  SELECT per.nom, per.prenom
    INTO v_nom, v_pre
    FROM patient pat
    JOIN personne per ON per.id_personne = pat.id_personne
   WHERE pat.id_patient = p_id_patient;

  SELECT COUNT(*) INTO v_nb_rdv FROM rendez_vous    WHERE id_patient = p_id_patient;
  SELECT COUNT(*) INTO v_nb_con FROM consultation   WHERE id_patient = p_id_patient;
  SELECT COUNT(*) INTO v_nb_hos FROM hospitalisation WHERE id_patient = p_id_patient;

  DBMS_OUTPUT.PUT_LINE('Patient          : ' || v_pre || ' ' || v_nom);
  DBMS_OUTPUT.PUT_LINE('Rendez-vous      : ' || v_nb_rdv);
  DBMS_OUTPUT.PUT_LINE('Consultations    : ' || v_nb_con);
  DBMS_OUTPUT.PUT_LINE('Hospitalisations : ' || v_nb_hos);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Patient inexistant');
END;
/
SHOW ERRORS PROCEDURE P_RESUME_PATIENT

-- Test 9.1 : patient existant
BEGIN
  P_RESUME_PATIENT(1);
END;
/
-- Resultat attendu : identite de Amine Bensalem et ses compteurs.

-- Test 9.2 : patient inexistant
BEGIN
  P_RESUME_PATIENT(99999);
END;
/
-- Resultat attendu : Patient inexistant


-- ############################################################################
-- EXERCICE 10 [OBL] : F_RESTE_FACTURE
-- Retourne montant_total * (1 - remise/100) - total deja paye.
-- Erreur -20101 si la facture n'existe pas.
-- ############################################################################

CREATE OR REPLACE FUNCTION F_RESTE_FACTURE (
  p_id_facture IN facture.id_facture%TYPE
) RETURN NUMBER IS
  v_total  facture.montant_total%TYPE;
  v_remise facture.remise%TYPE;
  v_paye   NUMBER;
BEGIN
  SELECT montant_total, remise
    INTO v_total, v_remise
    FROM facture
   WHERE id_facture = p_id_facture;

  SELECT NVL(SUM(montant), 0)
    INTO v_paye
    FROM paiement
   WHERE id_facture = p_id_facture;

  RETURN v_total * (1 - v_remise / 100) - v_paye;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20101, 'Facture inexistante');
END;
/
SHOW ERRORS FUNCTION F_RESTE_FACTURE

-- Test 10.1 : factures 2 et 20
DECLARE
  v_reste NUMBER;
BEGIN
  v_reste := F_RESTE_FACTURE(2);
  DBMS_OUTPUT.PUT_LINE('Reste facture 2  : ' || v_reste);   -- 6000 - 3000 = 3000
  v_reste := F_RESTE_FACTURE(20);
  DBMS_OUTPUT.PUT_LINE('Reste facture 20 : ' || v_reste);   -- 5700*0.9 - 5130 = 0
END;
/
-- Resultat attendu : 3000 puis 0

-- Test 10.2 : facture inexistante -> -20101
BEGIN
  DBMS_OUTPUT.PUT_LINE('Reste facture 99999 : ' || F_RESTE_FACTURE(99999));
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue : ' || SQLERRM);
END;
/
-- Resultat attendu : ORA-20101: Facture inexistante


-- ############################################################################
-- EXERCICE 11 [OBL] : P_AJOUTER_PATIENT
-- Ajouter une personne et un patient ; refuser un email deja utilise (-20111)
-- ou un numero de securite sociale deja utilise (-20112).
-- ############################################################################

CREATE OR REPLACE PROCEDURE P_AJOUTER_PATIENT (
  p_nom        IN personne.nom%TYPE,
  p_prenom     IN personne.prenom%TYPE,
  p_date_naiss IN personne.date_naissance%TYPE,
  p_sexe       IN personne.sexe%TYPE,
  p_email      IN personne.email%TYPE,
  p_num_ss     IN patient.num_securite_soc%TYPE,
  p_id_patient OUT patient.id_patient%TYPE
) IS
  v_id_personne personne.id_personne%TYPE;
  v_dummy       NUMBER;
BEGIN
  -- Email deja utilise ?
  IF p_email IS NOT NULL THEN
    BEGIN
      SELECT 1 INTO v_dummy
        FROM personne
       WHERE LOWER(TRIM(email)) = LOWER(TRIM(p_email));
      RAISE_APPLICATION_ERROR(-20111, 'Adresse e-mail deja utilisee');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;  -- email libre
    END;
  END IF;

  -- Numero de securite sociale deja utilise ?
  IF p_num_ss IS NOT NULL THEN
    BEGIN
      SELECT 1 INTO v_dummy FROM patient WHERE num_securite_soc = p_num_ss;
      RAISE_APPLICATION_ERROR(-20112, 'Numero de securite sociale deja utilise');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;  -- numero libre
    END;
  END IF;

  -- Insertion de la personne (Oracle 10g : SELECT ... INTO depuis dual)
  SELECT seq_personne.NEXTVAL INTO v_id_personne FROM dual;
  INSERT INTO personne (id_personne, nom, prenom, date_naissance, sexe,
                        email, date_creation)
  VALUES (v_id_personne, p_nom, p_prenom, p_date_naiss, p_sexe,
          p_email, SYSDATE);

  -- Insertion du patient
  SELECT seq_patient.NEXTVAL INTO p_id_patient FROM dual;
  INSERT INTO patient (id_patient, id_personne, num_securite_soc)
  VALUES (p_id_patient, v_id_personne, p_num_ss);
END;
/
SHOW ERRORS PROCEDURE P_AJOUTER_PATIENT

-- Test 11.1 : ajout accepte
DECLARE
  v_id patient.id_patient%TYPE;
BEGIN
  P_AJOUTER_PATIENT('Dupont', 'Jean', DATE '2000-01-01', 'M',
                    'jean.dupont@test.dz', 'SS-TEST001', v_id);
  DBMS_OUTPUT.PUT_LINE('Patient ajoute : id = ' || v_id);
  ROLLBACK;
END;
/
-- Resultat attendu : Patient ajoute : id = 1000 (ou 1001 si deja teste)

-- Test 11.2 : email deja utilise -> -20111
DECLARE
  v_id patient.id_patient%TYPE;
BEGIN
  P_AJOUTER_PATIENT('Dupont', 'Jean', DATE '2000-01-01', 'M',
                    'amine.bensalem@elsaha.dz', 'SS-TEST002', v_id);
  DBMS_OUTPUT.PUT_LINE('ERREUR : le doublon email aurait du etre refuse.');
  ROLLBACK;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20111) : ' || SQLERRM);
    ROLLBACK;
END;
/
-- Resultat attendu : ORA-20111: Adresse e-mail deja utilisee

-- Test 11.3 : numero SS deja utilise -> -20112
DECLARE
  v_id patient.id_patient%TYPE;
BEGIN
  P_AJOUTER_PATIENT('Dupont', 'Jean', DATE '2000-01-01', 'M',
                    'jean.dupont2@test.dz', 'SS-200001', v_id);
  DBMS_OUTPUT.PUT_LINE('ERREUR : le doublon de numero SS aurait du etre refuse.');
  ROLLBACK;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20112) : ' || SQLERRM);
    ROLLBACK;
END;
/
-- Resultat attendu : ORA-20112: Numero de securite sociale deja utilise


-- ############################################################################
-- EXERCICE 12 [OBL] : SAVEPOINT
-- Modifier plusieurs stocks, provoquer un stock negatif, annuler seulement
-- la partie incorrecte avec ROLLBACK TO, puis ROLLBACK final.
-- ############################################################################

DECLARE
  v_stock1 medicament.stock%TYPE;
  v_stock2 medicament.stock%TYPE;
  v_stock3 medicament.stock%TYPE;
BEGIN
  SELECT stock INTO v_stock1 FROM medicament WHERE id_medicament = 1;
  SELECT stock INTO v_stock2 FROM medicament WHERE id_medicament = 2;
  SELECT stock INTO v_stock3 FROM medicament WHERE id_medicament = 3;
  DBMS_OUTPUT.PUT_LINE('Avant : med1=' || v_stock1 ||
                       ', med2=' || v_stock2 ||
                       ', med3=' || v_stock3);

  -- Modifications correctes
  UPDATE medicament SET stock = stock - 10 WHERE id_medicament = 1;
  UPDATE medicament SET stock = stock - 20 WHERE id_medicament = 2;

  SAVEPOINT avant_erreur;

  -- Erreur volontaire : stock negatif (viole CK_MEDICAMENT_STOCK)
  UPDATE medicament SET stock = -100 WHERE id_medicament = 3;

  DBMS_OUTPUT.PUT_LINE('ERREUR : le stock negatif aurait du etre refuse.');
  ROLLBACK;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur detectee : ' || SQLERRM);
    ROLLBACK TO avant_erreur;

    SELECT stock INTO v_stock1 FROM medicament WHERE id_medicament = 1;
    SELECT stock INTO v_stock2 FROM medicament WHERE id_medicament = 2;
    SELECT stock INTO v_stock3 FROM medicament WHERE id_medicament = 3;
    DBMS_OUTPUT.PUT_LINE('Apres ROLLBACK TO : med1=' || v_stock1 ||
                         ', med2=' || v_stock2 ||
                         ', med3=' || v_stock3);

    ROLLBACK;  -- annule tout pour rendre la base coherente
    DBMS_OUTPUT.PUT_LINE('ROLLBACK final effectue.');
END;
/
-- Resultat attendu :
-- Avant : med1=250, med2=120, med3=80
-- Erreur detectee : ORA-02290 ... CK_MEDICAMENT_STOCK
-- Apres ROLLBACK TO : med1=240, med2=100, med3=80
-- ROLLBACK final effectue.

PROMPT ============================================================
PROMPT  D. TRIGGERS
PROMPT ============================================================

-- ############################################################################
-- EXERCICE 13 [OBL] : NORMALISER LES PATIENTS
-- TRG_PATIENT_BIU (BEFORE INSERT OR UPDATE, ligne) : nom en majuscules,
-- prenom avec majuscule initiale, email en minuscules, sans espaces.
-- Dans ce schema, ces colonnes sont dans PERSONNE et non dans PATIENT : le
-- trigger est donc cree sur PERSONNE (le nom TRG_PATIENT_BIU demande par le
-- TP est conserve). Il normalise toute personne, patients et medecins.
-- ############################################################################

CREATE OR REPLACE TRIGGER TRG_PATIENT_BIU
BEFORE INSERT OR UPDATE ON personne
FOR EACH ROW
BEGIN
  :NEW.nom    := UPPER(TRIM(:NEW.nom));
  :NEW.prenom := INITCAP(LOWER(TRIM(:NEW.prenom)));
  IF :NEW.email IS NOT NULL THEN
    :NEW.email := LOWER(TRIM(:NEW.email));
  END IF;
END;
/
SHOW ERRORS TRIGGER TRG_PATIENT_BIU

-- Test 13.1 : patient 1 saisi en desordre
DECLARE
  v_nom  personne.nom%TYPE;
  v_pre  personne.prenom%TYPE;
  v_mail personne.email%TYPE;
BEGIN
  -- Donnees volontairement en desordre dans PERSONNE : le trigger normalise
  UPDATE personne
     SET nom = '  bEnSaLeM  ',
         prenom = '  aMiNe  ',
         email = '  AMINE@ELSAHA.DZ  '
   WHERE id_personne = (SELECT id_personne FROM patient WHERE id_patient = 1);

  SELECT nom, prenom, email
    INTO v_nom, v_pre, v_mail
    FROM personne
   WHERE id_personne = (SELECT id_personne FROM patient WHERE id_patient = 1);

  DBMS_OUTPUT.PUT_LINE('Nom    : [' || v_nom || ']');
  DBMS_OUTPUT.PUT_LINE('Prenom : [' || v_pre || ']');
  DBMS_OUTPUT.PUT_LINE('Email  : [' || v_mail || ']');
  ROLLBACK;
END;
/
-- Resultat attendu :
-- Nom    : [BENSALEM]
-- Prenom : [Amine]
-- Email  : [amine@elsaha.dz]

-- Test 13.2 : insertion d'un patient avec des donnees en desordre
DECLARE
  v_id_personne personne.id_personne%TYPE;
  v_id_patient  patient.id_patient%TYPE;
  v_nom         personne.nom%TYPE;
  v_pre         personne.prenom%TYPE;
BEGIN
  SELECT seq_personne.NEXTVAL INTO v_id_personne FROM dual;
  INSERT INTO personne (id_personne, nom, prenom, date_naissance, sexe, email)
  VALUES (v_id_personne, '  dUpOnT  ', '  jEaN  ', DATE '2000-01-01', 'M',
          '  JEAN.DUPONT@TEST.DZ  ');

  SELECT seq_patient.NEXTVAL INTO v_id_patient FROM dual;
  INSERT INTO patient (id_patient, id_personne, num_securite_soc)
  VALUES (v_id_patient, v_id_personne, 'SS-TEST-13');

  SELECT nom, prenom INTO v_nom, v_pre FROM personne WHERE id_personne = v_id_personne;
  DBMS_OUTPUT.PUT_LINE('Nouveau patient : ' || v_nom || ' ' || v_pre);
  ROLLBACK;
END;
/
-- Resultat attendu : Nouveau patient : DUPONT Jean


-- ############################################################################
-- EXERCICE 14 [OBL] : REGLES DES RENDEZ-VOUS
-- TRG_RDV_BIU (BEFORE INSERT OR UPDATE, ligne) :
--   -20201 date passee a l'insertion ou si la date change
--   -20202 heure qui n'est pas HH:MM valide
--   -20203 changement de statut d'un rendez-vous clos
--   -20204 retour de CONFIRME a PLANIFIE
-- Une modification qui ne change pas la date doit passer.
-- ############################################################################

CREATE OR REPLACE TRIGGER TRG_RDV_BIU
BEFORE INSERT OR UPDATE ON rendez_vous
FOR EACH ROW
BEGIN
  -- 1. Date passee
  IF INSERTING THEN
    IF :NEW.date_rdv < TRUNC(SYSDATE) THEN
      RAISE_APPLICATION_ERROR(-20201, 'Date de rendez-vous passee interdite');
    END IF;
  ELSIF UPDATING THEN
    IF :NEW.date_rdv <> :OLD.date_rdv
       AND :NEW.date_rdv < TRUNC(SYSDATE) THEN
      RAISE_APPLICATION_ERROR(-20201, 'Nouvelle date de rendez-vous passee');
    END IF;
  END IF;

  -- 2. Heure au format HH:MM (00:00 a 23:59)
  IF NOT REGEXP_LIKE(:NEW.heure_rdv, '^([01][0-9]|2[0-3]):[0-5][0-9]$') THEN
    RAISE_APPLICATION_ERROR(-20202, 'Heure invalide (format HH:MM attendu)');
  END IF;

  -- 3 et 4. Changement de statut
  IF UPDATING AND :NEW.statut <> :OLD.statut THEN
    IF :OLD.statut IN ('ANNULE', 'REALISE', 'ABSENT') THEN
      RAISE_APPLICATION_ERROR(-20203,
        'Impossible de modifier le statut d un rendez-vous clos');
    END IF;

    IF :OLD.statut = 'CONFIRME' AND :NEW.statut = 'PLANIFIE' THEN
      RAISE_APPLICATION_ERROR(-20204,
        'Retour de CONFIRME a PLANIFIE interdit');
    END IF;
  END IF;
END;
/
SHOW ERRORS TRIGGER TRG_RDV_BIU

-- Test 14.1 : cas accepte, date inchangee (rdv 81, PLANIFIE)
UPDATE rendez_vous SET motif = 'Motif modifie' WHERE id_rdv = 81;
SELECT id_rdv, date_rdv, heure_rdv, statut, motif
  FROM rendez_vous WHERE id_rdv = 81;
ROLLBACK;
-- Resultat attendu : modification acceptee, motif = Motif modifie

-- Test 14.2 : cas refuse -20201, date passee a l'insertion
BEGIN
  INSERT INTO rendez_vous (id_rdv, id_patient, id_medecin, id_service,
                           date_rdv, heure_rdv, motif, statut)
  VALUES (seq_rdv.NEXTVAL, 1, 1, 1, DATE '2020-01-01', '09:00',
          'Test date passee', 'PLANIFIE');
  DBMS_OUTPUT.PUT_LINE('ERREUR : la date passee aurait du etre refusee.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20201) : ' || SQLERRM);
END;
/
ROLLBACK;
-- Resultat attendu : ORA-20201

-- Test 14.3 : cas refuse -20201, changement vers une date passee (rdv 82)
BEGIN
  UPDATE rendez_vous SET date_rdv = DATE '2020-01-01' WHERE id_rdv = 82;
  DBMS_OUTPUT.PUT_LINE('ERREUR : la nouvelle date passee aurait du etre refusee.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20201) : ' || SQLERRM);
END;
/
ROLLBACK;
-- Resultat attendu : ORA-20201

-- Test 14.4 : cas refuse -20202, heure invalide
BEGIN
  UPDATE rendez_vous SET heure_rdv = '25:00' WHERE id_rdv = 81;
  DBMS_OUTPUT.PUT_LINE('ERREUR : l heure invalide aurait du etre refusee.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20202) : ' || SQLERRM);
END;
/
ROLLBACK;
-- Resultat attendu : ORA-20202

-- Test 14.5 : cas refuse -20203, rdv 1 est REALISE (clos)
BEGIN
  UPDATE rendez_vous SET statut = 'ANNULE' WHERE id_rdv = 1;
  DBMS_OUTPUT.PUT_LINE('ERREUR : le statut du rdv clos aurait du etre refuse.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20203) : ' || SQLERRM);
END;
/
ROLLBACK;
-- Resultat attendu : ORA-20203

-- Test 14.6 : cas refuse -20204, rdv 71 est CONFIRME
BEGIN
  UPDATE rendez_vous SET statut = 'PLANIFIE' WHERE id_rdv = 71;
  DBMS_OUTPUT.PUT_LINE('ERREUR : le retour CONFIRME -> PLANIFIE aurait du etre refuse.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20204) : ' || SQLERRM);
END;
/
ROLLBACK;
-- Resultat attendu : ORA-20204


-- ############################################################################
-- EXERCICE 15 [OBL] : COHERENCE CONSULTATION / RENDEZ-VOUS
-- TRG_CONSULT_BI (BEFORE INSERT, ligne, WHEN ID_RDV non nul) :
--   -20401 patient ou medecin different du rendez-vous
--   -20402 rendez-vous ANNULE
--   -20403 rendez-vous inexistant
-- ############################################################################

CREATE OR REPLACE TRIGGER TRG_CONSULT_BI
BEFORE INSERT ON consultation
FOR EACH ROW
WHEN (NEW.id_rdv IS NOT NULL)
DECLARE
  v_id_patient rendez_vous.id_patient%TYPE;
  v_id_medecin rendez_vous.id_medecin%TYPE;
  v_statut     rendez_vous.statut%TYPE;
  v_nb         NUMBER;
BEGIN
  -- Le rendez-vous existe-t-il ?
  SELECT COUNT(*) INTO v_nb FROM rendez_vous WHERE id_rdv = :NEW.id_rdv;
  IF v_nb = 0 THEN
    RAISE_APPLICATION_ERROR(-20403, 'Rendez-vous inexistant');
  END IF;

  SELECT id_patient, id_medecin, statut
    INTO v_id_patient, v_id_medecin, v_statut
    FROM rendez_vous
   WHERE id_rdv = :NEW.id_rdv;

  -- Rendez-vous annule ?
  IF v_statut = 'ANNULE' THEN
    RAISE_APPLICATION_ERROR(-20402, 'Rendez-vous annule');
  END IF;

  -- Patient ou medecin different ?
  IF :NEW.id_patient <> v_id_patient OR :NEW.id_medecin <> v_id_medecin THEN
    RAISE_APPLICATION_ERROR(-20401,
      'Patient ou medecin different de ceux du rendez-vous');
  END IF;
END;
/
SHOW ERRORS TRIGGER TRG_CONSULT_BI

-- Test 15.1 : cas refuse -20403, rendez-vous inexistant
DECLARE
  v_id NUMBER;
BEGIN
  SELECT seq_consultation.NEXTVAL INTO v_id FROM dual;
  INSERT INTO consultation (id_consultation, id_rdv, id_patient, id_medecin,
                            id_service, date_consultation, heure_consultation,
                            motif, type_consultation, montant_honoraire)
  VALUES (v_id, 99999, 1, 1, 1, DATE '2026-10-01', '09:00',
          'Test rdv inexistant', 'NORMALE', 0);
  DBMS_OUTPUT.PUT_LINE('ERREUR : le rdv inexistant aurait du etre refuse.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20403) : ' || SQLERRM);
END;
/
ROLLBACK;

-- Test 15.2 : cas refuse -20402, rdv 89 est ANNULE
DECLARE
  v_id NUMBER;
BEGIN
  SELECT seq_consultation.NEXTVAL INTO v_id FROM dual;
  INSERT INTO consultation (id_consultation, id_rdv, id_patient, id_medecin,
                            id_service, date_consultation, heure_consultation,
                            motif, type_consultation, montant_honoraire)
  VALUES (v_id, 89, 23, 14, 11, DATE '2026-10-14', '09:30',
          'Test rdv annule', 'NORMALE', 0);
  DBMS_OUTPUT.PUT_LINE('ERREUR : le rdv annule aurait du etre refuse.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20402) : ' || SQLERRM);
END;
/
ROLLBACK;

-- Test 15.3 : cas refuse -20401, patient/medecin differents (rdv 81 : 17/6)
DECLARE
  v_id NUMBER;
BEGIN
  SELECT seq_consultation.NEXTVAL INTO v_id FROM dual;
  INSERT INTO consultation (id_consultation, id_rdv, id_patient, id_medecin,
                            id_service, date_consultation, heure_consultation,
                            motif, type_consultation, montant_honoraire)
  VALUES (v_id, 81, 1, 1, 1, DATE '2026-10-13', '14:30',
          'Test patient/medecin differents', 'NORMALE', 0);
  DBMS_OUTPUT.PUT_LINE('ERREUR : le patient/medecin different aurait du etre refuse.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20401) : ' || SQLERRM);
END;
/
ROLLBACK;

-- Test 15.4 : cas accepte, rdv 81 avec patient 17 et medecin 6
DECLARE
  v_id NUMBER;
BEGIN
  SELECT seq_consultation.NEXTVAL INTO v_id FROM dual;
  INSERT INTO consultation (id_consultation, id_rdv, id_patient, id_medecin,
                            id_service, date_consultation, heure_consultation,
                            motif, type_consultation, montant_honoraire)
  VALUES (v_id, 81, 17, 6, 5, DATE '2026-10-13', '14:30',
          'Consultation coherente', 'NORMALE', 0);
  DBMS_OUTPUT.PUT_LINE('Consultation coherente inseree (acceptee).');
  ROLLBACK;
END;
/
-- Resultat attendu : Consultation coherente inseree (acceptee).


-- ############################################################################
-- EXERCICE 16 [OBL] : CONSULTATION REALISEE
-- TRG_CONSULT_AI (AFTER INSERT, ligne) : si la consultation est liee a un
-- rendez-vous PLANIFIE ou CONFIRME, le passer a REALISE.
-- ############################################################################

CREATE OR REPLACE TRIGGER TRG_CONSULT_AI
AFTER INSERT ON consultation
FOR EACH ROW
BEGIN
  IF :NEW.id_rdv IS NOT NULL THEN
    UPDATE rendez_vous
       SET statut = 'REALISE'
     WHERE id_rdv = :NEW.id_rdv
       AND statut IN ('PLANIFIE', 'CONFIRME');
  END IF;
END;
/
SHOW ERRORS TRIGGER TRG_CONSULT_AI

-- Test 16.1 : rdv 81 (PLANIFIE) -> REALISE
DECLARE
  v_id     NUMBER;
  v_statut rendez_vous.statut%TYPE;
BEGIN
  SELECT seq_consultation.NEXTVAL INTO v_id FROM dual;
  INSERT INTO consultation (id_consultation, id_rdv, id_patient, id_medecin,
                            id_service, date_consultation, heure_consultation,
                            motif, type_consultation, montant_honoraire)
  VALUES (v_id, 81, 17, 6, 5, DATE '2026-10-13', '14:30',
          'Declenchement consultation realisee', 'NORMALE', 0);

  SELECT statut INTO v_statut FROM rendez_vous WHERE id_rdv = 81;
  DBMS_OUTPUT.PUT_LINE('Statut du rdv 81 apres insertion : ' || v_statut);
  ROLLBACK;
END;
/
-- Resultat attendu : Statut du rdv 81 apres insertion : REALISE

-- Test 16.2 : rdv deja REALISE (on rend d'abord le rdv 71 REALISE)
DECLARE
  v_id     NUMBER;
  v_statut rendez_vous.statut%TYPE;
BEGIN
  UPDATE rendez_vous SET statut = 'REALISE' WHERE id_rdv = 71;

  SELECT seq_consultation.NEXTVAL INTO v_id FROM dual;
  INSERT INTO consultation (id_consultation, id_rdv, id_patient, id_medecin,
                            id_service, date_consultation, heure_consultation,
                            motif, type_consultation, montant_honoraire)
  VALUES (v_id, 71, 47, 11, 9, DATE '2026-10-03', '11:30',
          'Test rdv deja realise', 'NORMALE', 0);

  SELECT statut INTO v_statut FROM rendez_vous WHERE id_rdv = 71;
  DBMS_OUTPUT.PUT_LINE('Statut du rdv 71 (deja REALISE) : ' || v_statut);
  ROLLBACK;
END;
/
-- Resultat attendu : Statut du rdv 71 (deja REALISE) : REALISE
-- (le trigger ne fait rien car le statut n'est ni PLANIFIE ni CONFIRME)

-- ############################################################################
-- EXERCICE 17 [OBL] : STOCK ET PRESCRIPTIONS
-- TRG_PRESCRIPTION_STOCK (BEFORE INSERT OR UPDATE OR DELETE, ligne) :
--   - insertion : stock = stock - quantite, refus si insuffisant (-20701)
--   - suppression : stock = stock + quantite
--   - changement de medicament ou de quantite : ajustement
-- ############################################################################

CREATE OR REPLACE TRIGGER TRG_PRESCRIPTION_STOCK
BEFORE INSERT OR UPDATE OR DELETE ON prescription
FOR EACH ROW
DECLARE
  v_stock medicament.stock%TYPE;
BEGIN
  IF DELETING THEN
    UPDATE medicament
       SET stock = stock + :OLD.quantite
     WHERE id_medicament = :OLD.id_medicament;

  ELSIF INSERTING THEN
    SELECT stock INTO v_stock
      FROM medicament WHERE id_medicament = :NEW.id_medicament;

    IF v_stock < :NEW.quantite THEN
      RAISE_APPLICATION_ERROR(-20701, 'Stock insuffisant');
    END IF;

    UPDATE medicament
       SET stock = stock - :NEW.quantite
     WHERE id_medicament = :NEW.id_medicament;

  ELSIF UPDATING THEN
    IF :NEW.id_medicament <> :OLD.id_medicament THEN
      -- Changement de medicament : rendre l'ancien, debiter le nouveau
      SELECT stock INTO v_stock
        FROM medicament WHERE id_medicament = :NEW.id_medicament;

      IF v_stock < :NEW.quantite THEN
        RAISE_APPLICATION_ERROR(-20701,
          'Stock insuffisant pour le nouveau medicament');
      END IF;

      UPDATE medicament
         SET stock = stock + :OLD.quantite
       WHERE id_medicament = :OLD.id_medicament;

      UPDATE medicament
         SET stock = stock - :NEW.quantite
       WHERE id_medicament = :NEW.id_medicament;

    ELSIF :NEW.quantite <> :OLD.quantite THEN
      -- Changement de quantite seulement
      SELECT stock INTO v_stock
        FROM medicament WHERE id_medicament = :NEW.id_medicament;

      IF v_stock + :OLD.quantite < :NEW.quantite THEN
        RAISE_APPLICATION_ERROR(-20701, 'Stock insuffisant');
      END IF;

      UPDATE medicament
         SET stock = stock + :OLD.quantite - :NEW.quantite
       WHERE id_medicament = :NEW.id_medicament;
    END IF;
  END IF;
END;
/
SHOW ERRORS TRIGGER TRG_PRESCRIPTION_STOCK

-- Test 17.1 : insertion, modification de quantite, suppression
DECLARE
  v_id_ordo NUMBER;
  v_stock   medicament.stock%TYPE;
BEGIN
  SELECT seq_ordonnance.NEXTVAL INTO v_id_ordo FROM dual;
  INSERT INTO ordonnance (id_ordonnance, id_consultation, date_ordonnance,
                          commentaire)
  VALUES (v_id_ordo, 1, SYSDATE, 'Test stock medicament 1');

  INSERT INTO prescription (id_ordonnance, id_medicament, posologie,
                            quantite, instructions)
  VALUES (v_id_ordo, 1, '1 comprime par jour', 10, NULL);

  SELECT stock INTO v_stock FROM medicament WHERE id_medicament = 1;
  DBMS_OUTPUT.PUT_LINE('Apres insertion de 10 : stock = ' || v_stock);  -- 240

  UPDATE prescription
     SET quantite = 5
   WHERE id_ordonnance = v_id_ordo AND id_medicament = 1;

  SELECT stock INTO v_stock FROM medicament WHERE id_medicament = 1;
  DBMS_OUTPUT.PUT_LINE('Apres reduction a 5 : stock = ' || v_stock);   -- 245

  DELETE FROM prescription
   WHERE id_ordonnance = v_id_ordo AND id_medicament = 1;

  SELECT stock INTO v_stock FROM medicament WHERE id_medicament = 1;
  DBMS_OUTPUT.PUT_LINE('Apres suppression : stock = ' || v_stock);     -- 250

  ROLLBACK;
END;
/
-- Resultat attendu : 240, 245, 250

-- Test 17.2 : cas refuse -20701, quantite superieure au stock (med 3)
DECLARE
  v_id_ordo NUMBER;
BEGIN
  SELECT seq_ordonnance.NEXTVAL INTO v_id_ordo FROM dual;
  INSERT INTO ordonnance (id_ordonnance, id_consultation, date_ordonnance,
                          commentaire)
  VALUES (v_id_ordo, 1, SYSDATE, 'Test stock insuffisant medicament 3');

  INSERT INTO prescription (id_ordonnance, id_medicament, posologie,
                            quantite, instructions)
  VALUES (v_id_ordo, 3, '1 gelule par jour', 90, NULL);  -- stock 80 < 90

  DBMS_OUTPUT.PUT_LINE('ERREUR : le stock insuffisant aurait du etre refuse.');
  ROLLBACK;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20701) : ' || SQLERRM);
    ROLLBACK;
END;
/
-- Resultat attendu : ORA-20701: Stock insuffisant


-- ############################################################################
-- EXERCICE 18 [OBL] : STATUT DES FACTURES
-- TRG_FACTURE_STATUT_BU (BEFORE UPDATE OF statut, ligne) :
--   -20801 une facture PAYEE ou ANNULEE ne change plus de statut
--   -20802 une facture PARTIELLE ne revient pas a EMISE
-- ############################################################################

CREATE OR REPLACE TRIGGER TRG_FACTURE_STATUT_BU
BEFORE UPDATE OF statut ON facture
FOR EACH ROW
BEGIN
  IF :NEW.statut <> :OLD.statut THEN
    IF :OLD.statut IN ('PAYEE', 'ANNULEE') THEN
      RAISE_APPLICATION_ERROR(-20801,
        'Facture payee ou annulee : le statut est fige');
    END IF;

    IF :OLD.statut = 'PARTIELLE' AND :NEW.statut = 'EMISE' THEN
      RAISE_APPLICATION_ERROR(-20802,
        'Une facture partielle ne peut pas revenir a emise');
    END IF;
  END IF;
END;
/
SHOW ERRORS TRIGGER TRG_FACTURE_STATUT_BU

-- Test 18.1 : mise a jour sans changement de statut (doit passer)
BEGIN
  UPDATE facture SET statut = statut WHERE id_facture = 1;
  DBMS_OUTPUT.PUT_LINE('Mise a jour sans changement : acceptee.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur inattendue : ' || SQLERRM);
END;
/
ROLLBACK;

-- Test 18.2 : cas refuse -20801, facture 1 est PAYEE
BEGIN
  UPDATE facture SET statut = 'ANNULEE' WHERE id_facture = 1;
  DBMS_OUTPUT.PUT_LINE('ERREUR : la facture payee aurait du rester figee.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20801) : ' || SQLERRM);
END;
/
ROLLBACK;

-- Test 18.3 : cas refuse -20802, facture 2 est PARTIELLE
BEGIN
  UPDATE facture SET statut = 'EMISE' WHERE id_facture = 2;
  DBMS_OUTPUT.PUT_LINE('ERREUR : le retour a EMISE aurait du etre refuse.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20802) : ' || SQLERRM);
END;
/
ROLLBACK;

-- Test 18.4 : cas accepte, facture 3 est EMISE -> PAYEE
UPDATE facture SET statut = 'PAYEE' WHERE id_facture = 3;
SELECT id_facture, statut FROM facture WHERE id_facture = 3;
ROLLBACK;
-- Resultat attendu : id_facture=3, statut=PAYEE


-- ############################################################################
-- EXERCICE 19 [OBL] : JOURNAL DES FACTURES
-- TRG_FACTURE_AUDIT (AFTER INSERT OR UPDATE OR DELETE, ligne) : ecrit dans
-- JOURNAL_OPERATION le type, la table, la cle, l'ancienne et la nouvelle
-- valeur (statut, montant, remise). Utilisateur et date par defaut.
-- ############################################################################

CREATE OR REPLACE TRIGGER TRG_FACTURE_AUDIT
AFTER INSERT OR UPDATE OR DELETE ON facture
FOR EACH ROW
DECLARE
  v_type journal_operation.type_operation%TYPE;
  v_cle  journal_operation.cle_ligne%TYPE;
  v_anc  journal_operation.ancienne_valeur%TYPE;
  v_nouv journal_operation.nouvelle_valeur%TYPE;
BEGIN
  IF INSERTING THEN
    v_type := 'INSERT';
    v_cle  := TO_CHAR(:NEW.id_facture);
    v_nouv := 'statut=' || :NEW.statut ||
              ', montant=' || :NEW.montant_total ||
              ', remise=' || :NEW.remise;

  ELSIF DELETING THEN
    v_type := 'DELETE';
    v_cle  := TO_CHAR(:OLD.id_facture);
    v_anc  := 'statut=' || :OLD.statut ||
              ', montant=' || :OLD.montant_total ||
              ', remise=' || :OLD.remise;

  ELSE
    v_type := 'UPDATE';
    v_cle  := TO_CHAR(:NEW.id_facture);
    v_anc  := 'statut=' || :OLD.statut ||
              ', montant=' || :OLD.montant_total ||
              ', remise=' || :OLD.remise;
    v_nouv := 'statut=' || :NEW.statut ||
              ', montant=' || :NEW.montant_total ||
              ', remise=' || :NEW.remise;
  END IF;

  INSERT INTO journal_operation (id_journal, type_operation, nom_table,
                                 cle_ligne, ancienne_valeur, nouvelle_valeur)
  VALUES (seq_journal.NEXTVAL, v_type, 'FACTURE', v_cle, v_anc, v_nouv);
END;
/
SHOW ERRORS TRIGGER TRG_FACTURE_AUDIT

-- Test 19.1 : INSERT, UPDATE et DELETE sur une facture de test
DECLARE
  v_id_facture facture.id_facture%TYPE;
BEGIN
  SELECT seq_facture.NEXTVAL INTO v_id_facture FROM dual;

  INSERT INTO facture (id_facture, id_patient, id_consultation,
                       date_facture, montant_total, remise, statut)
  VALUES (v_id_facture, 1, 43, SYSDATE, 1000, 0, 'EMISE');

  UPDATE facture SET montant_total = 1200 WHERE id_facture = v_id_facture;

  DELETE FROM facture WHERE id_facture = v_id_facture;

  DBMS_OUTPUT.PUT_LINE('Facture de test : ' || v_id_facture ||
                       ' (INSERT, UPDATE, DELETE effectues)');
END;
/

-- Lecture du journal (les 6 dernieres lignes)
SELECT * FROM (
  SELECT id_journal, utilisateur, date_operation, type_operation, nom_table,
         cle_ligne, ancienne_valeur, nouvelle_valeur
    FROM journal_operation
   WHERE nom_table = 'FACTURE'
   ORDER BY id_journal DESC
) WHERE ROWNUM <= 6;
ROLLBACK;
-- Resultat attendu : trois lignes pour la facture de test
--   INSERT : ancienne_valeur NULL, nouvelle_valeur statut=EMISE...
--   UPDATE : ancienne valeur montant=1000, nouvelle montant=1200
--   DELETE : ancienne valeur montant=1200..., nouvelle NULL
-- utilisateur et date_operation sont remplis par les valeurs par defaut.


-- ############################################################################
-- EXERCICE 20 [OBL] : GERER LES TRIGGERS
-- Interroger USER_TRIGGERS et USER_ERRORS, desactiver TRG_FACTURE_STATUT_BU,
-- constater qu'une facture payee peut changer de statut, puis reactiver.
-- ############################################################################

SELECT trigger_name, table_name, triggering_event, trigger_type, status
  FROM user_triggers
 ORDER BY table_name, trigger_name;

SELECT name, type, line, position, text
  FROM user_errors
 ORDER BY name, sequence;

-- Desactivation du trigger
ALTER TRIGGER TRG_FACTURE_STATUT_BU DISABLE;

-- La facture 1 (PAYEE) peut maintenant changer de statut
UPDATE facture SET statut = 'ANNULEE' WHERE id_facture = 1;
SELECT id_facture, statut FROM facture WHERE id_facture = 1;
-- Resultat attendu : ANNULEE (la regle est contournee car le trigger est desactive)

-- Annulation de la modification puis reactivation du trigger
ROLLBACK;
ALTER TRIGGER TRG_FACTURE_STATUT_BU ENABLE;

SELECT trigger_name, status
  FROM user_triggers
 WHERE trigger_name = 'TRG_FACTURE_STATUT_BU';
-- Resultat attendu : ENABLED

-- Pourquoi desactiver avant de modifier ?
-- Pour effectuer une correction legitime (maintenance, donnees erronees,
-- correction de saisie) sans que la regle metier ne bloque l'operation.
-- On desactive temporairement, on corrige, puis on reactive immediatement.
-- En production, l'operation doit etre tracee et limitee dans le temps.

-- ############################################################################
-- EXERCICE 21 [OPT] : HOSPITALISATION ET CHAMBRE
-- TRG_HOSPIT_BIU (BEFORE INSERT OR UPDATE OF id_chambre) :
--   -20301 chambre indisponible (DISPONIBLE = 'N')
--   -20302 chambre inexistante
--   et remplit COUT_JOURNALIER avec le tarif de la chambre s'il est absent.
-- Rappel : FK composite (ID_CHAMBRE, ID_SERVICE), il faut aussi changer
-- le service de l'hospitalisation.
-- ############################################################################

CREATE OR REPLACE TRIGGER TRG_HOSPIT_BIU
BEFORE INSERT OR UPDATE OF id_chambre ON hospitalisation
FOR EACH ROW
DECLARE
  v_dispo chambre.disponible%TYPE;
  v_tarif chambre.tarif_journalier%TYPE;
  v_nb    NUMBER;
BEGIN
  -- Chambre existante ?
  SELECT COUNT(*) INTO v_nb FROM chambre WHERE id_chambre = :NEW.id_chambre;
  IF v_nb = 0 THEN
    RAISE_APPLICATION_ERROR(-20302, 'Chambre inexistante');
  END IF;

  SELECT disponible, tarif_journalier
    INTO v_dispo, v_tarif
    FROM chambre
   WHERE id_chambre = :NEW.id_chambre;

  -- Chambre disponible ?
  IF v_dispo = 'N' THEN
    RAISE_APPLICATION_ERROR(-20301, 'Chambre indisponible');
  END IF;

  -- Remplir le cout journalier s'il est absent
  IF :NEW.cout_journalier IS NULL THEN
    :NEW.cout_journalier := v_tarif;
  END IF;
END;
/
SHOW ERRORS TRIGGER TRG_HOSPIT_BIU

-- Test 21.1 : chambre 1 (disponible, tarif 4500) pour l'hospitalisation 6
-- L'hospitalisation 6 est en service 10/chambre 19 : on change aussi le service
-- pour respecter la FK composite (ID_CHAMBRE, ID_SERVICE).
UPDATE hospitalisation
   SET id_chambre = 1,
       id_service = 1,
       cout_journalier = NULL
 WHERE id_hospitalisation = 6;

SELECT id_hospitalisation, id_chambre, id_service, cout_journalier
  FROM hospitalisation
 WHERE id_hospitalisation = 6;
ROLLBACK;
-- Resultat attendu : id_chambre=1, id_service=1, cout_journalier=4500

-- Test 21.2 : cas refuse -20302, chambre inexistante
BEGIN
  UPDATE hospitalisation
     SET id_chambre = 99999, id_service = 10
   WHERE id_hospitalisation = 6;
  DBMS_OUTPUT.PUT_LINE('ERREUR : la chambre inexistante aurait du etre refusee.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20302) : ' || SQLERRM);
END;
/
ROLLBACK;

-- Test 21.3 : cas refuse -20301, chambre 19 rendue indisponible
UPDATE chambre SET disponible = 'N' WHERE id_chambre = 19;

BEGIN
  UPDATE hospitalisation
     SET id_chambre = 19, id_service = 10
   WHERE id_hospitalisation = 6;
  DBMS_OUTPUT.PUT_LINE('ERREUR : la chambre indisponible aurait du etre refusee.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20301) : ' || SQLERRM);
END;
/
ROLLBACK;
-- Resultat attendu : ORA-20301 (le ROLLBACK remet la chambre 19 disponible)


-- ############################################################################
-- EXERCICE 22 [OPT] : LE CHEF APPARTIENT A SON SERVICE
-- TRG_SERVICE_CHEF (BEFORE INSERT OR UPDATE OF id_medecin_chef, WHEN) :
--   -20501 le medecin chef doit appartenir a la clinique du service
--   -20502 le medecin chef doit exister
-- Remarque : dans ce schema, MEDECIN est lie a CLINIQUE (pas a SERVICE) ;
-- la regle se verifie donc au niveau de la clinique.
-- ############################################################################

CREATE OR REPLACE TRIGGER TRG_SERVICE_CHEF
BEFORE INSERT OR UPDATE OF id_medecin_chef ON service
FOR EACH ROW
WHEN (NEW.id_medecin_chef IS NOT NULL)
DECLARE
  v_nb               NUMBER;
  v_clinique_medecin service.id_clinique%TYPE;
BEGIN
  -- Le medecin existe-t-il ?
  SELECT COUNT(*) INTO v_nb
    FROM medecin
   WHERE id_medecin = :NEW.id_medecin_chef;

  IF v_nb = 0 THEN
    RAISE_APPLICATION_ERROR(-20502, 'Medecin chef inexistant');
  END IF;

  -- Le medecin appartient-il a la clinique du service ?
  SELECT m.id_clinique INTO v_clinique_medecin
    FROM medecin m
   WHERE m.id_medecin = :NEW.id_medecin_chef;

  IF v_clinique_medecin <> :NEW.id_clinique THEN
    RAISE_APPLICATION_ERROR(-20501,
      'Le medecin chef doit appartenir a la clinique du service qu il dirige');
  END IF;
END;
/
SHOW ERRORS TRIGGER TRG_SERVICE_CHEF

-- Test 22.1 : medecin 2 (clinique 1) chef du service 1 (clinique 1)
UPDATE service SET id_medecin_chef = 2 WHERE id_service = 1;
SELECT id_service, id_medecin_chef FROM service WHERE id_service = 1;
ROLLBACK;
-- Resultat attendu : id_medecin_chef = 2 (accepte)

-- Test 22.2 : medecin 3 (clinique 1) chef du service 1 (clinique 1)
UPDATE service SET id_medecin_chef = 3 WHERE id_service = 1;
SELECT id_service, id_medecin_chef FROM service WHERE id_service = 1;
ROLLBACK;
-- Resultat attendu : id_medecin_chef = 3 (accepte)

-- Test 22.3 : cas refuse -20501, medecin 5 (clinique 2) pour le service 1
BEGIN
  UPDATE service SET id_medecin_chef = 5 WHERE id_service = 1;
  DBMS_OUTPUT.PUT_LINE('ERREUR : le medecin d une autre clinique aurait du etre refuse.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20501) : ' || SQLERRM);
END;
/
ROLLBACK;

-- Test 22.4 : cas refuse -20502, medecin inexistant
BEGIN
  UPDATE service SET id_medecin_chef = 99999 WHERE id_service = 1;
  DBMS_OUTPUT.PUT_LINE('ERREUR : le medecin inexistant aurait du etre refuse.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20502) : ' || SQLERRM);
END;
/
ROLLBACK;


-- ############################################################################
-- EXERCICE 23 [OPT] : MEDICAMENT PERIME
-- TRG_PRESCRIPTION_PEREMPTION (BEFORE INSERT) : refuse de prescrire un
-- medicament dont DATE_PEREMPTION est depassee (-20901).
-- ############################################################################

CREATE OR REPLACE TRIGGER TRG_PRESCRIPTION_PEREMPTION
BEFORE INSERT ON prescription
FOR EACH ROW
DECLARE
  v_peremption medicament.date_peremption%TYPE;
BEGIN
  SELECT date_peremption INTO v_peremption
    FROM medicament
   WHERE id_medicament = :NEW.id_medicament;

  IF v_peremption IS NOT NULL AND v_peremption < TRUNC(SYSDATE) THEN
    RAISE_APPLICATION_ERROR(-20901,
      'Medicament perime : prescription refusee');
  END IF;
END;
/
SHOW ERRORS TRIGGER TRG_PRESCRIPTION_PEREMPTION

-- Test 23.1 : cas accepte, medicament 1 non perime (2028)
DECLARE
  v_id_ordo NUMBER;
BEGIN
  SELECT seq_ordonnance.NEXTVAL INTO v_id_ordo FROM dual;
  INSERT INTO ordonnance (id_ordonnance, id_consultation, date_ordonnance,
                          commentaire)
  VALUES (v_id_ordo, 1, SYSDATE, 'Test medicament non perime');

  INSERT INTO prescription (id_ordonnance, id_medicament, posologie,
                            quantite, instructions)
  VALUES (v_id_ordo, 1, '1 comprime par jour', 5, NULL);

  DBMS_OUTPUT.PUT_LINE('Prescription medicament 1 (non perime) : acceptee.');
  ROLLBACK;
END;
/
-- Resultat attendu : Prescription medicament 1 (non perime) : acceptee.

-- Test 23.2 : cas refuse -20901, medicament 3 perime pour le test
DECLARE
  v_id_ordo NUMBER;
BEGIN
  UPDATE medicament
     SET date_peremption = DATE '2020-01-01'
   WHERE id_medicament = 3;

  SELECT seq_ordonnance.NEXTVAL INTO v_id_ordo FROM dual;
  INSERT INTO ordonnance (id_ordonnance, id_consultation, date_ordonnance,
                          commentaire)
  VALUES (v_id_ordo, 1, SYSDATE, 'Test medicament perime');

  INSERT INTO prescription (id_ordonnance, id_medicament, posologie,
                            quantite, instructions)
  VALUES (v_id_ordo, 3, '1 gelule par jour', 5, NULL);

  DBMS_OUTPUT.PUT_LINE('ERREUR : le medicament perime aurait du etre refuse.');
  ROLLBACK;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20901) : ' || SQLERRM);
    ROLLBACK;  -- annule aussi le perimement du medicament 3
END;
/
-- Resultat attendu : ORA-20901

SELECT id_medicament, date_peremption, stock
  FROM medicament WHERE id_medicament = 3;
-- Resultat attendu apres ROLLBACK : date 15/04/2027, stock 80

-- ############################################################################
-- EXERCICE 24 [OPT] : AUDIT SANS DONNEES SENSIBLES
-- TRG_PATIENT_AUDIT journalise seulement les NOMS des colonnes modifiees,
-- jamais les valeurs medicales.
-- Dans ce schema, les colonnes d'identite (nom, prenom, adresse, ville,
-- telephone, email) sont dans PERSONNE : un second trigger les couvre.
-- ############################################################################

CREATE OR REPLACE TRIGGER TRG_PATIENT_AUDIT
AFTER UPDATE ON patient
FOR EACH ROW
DECLARE
  v_modifiees VARCHAR2(400) := '';
BEGIN
  IF NVL(:OLD.groupe_sanguin, '<NULL>') <> NVL(:NEW.groupe_sanguin, '<NULL>') THEN
    v_modifiees := v_modifiees || 'groupe_sanguin, ';
  END IF;

  IF NVL(:OLD.antecedents, '<NULL>') <> NVL(:NEW.antecedents, '<NULL>') THEN
    v_modifiees := v_modifiees || 'antecedents, ';
  END IF;

  IF NVL(:OLD.allergies, '<NULL>') <> NVL(:NEW.allergies, '<NULL>') THEN
    v_modifiees := v_modifiees || 'allergies, ';
  END IF;

  IF v_modifiees IS NOT NULL THEN
    INSERT INTO journal_operation (id_journal, type_operation, nom_table,
                                   cle_ligne, nouvelle_valeur)
    VALUES (seq_journal.NEXTVAL, 'UPDATE', 'PATIENT',
            TO_CHAR(:NEW.id_patient), RTRIM(v_modifiees, ', '));
  END IF;
END;
/
SHOW ERRORS TRIGGER TRG_PATIENT_AUDIT

-- Test 24.1 : modification d'une colonne medicale (antecedents)
UPDATE patient SET antecedents = 'Nouvel antecedent' WHERE id_patient = 1;

SELECT id_journal, type_operation, nom_table, cle_ligne, nouvelle_valeur
  FROM journal_operation
 WHERE nom_table = 'PATIENT' AND cle_ligne = '1'
 ORDER BY id_journal DESC;
ROLLBACK;
-- Resultat attendu : une ligne avec nouvelle_valeur = 'antecedents'
-- (le nom de la colonne, pas la valeur medicale)

-- Test 24.2 : modification d'une colonne non surveillee (tel_contact)
UPDATE patient SET tel_contact = '0600000000' WHERE id_patient = 1;

SELECT COUNT(*) AS nb_lignes_journal
  FROM journal_operation
 WHERE nom_table = 'PATIENT' AND cle_ligne = '1';
ROLLBACK;
-- Resultat attendu : 0 (cette colonne n'est pas dans la liste surveillee)

-- Second trigger pour les colonnes d'identite situees dans PERSONNE
CREATE OR REPLACE TRIGGER TRG_PERSONNE_PATIENT_AUDIT
AFTER UPDATE ON personne
FOR EACH ROW
DECLARE
  v_id_patient patient.id_patient%TYPE;
  v_modifiees  VARCHAR2(400) := '';
BEGIN
  -- On ne journalise que les personnes qui sont des patients
  BEGIN
    SELECT id_patient INTO v_id_patient
      FROM patient
     WHERE id_personne = :NEW.id_personne;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN;
  END;

  IF NVL(:OLD.nom, '<NULL>') <> NVL(:NEW.nom, '<NULL>') THEN
    v_modifiees := v_modifiees || 'nom, ';
  END IF;

  IF NVL(:OLD.prenom, '<NULL>') <> NVL(:NEW.prenom, '<NULL>') THEN
    v_modifiees := v_modifiees || 'prenom, ';
  END IF;

  IF NVL(:OLD.adresse, '<NULL>') <> NVL(:NEW.adresse, '<NULL>') THEN
    v_modifiees := v_modifiees || 'adresse, ';
  END IF;

  IF NVL(:OLD.ville, '<NULL>') <> NVL(:NEW.ville, '<NULL>') THEN
    v_modifiees := v_modifiees || 'ville, ';
  END IF;

  IF NVL(:OLD.telephone, '<NULL>') <> NVL(:NEW.telephone, '<NULL>') THEN
    v_modifiees := v_modifiees || 'telephone, ';
  END IF;

  IF NVL(:OLD.email, '<NULL>') <> NVL(:NEW.email, '<NULL>') THEN
    v_modifiees := v_modifiees || 'email, ';
  END IF;

  IF v_modifiees IS NOT NULL THEN
    INSERT INTO journal_operation (id_journal, type_operation, nom_table,
                                   cle_ligne, nouvelle_valeur)
    VALUES (seq_journal.NEXTVAL, 'UPDATE', 'PATIENT',
            TO_CHAR(v_id_patient), RTRIM(v_modifiees, ', '));
  END IF;
END;
/
SHOW ERRORS TRIGGER TRG_PERSONNE_PATIENT_AUDIT

-- Test 24.3 : modification d'une colonne d'identite (nom dans PERSONNE)
UPDATE personne SET nom = '  bensalem  ' WHERE id_personne = 1;

SELECT id_journal, type_operation, nom_table, cle_ligne, nouvelle_valeur
  FROM journal_operation
 WHERE nom_table = 'PATIENT' AND cle_ligne = '1'
 ORDER BY id_journal DESC;
ROLLBACK;
-- Resultat attendu : une ligne avec nouvelle_valeur = 'nom'
-- (toujours le nom de la colonne, pas la valeur)

-- Pourquoi ne pas ecrire les valeurs medicales dans le journal ?
-- Le journal d'audit peut etre consulte par des personnes non medicales
-- (administration, support, maintenance). Y ecrire les antecedents, allergies
-- ou groupe sanguin divulguerait des donnees de sante sensibles. On conserve
-- seulement la trace des colonnes modifiees, ce qui suffit pour l'audit.


-- ############################################################################
-- EXERCICE 25 [OPT] : TABLE MUTANTE ET STATUT DES FACTURES
-- (a) trigger ligne qui lit PAIEMENT -> ORA-04091, puis suppression
-- (b) package + trigger ligne de memorisation + trigger instruction de
--     traitement : statut PARTIELLE ou PAYEE, refus si total > montant net
--     (-20951)
-- ############################################################################

-- ---------------------------------------------------------------------------
-- 25 (a) : demonstration de la table mutante
-- ---------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER trg_paiement_mutant
AFTER INSERT ON paiement
FOR EACH ROW
DECLARE
  v_somme NUMBER;
BEGIN
  -- Un trigger ligne ne peut pas lire la table qui est en cours de modification
  SELECT SUM(montant) INTO v_somme
    FROM paiement
   WHERE id_facture = :NEW.id_facture;
END;
/
SHOW ERRORS TRIGGER trg_paiement_mutant

BEGIN
  INSERT INTO paiement (id_paiement, id_facture, date_paiement, montant,
                        mode_paiement, reference_paiement)
  VALUES (seq_paiement.NEXTVAL, 3, SYSDATE, 1000, 'ESPECES', 'TEST-MUTANT');

  DBMS_OUTPUT.PUT_LINE('ERREUR : ORA-04091 aurait du se produire.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (ORA-04091) : ' || SQLERRM);
END;
/
ROLLBACK;

DROP TRIGGER trg_paiement_mutant;

-- Explication : ORA-04091 (table mutante) signifie que le trigger ligne tente
-- de lire PAIEMENT alors que PAIEMENT est en cours de modification par
-- l'INSERT. Oracle interdit cette lecture pour eviter un resultat incoherent
-- (la ligne en cours n'est pas encore validee). La solution est de memoriser
-- les factures dans un package (trigger ligne) et de les traiter apres
-- l'instruction avec un trigger instruction (voir 25 b).

-- ---------------------------------------------------------------------------
-- 25 (b) : correction avec package + trigger ligne + trigger instruction
-- ---------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE pkg_paiement_audit IS
  TYPE t_factures IS TABLE OF facture.id_facture%TYPE INDEX BY BINARY_INTEGER;

  g_factures t_factures;
  g_idx      NUMBER := 0;

  PROCEDURE ajouter_facture(p_id IN facture.id_facture%TYPE);
  PROCEDURE traiter_factures;
END pkg_paiement_audit;
/
SHOW ERRORS PACKAGE pkg_paiement_audit

CREATE OR REPLACE PACKAGE BODY pkg_paiement_audit IS
  PROCEDURE ajouter_facture(p_id IN facture.id_facture%TYPE) IS
  BEGIN
    g_idx := g_idx + 1;
    g_factures(g_idx) := p_id;
  END ajouter_facture;

  PROCEDURE traiter_factures IS
    v_net          facture.montant_total%TYPE;
    v_remise       facture.remise%TYPE;
    v_paye         NUMBER;
    v_net_a_payer  NUMBER;
  BEGIN
    FOR i IN 1 .. g_idx LOOP
      SELECT montant_total, remise
        INTO v_net, v_remise
        FROM facture
       WHERE id_facture = g_factures(i);

      v_net_a_payer := v_net * (1 - v_remise / 100);

      SELECT NVL(SUM(montant), 0)
        INTO v_paye
        FROM paiement
       WHERE id_facture = g_factures(i);

      IF v_paye > v_net_a_payer THEN
        RAISE_APPLICATION_ERROR(-20951,
          'Total paye superieur au montant net de la facture');
      END IF;

      IF v_paye = v_net_a_payer THEN
        UPDATE facture
           SET statut = 'PAYEE'
         WHERE id_facture = g_factures(i);
      ELSIF v_paye > 0 THEN
        UPDATE facture
           SET statut = 'PARTIELLE'
         WHERE id_facture = g_factures(i);
      END IF;
    END LOOP;

    g_idx := 0;
  EXCEPTION
    WHEN OTHERS THEN
      g_idx := 0;  -- ne pas conserver un etat incomplet
      RAISE;
  END traiter_factures;
END pkg_paiement_audit;
/
SHOW ERRORS PACKAGE BODY pkg_paiement_audit

-- Trigger ligne : memorise la facture sans lire PAIEMENT
CREATE OR REPLACE TRIGGER trg_paiement_ligne
AFTER INSERT ON paiement
FOR EACH ROW
BEGIN
  pkg_paiement_audit.ajouter_facture(:NEW.id_facture);
END;
/
SHOW ERRORS TRIGGER trg_paiement_ligne

-- Trigger instruction : traite les factures memorisees apres l'instruction
CREATE OR REPLACE TRIGGER trg_paiement_instruction
AFTER INSERT ON paiement
BEGIN
  pkg_paiement_audit.traiter_factures;
END;
/
SHOW ERRORS TRIGGER trg_paiement_instruction

-- Test 25b.1 : facture 3 (EMISE, net 8500), paiement partiel de 1000
DECLARE
  v_id_paiement NUMBER;
BEGIN
  SELECT seq_paiement.NEXTVAL INTO v_id_paiement FROM dual;
  INSERT INTO paiement (id_paiement, id_facture, date_paiement, montant,
                        mode_paiement, reference_paiement)
  VALUES (v_id_paiement, 3, SYSDATE, 1000, 'ESPECES', 'TEST-FACT3-PARTIEL');
  DBMS_OUTPUT.PUT_LINE('Paiement partiel de 1000 insere.');
END;
/
SELECT id_facture, statut FROM facture WHERE id_facture = 3;
ROLLBACK;
-- Resultat attendu : statut = PARTIELLE

-- Test 25b.2 : facture 3 (EMISE, net 8500), paiement de 8500 -> PAYEE
DECLARE
  v_id_paiement NUMBER;
BEGIN
  SELECT seq_paiement.NEXTVAL INTO v_id_paiement FROM dual;
  INSERT INTO paiement (id_paiement, id_facture, date_paiement, montant,
                        mode_paiement, reference_paiement)
  VALUES (v_id_paiement, 3, SYSDATE, 8500, 'CARTE', 'TEST-FACT3-SOLDE');
  DBMS_OUTPUT.PUT_LINE('Paiement de 8500 insere.');
END;
/
SELECT id_facture, statut FROM facture WHERE id_facture = 3;
ROLLBACK;
-- Resultat attendu : statut = PAYEE

-- Test 25b.3 : facture 2 (PARTIELLE, net 6000, deja 3000 payes), + 3000
DECLARE
  v_id_paiement NUMBER;
BEGIN
  SELECT seq_paiement.NEXTVAL INTO v_id_paiement FROM dual;
  INSERT INTO paiement (id_paiement, id_facture, date_paiement, montant,
                        mode_paiement, reference_paiement)
  VALUES (v_id_paiement, 2, SYSDATE, 3000, 'ESPECES', 'TEST-FACT2-SOLDE');
  DBMS_OUTPUT.PUT_LINE('Paiement de 3000 insere (solde de la facture 2).');
END;
/
SELECT id_facture, statut FROM facture WHERE id_facture = 2;
ROLLBACK;
-- Resultat attendu : statut = PAYEE

-- Test 25b.4 : cas refuse -20951, total paye superieur au montant net
BEGIN
  INSERT INTO paiement (id_paiement, id_facture, date_paiement, montant,
                        mode_paiement, reference_paiement)
  VALUES (seq_paiement.NEXTVAL, 3, SYSDATE, 9000, 'CARTE', 'TEST-DEPASS');

  DBMS_OUTPUT.PUT_LINE('ERREUR : le depassement aurait du etre refuse.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20951) : ' || SQLERRM);
END;
/
ROLLBACK;

SELECT id_facture, statut FROM facture WHERE id_facture = 3;
SELECT COUNT(*) AS nb_paiements_test
  FROM paiement WHERE reference_paiement = 'TEST-DEPASS';
-- Resultat attendu : statut = EMISE et 0 paiement (l'INSERT a ete annule)

PROMPT ============================================================
PROMPT  VERIFICATIONS FINALES
PROMPT ============================================================

-- Liste des procedures, fonctions et packages
SELECT object_name, object_type, status
  FROM user_objects
 WHERE object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY')
 ORDER BY object_type, object_name;

-- Liste des triggers et leur statut
SELECT trigger_name, table_name, triggering_event, trigger_type, status
  FROM user_triggers
 ORDER BY table_name, trigger_name;

-- Erreurs de compilation eventuelles
SELECT name, type, line, position, text
  FROM user_errors
 ORDER BY name, sequence;

-- Verification que la base est revenue a son etat initial
SELECT 'PATIENT' AS table_name, COUNT(*) AS nb FROM patient
UNION ALL SELECT 'PERSONNE', COUNT(*) FROM personne
UNION ALL SELECT 'RENDEZ_VOUS', COUNT(*) FROM rendez_vous
UNION ALL SELECT 'CONSULTATION', COUNT(*) FROM consultation
UNION ALL SELECT 'FACTURE', COUNT(*) FROM facture
UNION ALL SELECT 'PAIEMENT', COUNT(*) FROM paiement
ORDER BY 1;
-- Resultat attendu (base du TP1 non modifiee) :
--   CONSULTATION 70, FACTURE 80, PAIEMENT 62, PATIENT 50,
--   PERSONNE 65, RENDEZ_VOUS 100


-- ============================================================================
-- REPONSES AUX QUESTIONS THEORIQUES (a recopier dans le rapport)
-- ============================================================================
--
-- 1. Curseur implicite et curseur explicite
--    Le curseur implicite (SQL) est cree, ouvert, alimente et ferme
--    automatiquement par Oracle pour chaque instruction SQL ; on le consulte
--    avec SQL%FOUND, SQL%NOTFOUND, SQL%ROWCOUNT. Le curseur explicite est
--    declare par le programmeur, puis ouvert avec OPEN, parcouru avec FETCH et
--    ferme avec CLOSE ; il possede %FOUND, %NOTFOUND, %ROWCOUNT et %ISOPEN.
--
-- 2. Procedure et fonction
--    Une procedure execute des actions et s'appelle comme une instruction
--    (EXEC/CALL), alors qu'une fonction retourne obligatoirement une valeur
--    avec RETURN et peut etre utilisee dans une expression SQL ou PL/SQL.
--
-- 3. Trigger BEFORE et trigger AFTER
--    Un trigger BEFORE s'execute avant l'ecriture de la ligne : il controle ou
--    corrige les valeurs avec :NEW (ex. normalisation, refus d'une date).
--    Un trigger AFTER s'execute apres l'ecriture : il propage des effets sur
--    d'autres tables (journal d'audit, changement de statut, stock).
--
-- 4. ORA-04091 (table mutante)
--    ORA-04091 survient lorsqu'un trigger ligne tente de lire ou de modifier la
--    table qui est en cours de modification : Oracle interdit cette lecture car
--    la ligne en cours n'est pas encore dans un etat coherent. La solution
--    classique sous Oracle 10g est un package qui memorise les lignes dans un
--    trigger ligne, puis les traite dans un trigger instruction (exercice 25).
--
-- 5. NO_DATA_FOUND et TOO_MANY_ROWS (exercice 4)
--    NO_DATA_FOUND : le SELECT INTO n'a retourne aucune ligne (0 ligne).
--    TOO_MANY_ROWS : le SELECT INTO a retourne plusieurs lignes alors qu'une
--    seule etait attendue (n lignes). Un SELECT INTO doit retourner exactement
--    une ligne.
--
-- 6. Pourquoi desactiver un trigger avant de modifier ? (exercice 20)
--    Pour effectuer une correction legitime (maintenance, donnees erronees,
--    correction de saisie) sans que la regle metier ne bloque l'operation.
--    On desactive temporairement, on corrige, puis on reactive immediatement.
--    En production, l'operation doit etre tracee et limitee dans le temps.
--
-- 7. Pourquoi ne pas ecrire de valeurs medicales dans le journal ? (exercice 24)
--    Le journal d'audit peut etre lu par des personnes non medicales
--    (administration, support). Y ecrire les antecedents, allergies ou groupe
--    sanguin divulguerait des donnees de sante sensibles. On journalise donc
--    seulement les noms des colonnes modifiees.
--
-- 8. Contrainte, procedure ou trigger ?
--    Une contrainte (CHECK, UNIQUE, FK) est preferee quand elle suffit : elle
--    est declarative, plus rapide et protege toutes les voies d'ecriture. Une
--    procedure sert a encapsuler un traitement appele explicitement. Un trigger
--    sert aux regles metier transversales qu'une contrainte ne peut pas
--    exprimer (report de stock, audit, changement de statut lie).
--
-- ============================================================================
-- FIN DU SCRIPT TP2 - EL_SAHA
-- ============================================================================

-- SPOOL OFF

